//
//  XGAudioRecorderViewController.h
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XGAudioRecorderViewController : NSViewController

@property (nonatomic, readonly, copy) NSURL* lastRecordedURL;
@property (nonatomic, readonly) BOOL recording;

- (BOOL)record:(NSError**)error;
- (void)stop;

+ (XGAudioRecorderViewController*)controller;

@end
