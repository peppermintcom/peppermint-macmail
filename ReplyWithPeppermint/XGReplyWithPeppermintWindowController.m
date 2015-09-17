//
//  XGReplyWithPeppermintWindowController.m
//  Peppermint
//
//  Created by Boris Remizov on 17/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGReplyWithPeppermintWindowController.h"

@interface XGReplyWithPeppermintWindowController ()

@end

@implementation XGReplyWithPeppermintWindowController

+ (instancetype)controller
{
	XGReplyWithPeppermintWindowController* controller = [[XGReplyWithPeppermintWindowController alloc] initWithWindowNibName:@"XGReplyWithPeppermintWindowController"];
	return controller;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
