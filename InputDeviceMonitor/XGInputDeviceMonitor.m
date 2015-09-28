//
//  XGMicMonitor.m
//  MicDetection
//
//  Created by Boris Remizov on 27/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGInputDeviceMonitor.h"
@import CoreAudio;
@import AudioToolbox;

@interface XGInputDeviceMonitor()

@property (nonatomic) float currentSignalLevel;

@end


@implementation XGInputDeviceMonitor
{
	AudioObjectID _currentInput;
	AudioQueueRef _inputAudioQueue;
	dispatch_queue_t _inputDispatchQueue;
}

@dynamic inputDevicePresents;

+ (instancetype)sharedMonitor
{
	static XGInputDeviceMonitor* singleton = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [XGInputDeviceMonitor new];
	});
	return singleton;
}

- (instancetype)init
{
	self = [super init];
	if (!self)
		return nil;

	// monitor change of the default input device
	AudioObjectPropertyAddress address = {
		kAudioHardwarePropertyDefaultInputDevice,
		kAudioObjectPropertyScopeGlobal,
		0
	};
	OSStatus result = AudioObjectAddPropertyListenerBlock(kAudioObjectSystemObject, &address, dispatch_get_main_queue(), ^(UInt32 inNumberAddresses, const AudioObjectPropertyAddress* inAddresses) {

		printf("Input configuration changed\n");
		[self updateCurrentInput];
	});

	if (noErr != result)
	{
		printf("Error %d listening the kAudioHardwarePropertyDefaultInputDevice property change\n", result);
		return nil;
	}

	// perform microphone monitoring in separate thread
	_inputDispatchQueue = dispatch_queue_create("XGInputDetectionQueue", DISPATCH_QUEUE_SERIAL);

	[self updateCurrentInput];

	return self;
}

- (void)dealloc
{
	[self stopAudioInputMonitoring];
}

- (BOOL)inputDevicePresents
{
	return 0 != _currentInput;
}

- (void)updateCurrentInput
{
	printf("%s\n", __PRETTY_FUNCTION__);

	assert(_inputDispatchQueue);

	// monitor change of the default input device
	AudioObjectPropertyAddress address = {
		kAudioHardwarePropertyDefaultInputDevice,
		kAudioObjectPropertyScopeGlobal,
		0
	};

	// check current input device is configured
	AudioObjectID defaultInput = 0;
	UInt32 dataSize = sizeof(defaultInput);
	OSStatus result = AudioObjectGetPropertyData(kAudioObjectSystemObject, &address, 0, NULL, &dataSize, &defaultInput);
	if (noErr != result)
	{
		printf("Can't get the kAudioHardwarePropertyDefaultInputDevice property value, error %d\n", result);
		[self stopAudioInputMonitoring];
		return;
	}

	printf("Default audio input is 0x%x\n", defaultInput);

	if (_currentInput == defaultInput)
		return;

	if (0 == defaultInput)
		[self stopAudioInputMonitoring];

	[self willChangeValueForKey:@"inputDevicePresents"];
	_currentInput = defaultInput;
	[self didChangeValueForKey:@"inputDevicePresents"];
}

- (BOOL)startAudioInputMonitoring:(NSError**)error
{
	if (_inputAudioQueue)
		return TRUE;			// already started

	NSError __autoreleasing* internalError = nil;
	if (NULL == error)
		error = &internalError;

	if (0 == _currentInput)
	{
		// no configured input devices found
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:hardwareConfigErr userInfo:nil];
		return FALSE;
	}

	// start audio queue on default input
	AudioStreamBasicDescription inputFormat = {0};

	inputFormat.mSampleRate = 44100;	// TODO: get current/default sample rate for the device
	inputFormat.mFormatID = kAudioFormatLinearPCM;
	inputFormat.mFormatFlags = kAudioFormatFlagsNativeFloatPacked;
	inputFormat.mFramesPerPacket = 1;
	inputFormat.mChannelsPerFrame = 1;
	inputFormat.mBitsPerChannel = 32;
	inputFormat.mBytesPerFrame = inputFormat.mChannelsPerFrame * inputFormat.mBitsPerChannel / 8;
	inputFormat.mBytesPerPacket = inputFormat.mBytesPerFrame * inputFormat.mFramesPerPacket;
	AudioQueueNewInputWithDispatchQueue(&_inputAudioQueue, &inputFormat, 0, _inputDispatchQueue, ^(AudioQueueRef  _Nonnull inAQ, AudioQueueBufferRef  _Nonnull inBuffer, const AudioTimeStamp * _Nonnull inStartTime, UInt32 inNumberPacketDescriptions, const AudioStreamPacketDescription * _Nullable inPacketDescs) {

		// analyze agerage power of input signal
		AudioQueueLevelMeterState channels[1];		// we only use MONO
		UInt32 dataSize = sizeof(channels);
		OSStatus result = AudioQueueGetProperty(_inputAudioQueue,kAudioQueueProperty_CurrentLevelMeter, channels, &dataSize);
		if (noErr != result)
		{
			printf("Error %d getting level meters\n", result);
			return;
		}

		// TODO: analyze level metters and make verdict about attachement of the mic
		Float32 leftChannelLevel = channels[0].mAveragePower;
		dispatch_async(dispatch_get_main_queue(), ^{
			self.currentSignalLevel = leftChannelLevel;
		});

		// return buffer to the queue
		result = AudioQueueEnqueueBuffer(_inputAudioQueue, inBuffer, 0, NULL);
		if (noErr != result)
		{
			printf("Error %d returning buffer to audio queue\n", result);
		}
	});

	// enable metering of volume lever
	UInt32 enable = 1;
	OSStatus result = AudioQueueSetProperty(_inputAudioQueue, kAudioQueueProperty_EnableLevelMetering, &enable, sizeof(enable));
	if (noErr != result)
	{
		printf("Error %d enabing level mettering on input device", result);
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
		return FALSE;
	}

	// enqueue buffers to allow receive data to the queue before start
	for (int index = 0; index < 2 /* MAX_BUFFER_NUMBER_2_IS_SUFFICIENT_I_BELIEVE */; ++index)
	{
		AudioQueueBufferRef audioBuffer = NULL;
		OSStatus result = AudioQueueAllocateBuffer(_inputAudioQueue, 512, &audioBuffer);
		if (noErr != result)
		{
			printf("Error %d allocating audio buffer\n", result);
			*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
			return FALSE;
		}

		result = AudioQueueEnqueueBuffer(_inputAudioQueue, audioBuffer, 0, NULL);
		if (noErr != result)
		{
			printf("Error %d enqueueing audio buffer\n", result);
			*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
			return FALSE;
		}
	}

	result = AudioQueueStart(_inputAudioQueue, NULL);
	if (noErr != result)
	{
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:result userInfo:nil];
		return FALSE;
	}

	return TRUE;
}

- (void)stopAudioInputMonitoring
{
	printf("%s\n", __PRETTY_FUNCTION__);

	if (NULL == _inputAudioQueue)
		return;

	self.currentSignalLevel = 0;

	AudioQueueStop(_inputAudioQueue, YES);
	AudioQueueDispose(_inputAudioQueue, YES);
	_inputAudioQueue = NULL;
}

@end
