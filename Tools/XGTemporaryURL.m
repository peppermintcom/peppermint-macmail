//
//  XGTemporaryURL.m
//  Peppermint
//
//  Created by Boris Remizov on 16/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGTemporaryURL.h"
#include <stdio.h>

NSURL* XGTemporaryURL()
{
	char tempPath[PATH_MAX + 1];
	strncpy(tempPath, [[NSTemporaryDirectory() stringByAppendingPathComponent:@"ppmtXXXXX"] UTF8String], PATH_MAX);
	tempPath[PATH_MAX] = 0;

	mkstemp(tempPath);

	NSURL* tempURL = [NSURL fileURLWithPath: [NSString stringWithCString:tempPath encoding:NSUTF8StringEncoding]];

	return  tempURL;
}
