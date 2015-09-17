//
//  XGPeppermintPlugin.m
//  Peppermint
//
//  Created by Boris Remizov on 12/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGPeppermintPlugin.h"
#import "ReplyWithPeppermint/XGMessageViewerSwizzler.h"

@implementation XGPeppermintPlugin

id _swizzler1;
id _swizzler2;

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
	return ([XGMessageViewerSwizzler sharedInstance] != nil);
}

+ (BOOL)registerMessageWindowToolbarItem:(NSError**)error
{
	XG_TRACE_FUNC();
	return FALSE;
}

@end
