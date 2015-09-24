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
#import "Peppermint/XGPreferences.h"
#import "Mail/DocumentEditor.h"
#import "Mail/MailWebViewEditor.h"
#import "Mail/EditingMessageWebView.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/MCMessageGenerator.h"
#import "Mail/MFWebMessageDocument.h"
#import "Mail/MCAttachment.h"
#import "Mail/MFAttachmentViewController.h"
#import "Mail/ComposeBackEnd.h"


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

- (void)addAudioAttachment:(NSURL*)url editor:(DocumentEditor*)documentEditor
{
	XG_ASSERT(url, @"url must be non-nil to attach");

	[documentEditor.webViewEditor addAttachmentsForFiles:@[url]];

	// determine what is it - new mail or reply
	NSString* audioCommentString = nil;
	if (documentEditor.backEnd.originalMessageHeaders._sender > 0)
	{
		// it is reply
		XG_TRACE(@"Getting reply comment, due to original headers: %@", documentEditor.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].replyBodyText stringByAppendingString:@"\n\n"];
	}
	else
	{
		// looks like it is composing (new mail)
		XG_TRACE(@"Getting compose (new mail) comment, due to original headers: %@", documentEditor.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].composeBodyText stringByAppendingString:@"\n\n"];
	}

	// add text comment to attachement
	if ([audioCommentString length] > 0)
	{
		NSAttributedString* attributedComent = [[NSAttributedString alloc] initWithHTML:[audioCommentString dataUsingEncoding:NSUTF8StringEncoding]
																	 documentAttributes:nil];
		[documentEditor.webViewEditor.webView insertText:attributedComent replacementRange:NSMakeRange(0, 0)];
	}
	else
		XG_DEBUG(@"Skipping insertion of body text %@", audioCommentString);
}

- (IBAction)attachWithPeppermint:(id)sender
{
	XG_TRACE_FUNC();

	[[XGAttachPeppermintWindowController controller] beginSheetModalForWindow:[sender window]
															completionHandler:^(NSURL *audioFile, NSError *error) {
		XG_DEBUG(@"Got audio file %@ after record sheet completed", audioFile);
		if (nil == audioFile)
			return;

		// add attachment
		DocumentEditor* documentEditor = (DocumentEditor*)[[sender window] delegate];
		XG_ASSERT([documentEditor isKindOfClass:NSClassFromString(@"DocumentEditor")],
				  @"Unexpected class of window's delegate %@", NSStringFromClass([documentEditor class]));

		[self addAudioAttachment:audioFile editor:documentEditor];
	}];
}

@end
