//
//  XGAudioRecorderViewController.m
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGAudioRecorderViewController.h"
#import "InputDeviceMonitor/XGInputDeviceMonitor.h"
#import "Core/XGTemporaryURL.h"
#import "Core/XGLocalizedString.h"
#import <CoreAudio/CoreAudioTypes.h>
@import AVFoundation;


static const NSTimeInterval XGAudioRecorderViewControllerPreparationInterval = 3.0;
static const NSTimeInterval XGAudioRecorderViewControllerMeasurementInterval = 3.0;


@interface XGAudioRecorderViewController ()

@property (nonatomic, strong) AVAudioRecorder* recorder;
@property (nonatomic, copy) NSURL* lastRecordedURL;

@property (nonatomic, strong) NSTimer* preparationTimer;
@property (nonatomic, strong) NSTimer* refreshTimer;

@property (nonatomic) NSUInteger preparationCounter;
@property (nonatomic, strong) NSDate* recordStartTime;

@property (nonatomic) NSUInteger elapsedMinutes;
@property (nonatomic) NSUInteger elapsedSeconds;
@property (nonatomic) NSUInteger elapsedMilliseconds;

@property (nonatomic) BOOL recording;

@property (nonatomic, assign) IBOutlet NSButton* playStopButton;
@property (nonatomic, strong) id windowNotificationsObserver;

- (IBAction)recStopDidToggle:(id)sender;

- (BOOL)startRecording;

@end

@implementation XGAudioRecorderViewController

+ (XGAudioRecorderViewController*)controller
{
	return [[XGAudioRecorderViewController alloc] initWithNibName:@"XGAudioRecorderViewController"
														   bundle:[NSBundle bundleForClass:self]];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self)
		return nil;

	// set some default values
	self.preparationInterval = XGAudioRecorderViewControllerPreparationInterval;
	self.maxDuration = 600.0;		// 10 minutes

	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	// bind the play/stop button state with recording state
	[self.playStopButton bind:@"state" toObject:self withKeyPath:@"recording" options:nil];

	// monitor all NSWondow events to catch situation our view did activated to start recording
	// if the startsRecordingAutomatically property is set
	self.windowNotificationsObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidBecomeKeyNotification
																						 object:nil
																						  queue:[NSOperationQueue currentQueue]
																					 usingBlock:^(NSNotification* note) {
		// check it is our window
		if (self.view.window != note.object)
			return;

		if (!self.recording && self.startsRecordingAutomatically)
		{
			NSError* error = nil;
			BOOL result = [self record:&error];
			if (!result)
				XG_ERROR(@"Could not start recording automatically. %@", error);
		}
	}];
}

- (void)dealloc
{
	if (self.windowNotificationsObserver)
		[[NSNotificationCenter defaultCenter] removeObserver:self.windowNotificationsObserver];

	[self stop];
	[self.playStopButton unbind:@"state"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.lastRecordedURL.path])
	{
		NSError* error = nil;
		BOOL result = [[NSFileManager defaultManager] removeItemAtPath:self.lastRecordedURL.path error:&error];
		if (!result)
			XG_ERROR(@"Could not delete the lastRecordedURL %@. %@", self.lastRecordedURL, error);
	}
}

- (BOOL)record:(NSError**)error
{
	XG_ASSERT(nil == self.recorder, @"Recording is already in progress");

	// record to temporary file
	NSDictionary* settings = @{
		AVFormatIDKey:@(kAudioFormatMPEG4AAC_HE),
		AVSampleRateKey:@(44100),
		AVNumberOfChannelsKey:@(2),
		AVEncoderAudioQualityKey: @(AVAudioQualityHigh)
	};

	self.recorder = [[AVAudioRecorder alloc] initWithURL:[XGTemporaryURL() URLByAppendingPathExtension:@"m4a"]
												settings:settings
												   error:error];
	if (nil == self.recorder)
	{
		XG_ERROR(@"Can not create AVAudioRecorder. %@", (error) ? *error : @"<No Description>");
		return FALSE;
	}

	BOOL result = [self.recorder prepareToRecord];
	if (!result)
	{
		self.recorder = nil;
		XG_ERROR(@"Can not prepare recording");
	}

	self.preparationCounter = self.preparationInterval / 1.0;
	if (self.preparationCounter > 0)
	{
		// start 3 secons prepare interval timer
		self.preparationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
															   selector:@selector(preparationTimerDidTick:)
															   userInfo:NULL
																repeats:YES];
		return TRUE;
	}
	else
	{
		// start recording immediately
		return [self startRecording];
	}
}

