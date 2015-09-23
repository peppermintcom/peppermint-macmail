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
@property (nonatomic, readonly, copy) NSError* lastError;
@property (nonatomic, readonly) BOOL recording;

@property (nonatomic) NSTimeInterval maxDuration;
@property (nonatomic) NSTimeInterval preparationInterval;
@property (nonatomic) BOOL startsRecordingAutomatically;

- (BOOL)record:(NSError**)error;
- (void)stop;

+ (XGAudioRecorderViewController*)controller;

@end
