//
//  XGAudioRecorderViewController.m
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGAudioRecorderViewController.h"
#import "Tools/XGTemporaryURL.h"
#import <CoreAudio/CoreAudioTypes.h>
@import AVFoundation;


static const NSTimeInterval XGAudioRecorderViewControllerPreparationInterval = 3.0;


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

- (IBAction)recStopDidToggle:(id)sender;

- (BOOL)startRecording;

@end

@implementation XGAudioRecorderViewController

+ (XGAudioRecorderViewController*)controller
{
	return [[XGAudioRecorderViewController alloc] initWithNibName:@"XGAudioRecorderViewController"
														   bundle:[NSBundle bundleForClass:self]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)dealloc
{
	[self stop];
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

	self.recorder = [[AVAudioRecorder alloc] initWithURL:XGTemporaryURL()
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

	self.preparationCounter = XGAudioRecorderViewControllerPreparationInterval / 1.0;
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
	NSUInteger millisecondsElapsed = [[NSDate date] timeIntervalSinceDate:self.recordStartTime] * 1000.0;

	self.elapsedMinutes = millisecondsElapsed / (60 * 1000);
	self.elapsedSeconds = (millisecondsElapsed % 60000) / 1000;
	self.elapsedMilliseconds = millisecondsElapsed % 1000;
}

- (BOOL)startRecording
{
	XG_ASSERT(self.preparationCounter == 0 && self.preparationTimer == nil, @"The preparationTimer must be nil on startRecording");

	BOOL result = [self.recorder recordForDuration:30.0];
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

	return TRUE;
}

- (void)stop
{
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
