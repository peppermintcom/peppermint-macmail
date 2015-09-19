//
//  XGReplyWithPeppermintWindowController.m
//  Peppermint
//
//  Created by Boris Remizov on 17/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGReplyWithPeppermintWindowController.h"
#import "AudioRecorder/XGAudioRecorderViewController.h"

@interface XGReplyWithPeppermintWindowController ()

@property (nonatomic, strong) XGAudioRecorderViewController* audioRecorder;
@property (nonatomic, assign) IBOutlet NSView* audioRecorderFrameView;
@end

@implementation XGReplyWithPeppermintWindowController

+ (instancetype)controller
{
	XGReplyWithPeppermintWindowController* controller = [[XGReplyWithPeppermintWindowController alloc] initWithWindowNibName:@"XGReplyWithPeppermintWindowController"];
	return controller;
}

+ (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(NSView *)superview subview:(NSView *)subview {
	[superview addConstraint:[NSLayoutConstraint constraintWithItem:subview
														  attribute:edge
														  relatedBy:NSLayoutRelationEqual
															 toItem:superview
														  attribute:edge
														 multiplier:1
														   constant:0]];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
	self.audioRecorder = [XGAudioRecorderViewController controller];
	self.audioRecorder.view.frame = self.audioRecorderFrameView.bounds;
	[self.audioRecorderFrameView addSubview:self.audioRecorder.view];

	[[self class] addEdgeConstraint:NSLayoutAttributeLeft superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeRight superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeTop superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
	[[self class] addEdgeConstraint:NSLayoutAttributeBottom superview:self.audioRecorderFrameView subview:self.audioRecorder.view];
}

@end
