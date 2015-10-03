//
//  XGComposeWindowControllerSwizzler.m
//  PeppermintMail
//
//  Created by Boris Remizov on 03/10/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGComposeWindowControllerSwizzler.h"
#import "XGAttachementGenerator.h"
#import "AudioRecorder/XGAudioRecorderWindowController.h"
#import "Core/XGToolbarItem.h"
#import "Mail/ComposeWindowController.h"
#import "Mail/ComposeViewController.h"
#import "Mail/WebViewEditor.h"

static NSString* const XGAttachWithPeppermintToolbarItemIdentifier = @"insertPeppermint";

@implementation XGComposeWindowControllerSwizzler

+ (instancetype)sharedInstance
{
	static XGComposeWindowControllerSwizzler* singleton = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [[XGComposeWindowControllerSwizzler alloc] initWithClass:NSClassFromString(@"ComposeWindowController")];
	});
	return singleton;
}

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();
	NSArray* items = [super toolbarAllowedItemIdentifiers:toolbar];
	return [items containsObject:XGAttachWithPeppermintToolbarItemIdentifier] ? items
	: [items arrayByAddingObject:XGAttachWithPeppermintToolbarItemIdentifier];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	XG_DEBUG(@"Providing toolbar items list for %@", [self curentSwizzledObject]);

	NSMutableArray* items = [NSMutableArray arrayWithArray:[super toolbarDefaultItemIdentifiers:toolbar]];
	if (![items containsObject:XGAttachWithPeppermintToolbarItemIdentifier])
	{
		// inser the attach with Peppermint button just after the Flexible space item
		NSUInteger index = 0;
		while (index < [items count] && ![items[index] isEqual:NSToolbarFlexibleSpaceItemIdentifier])
			++index;
		[items insertObject:XGAttachWithPeppermintToolbarItemIdentifier atIndex:index < [items count] ? index + 1 : index];
	}

	XG_DEBUG(@"Adjusted list of toolbar items: %@", items);
	return items;
}

- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag
{
	XG_TRACE_FUNC();

	if (![identifier isEqual:XGAttachWithPeppermintToolbarItemIdentifier])
		return [super toolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:flag];

	// return item for the ReplyWithPeppermint button
	NSToolbarItem* item = [[XGToolbarItem alloc] initWithItemIdentifier:XGAttachWithPeppermintToolbarItemIdentifier
															  imageName:@"icon_mic"];
	item.target = self;
	item.action = @selector(attachWithPeppermint:);

	return item;
}

- (IBAction)attachWithPeppermint:(id)sender
{
	XG_TRACE_FUNC();

	[[XGAudioRecorderWindowController controller] beginSheetModalForWindow:[sender window]
															completionHandler:^(NSURL *audioFile, NSError *error) {
																XG_DEBUG(@"Got audio file %@ after record sheet completed", audioFile);
																if (nil == audioFile)
																	return;
		// add attachment
		ComposeWindowController* windowController = (ComposeWindowController*)[[sender window] windowController];
		XG_ASSERT([windowController isKindOfClass:NSClassFromString(@"ComposeWindowController")],
				  @"Unexpected class of window's delegate %@", NSStringFromClass([windowController class]));

		NSError* attachementError = nil;
		XGAttachementGenerator* generator = [XGAttachementGenerator generatorWithEditor:windowController.contentViewController.webViewEditor];
		BOOL result = [generator addAudioAttachment:audioFile error:&attachementError];
	}];
}

@end
