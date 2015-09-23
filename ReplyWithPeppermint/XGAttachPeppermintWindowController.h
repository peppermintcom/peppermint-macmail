//
//  XGAttachPeppermintWindowController.h
//  Peppermint
//
//  Created by Boris Remizov on 23/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XGAttachPeppermintWindowController : NSWindowController

+ (instancetype)controller;

- (void)beginSheetModalForWindow:(NSWindow *)window completionHandler:(void (^)(NSURL* audioFile, NSError*))completion;

@end
