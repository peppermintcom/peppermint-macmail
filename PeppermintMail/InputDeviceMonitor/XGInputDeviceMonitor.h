//
//  XGMicMonitor.h
//  MicDetection
//
//  Created by Boris Remizov on 27/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGInputDeviceMonitor : NSObject

@property (nonatomic, readonly) BOOL inputDevicePresents;
@property (nonatomic, readonly) float currentSignalLevel;
@property (nonatomic, readonly) float maximumSignalLevel;

+ (instancetype)sharedMonitor;

- (BOOL)startMonitoring:(NSError**)error;
- (void)stopMonitoring;

@end
