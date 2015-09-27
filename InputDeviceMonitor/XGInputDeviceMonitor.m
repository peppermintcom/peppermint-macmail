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

@end


@implementation XGInputDeviceMonitor
{
	AudioQueueRef _inputAudioQueue;
	dispatch_queue_t _inputDispatchQueue;
}

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

	// start microphone monitoring by opening default input device and monitoring signal level on it
	_inputDispatchQueue = dispatch_queue_create("XGInputDetectionQueue", DISPATCH_QUEUE_SERIAL);

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
		printf("mAveragePower = %f\n", channels[0].mAveragePower);

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
		return nil;
	}

	// enqueue buffers to allow receive data to the queue before start
	for (int index = 0; index < 2 /* MAX_BUFFER_NUMBER_2_IS_SUFFICIENT_I_BELIEVE */; ++index)
	{
		AudioQueueBufferRef audioBuffer = NULL;
		OSStatus result = AudioQueueAllocateBuffer(_inputAudioQueue, 512, &audioBuffer);
		if (noErr != result)
		{
			printf("Error %d allocating audio buffer\n", result);
			break;
		}

		result = AudioQueueEnqueueBuffer(_inputAudioQueue, audioBuffer, 0, NULL);
		if (noErr != result)
		{
			printf("Error %d enqueueing audio buffer\n", result);
			break;
		}
	}

	AudioQueueStart(_inputAudioQueue, NULL);

	return self;
}

- (void)dealloc
{
	if (_inputAudioQueue)
	{
		AudioQueueStop(_inputAudioQueue, true);
		AudioQueueDispose(_inputAudioQueue, true);
	}
}

@end
