//
//  XGPeppermintPlugin.m
//  Peppermint
//
//  Created by Boris Remizov on 12/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGPeppermintPlugin.h"
#import "XGMessageViewerSwizzler.h"
#import "XGDocumentEditorSwizzler.h"
#import "XGComposeWindowControllerSwizzler.h"

@implementation XGPeppermintPlugin

id _swizzler1;
id _swizzler2;

+ (void)load
{
	XG_TRACE_FUNC();

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{

		XG_PRINT(@"Peppermint plugin %d loaded", CURRENT_PROJECT_VERSION);

		// instantiate plugin objects and register them into app infrastructure
		NSError* error = nil;
		XG_CHECK([self registerMessageViewerToolbarItem:&error], @"Failed to inject MessageViewer toolbar item. %@", error);
		XG_CHECK([self registerMessageWindowToolbarItem:&error], @"Failed to inject DocumentEditor toolbar item. %@", error);
	});
}

+ (BOOL)registerMessageViewerToolbarItem:(NSError**)error
{
	XG_TRACE_FUNC();
	return ([XGMessageViewerSwizzler sharedInstance] != nil);
}

+ (BOOL)registerMessageWindowToolbarItem:(NSError**)error
{
	XG_TRACE_FUNC();

	if (NSClassFromString(@"DocumentEditor"))
	{
		// Mail 8 and below
		return ([XGDocumentEditorSwizzler sharedInstance] != nil);
	}
	else
	{
		// Mail9
		return [XGComposeWindowControllerSwizzler sharedInstance] != nil;
	}
}

@end
