//
//  XGPeppermintPlugin.m
//  Peppermint
//
//  Created by Boris Remizov on 12/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGPeppermintPlugin.h"
#import <objc/runtime.h>

@implementation XGPeppermintPlugin

+ (void)load
{
	XG_TRACE_FUNC();

	// instantiate plugin objects and register them into app infrastructure
	NSError* error = nil;
	XG_CHECK([self registerMessageViewerToolbarItem:&error], @"Failed to inject MessageViewer toolbar item. %@", error);
	XG_CHECK([self registerMessageWindowToolbarItem:&error], @"Failed to inject MessageWindow toolbar item. %@", error);
}

+ (BOOL)registerMessageViewerToolbarItem:(NSError**)error
{
	XG_TRACE_FUNC();

	NSError __autoreleasing* internalError = nil;
	if (NULL == error)
		error = &internalError;

	Class MessageViewer = NSClassFromString(@"MessageViewer");
	if (NULL == MessageViewer)
	{
		XG_ERROR(@"Could not find the MessageViewer class, this version of Mail is not supported");
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-50 userInfo:nil];
		return FALSE;
	}

	// TODO: do method swizzling

	return FALSE;
}

+ (BOOL)registerMessageWindowToolbarItem:(NSError**)error
{
	XG_TRACE_FUNC();

	return FALSE;
}

@end
