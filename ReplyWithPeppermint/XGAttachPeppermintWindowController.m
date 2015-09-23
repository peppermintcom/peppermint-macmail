//
//  XGAttachPeppermintWindowController.m
//  Peppermint
//
//  Created by Boris Remizov on 23/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGAttachPeppermintWindowController.h"
#import "AudioRecorder/XGAudioRecorderViewController.h"

@interface XGAttachPeppermintWindowController ()

@property (nonatomic, strong) XGAudioRecorderViewController* audioRecorder;
@property (nonatomic, assign) IBOutlet NSView* audioRecorderFrameView;

@property (nonatomic, strong) NSWindow* parentWindow;

@end

@implementation XGAttachPeppermintWindowController

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
	return [[XGAttachPeppermintWindowController alloc] initWithWindowNibName:@"XGAttachPeppermintWindowController"];
}

- (void)dealloc
{

}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
	// place audio recorder on to place
	self.audioRecorder = [XGAudioRecorderViewController controller];
	self.audioRecorder.preparationInterval = 0;
	self.audioRecorder.startsRecordingAutomatically = YES;

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

- (IBAction)done:(id)sender
{
	[self.parentWindow endSheet:self.window returnCode:NSModalResponseContinue];
}

- (IBAction)cancelOperation:(id)sender
{
	[self.parentWindow endSheet:self.window returnCode:NSModalResponseCancel];
}

@end
