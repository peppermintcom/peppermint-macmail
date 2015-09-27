//
//  main.m
//  MicDetection
//
//  Created by Boris Remizov on 27/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGInputDeviceMonitor.h"
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {

		[XGInputDeviceMonitor sharedMonitor];

		[[NSRunLoop currentRunLoop] run];
	}
    return 0;
}
