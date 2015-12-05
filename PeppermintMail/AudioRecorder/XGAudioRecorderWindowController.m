//
//  XGAudioRecorderWindowController.m
//  Peppermint
//
//  Created by Boris Remizov on 23/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGAudioRecorderWindowController.h"
#import "AudioRecorder/XGAudioRecorderViewController.h"
#import "InputDeviceMonitor/XGInputDeviceMonitor.h"
#import "Core/XGLocalizedString.h"

@interface XGAudioRecorderWindowController ()

@property (nonatomic, strong) XGAudioRecorderViewController* audioRecorder;
@property (nonatomic, assign) IBOutlet NSView* audioRecorderFrameView;
@property (nonatomic, strong) NSWindow* parentWindow;
@property (nonatomic, readonly, copy) NSString* defaultButtonLocalizedTitle;

@end

@implementation XGAudioRecorderWindowController

@dynamic defaultButtonLocalizedTitle;

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(NSView *)superview subview:(NSView *)subview {
	[superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
														  attribute:edge
														  relatedBy:NSLayoutRelationEqual
															 toItem:superview
														  attribute:edge
														 multiplier:1
														   constant:0]];
}

+ (instancetype)controller
{
	return [[XGAudioRecorderWindowController alloc] initWithWindowNibName:@"XGAudioRecorderWindowController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];

	// place audio recorder on to place
	self.audioRecorder = [XGAudioRecorderViewController controller];
	self.audioRecorder.preparationInterval = 0;

	if ([XGInputDeviceMonitor sharedMonitor].inputDevicePresents)
	{
		NSError* error = nil;
		BOOL result = [self.audioRecorder record:&error];
		if (!result)
			XG_ERROR(@"Automatic recording start failed. %@", error);
	}

	self.audioRecorder.view.frame = self.audioRecorderFrameView.bounds;
	[self.audioRecorderFrameView addSubview:self.audioRecorder.view];

	[[self class] addEdgeConstraint:NSLayoutAttributeLeft superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeRight superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeTop superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeBottom superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
}

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(void (^)(NSURL* mediaUrl, NSError* error))completion
{
	self.parentWindow = window;
	[self.parentWindow beginSheet:self.window completionHandler:^(NSModalResponse returnCode) {
		[self.audioRecorder stop];

		completion((NSModalResponseContinue == returnCode) ? self.audioRecorder.lastRecordedURL : nil,
				   self.audioRecorder.lastError);
	}];
}

- (IBAction)recordOrDone:(id)sender
{
	if (self.audioRecorder.recording || self.audioRecorder.lastRecordedURL)
	{
		// close record sheet
		[self.parentWindow endSheet:self.window returnCode:NSModalResponseContinue];
	}
	else
	{
		// start recording
		NSError* error = nil;
		BOOL result = [self.audioRecorder record:&error];
		if (!result)
			XG_ERROR(@"Failed to start recording, %@", error);
	}
}

- (IBAction)cancelOperation:(id)sender
{
	[self.parentWindow endSheet:self.window returnCode:NSModalResponseCancel];
}

+ (NSSet*)keyPathsForValuesAffectingLocalizedDefaultButtonTitle
{
	return [NSSet setWithObjects:@"audioRecorder.recording", @"audioRecorder.lastRecordedURL", nil];
}

- (NSString*)localizedDefaultButtonTitle
{
	return (self.audioRecorder.recording || (nil != self.audioRecorder.lastRecordedURL)) ?
		XGLocalizedString(@"btn_done", "") : XGLocalizedString(@"btn_record", "");
}

@end