- (void)preparationTimerDidTick:(NSTimer*)timer
{
	XG_ASSERT(self.preparationCounter > 0, @"Unexpected value of preparationCounter %d", (int)self.preparationCounter);

	--self.preparationCounter;
	if (0 == self.preparationCounter)
	{
		[timer invalidate];
		self.preparationTimer = nil;

		[self startRecording];
	}
}

- (void)refreshTimerDidFire:(NSTimer*)timer
{
	NSUInteger millisecondsElapsed = [[NSDate date] timeIntervalSinceDate:self.recordStartTime] * 100.0;

	self.elapsedMinutes = millisecondsElapsed / (60 * 100);
	self.elapsedSeconds = (millisecondsElapsed % 6000) / 100;
	self.elapsedMilliseconds = millisecondsElapsed % 100;

	XG_DEBUG(@"Maximum signal level %f", [XGInputDeviceMonitor sharedMonitor].maximumSignalLevel);

	if (millisecondsElapsed > XGAudioRecorderViewControllerMeasurementInterval * 100 &&
		[XGInputDeviceMonitor sharedMonitor].maximumSignalLevel < 0.000001)
	{
		[self stop];
		self.lastRecordedURL = nil;

		// microphone signal is too weak, show error info
		// TODO: show error
		NSAlert* alert = [NSAlert new];
		alert.messageText = XGLocalizedString(@"mic_not_works_title", "");
		alert.informativeText = XGLocalizedString(@"mic_not_works_descr", "");
		[alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {

		}];
	}
	else
	{
		// check for exceeding max record interval
		if ((NSTimeInterval)millisecondsElapsed >= self.maxDuration * 100.0)
			[self stop];
	}
}

- (BOOL)startRecording
{
	XG_ASSERT(self.preparationCounter == 0 && self.preparationTimer == nil, @"The preparationTimer must be nil on startRecording");

	BOOL result = [self.recorder recordForDuration:self.maxDuration];
	if (!result)
	{
		XG_ERROR(@"Can not start recording at path", self.recorder.url);
		self.recorder = nil;
		return false;
	}

	// recording started, update context
	self.recordStartTime = [NSDate date];

	self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.011 target:self
													   selector:@selector(refreshTimerDidFire:)
													   userInfo:NULL
														repeats:YES];

	NSURL* previousFileURL = self.lastRecordedURL;
	self.lastRecordedURL = self.recorder.url;

	if (previousFileURL)
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

			NSFileManager* fileManager = [NSFileManager new];
			NSError* localError = nil;
			BOOL result = [fileManager removeItemAtURL:self.lastRecordedURL error:&localError];
			if (!result)
				XG_ERROR(@"Can't remove previously recorded file. %@", localError);
		});
	}

	self.recording = TRUE;

	// start monitoring of audio level, over zero level (-40dB and less) will be treated as
	// "mic not attached"
	[[XGInputDeviceMonitor sharedMonitor] startMonitoring:NULL];

	return TRUE;
}

- (void)stop
{
	[[XGInputDeviceMonitor sharedMonitor] stopMonitoring];

	self.recording = FALSE;

	if (self.recorder.recording)
		[self.recorder stop];
	self.recorder = nil;

	self.recordStartTime = nil;

	[self.preparationTimer invalidate];
	self.preparationTimer = nil;

	[self.refreshTimer invalidate];
	self.refreshTimer = nil;

	self.preparationCounter = 0;
	self.elapsedMilliseconds = 0;
	self.elapsedSeconds = 0;
	self.elapsedMilliseconds = 0;
}

- (IBAction)recStopDidToggle:(id)sender
{
	if (self.recorder)
		[self stop];
	else
	{
		NSError* error = nil;
		[self record:&error];
	}
}

@end
