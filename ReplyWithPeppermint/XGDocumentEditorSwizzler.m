//
//  XGDocumentEditorSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 21/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGDocumentEditorSwizzler.h"
#import "XGAttachPeppermintWindowController.h"
#import "Core/XGToolbarItem.h"
#import "Mail/DocumentEditor.h"
#import "Mail/MailWebViewEditor.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/MCMessageGenerator.h"
#import "Mail/MFWebMessageDocument.h"
#import "Mail/MCAttachment.h"
#import "Mail/MFAttachmentViewController.h"


static NSString* const XGAttachWithPeppermintToolbarItemIdentifier = @"insertPeppermint";

@implementation XGDocumentEditorSwizzler

+ (instancetype)sharedInstance
{
	static XGDocumentEditorSwizzler* singleton = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [[XGDocumentEditorSwizzler alloc] initWithClass:NSClassFromString(@"DocumentEditor")];
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
	NSToolbarItem* item = [[XGToolbarItem alloc] initWithItemIdentifier:XGAttachWithPeppermintToolbarItemIdentifier imageName:@"ReplyWithPeppermint"];
	item.target = self;
	item.action = @selector(attachWithPeppermint:);

	return item;
}

- (IBAction)attachWithPeppermint:(id)sender
{
	XG_TRACE_FUNC();

	[[XGAttachPeppermintWindowController controller] beginSheetModalForWindow:[sender window]
															completionHandler:^(NSURL *audioFile, NSError *error) {
		if (nil == audioFile)
			return;

		DocumentEditor* documentEditor = (DocumentEditor*)[[sender window] delegate];
		WebViewEditor* editor = documentEditor.webViewEditor;
		[editor addAttachmentsForFiles:@[audioFile]];
	}];
}

@end