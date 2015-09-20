//
//  XGMessageViewerSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGMessageViewerSwizzler.h"
#import "XGToolbarItem.h"
#import "XGReplyWithPeppermintWindowController.h"
#import "Mail/MessageViewer.h"
#import "Mail/MCMessageGenerator.h"
#import "Mail/MCMutableMessageHeaders.h"
#import <Cocoa/Cocoa.h>

static NSString* const XGReplyWithPeppermintToolbarItemIdentifier = @"replyWithPeppermint";

@interface XGMessageViewerSwizzler()

@property(nonatomic, strong) NSWindowController* replyWithPeppermintWindowController;

@end

@implementation XGMessageViewerSwizzler

+ (instancetype)sharedInstance
{
	static XGMessageViewerSwizzler* singleton = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [[XGMessageViewerSwizzler alloc] initWithClass:NSClassFromString(@"MessageViewer")];
	});
	return singleton;
}

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();
	NSArray* items = [super toolbarAllowedItemIdentifiers:toolbar];
	return [items containsObject:XGReplyWithPeppermintToolbarItemIdentifier] ? items
	: [items arrayByAddingObject:XGReplyWithPeppermintToolbarItemIdentifier];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	XG_DEBUG(@"Providing toolbar items list for %@", [self curentSwizzledObject]);

	NSMutableArray* items = [NSMutableArray arrayWithArray:[super toolbarDefaultItemIdentifiers:toolbar]];
	if (![items containsObject:XGReplyWithPeppermintToolbarItemIdentifier])
	{
		// insert our identifier at the desired place (or just append)
		NSUInteger index = 0;
		for (; index < [items count]; ++index)
		{
			if ([items[index] isEqual:@"reply_replyAll_forward" /* optimal place for us, as in Apple Mail 8.2*/])
				break;
		}
		if (index < [items count])
			// insert "after" the reply_replyAll_forward if found
			++index;
		[items insertObject:XGReplyWithPeppermintToolbarItemIdentifier atIndex:index];
	}

	XG_DEBUG(@"Adjusted list of toolbar items: %@", items);

	return items;
}

- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag
{
	XG_TRACE_FUNC();

	if (![identifier isEqual:XGReplyWithPeppermintToolbarItemIdentifier])
		return [super toolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:flag];

	// return item for the ReplyWithPeppermint button
	NSToolbarItem* item = [[XGToolbarItem alloc] initWithItemIdentifier:XGReplyWithPeppermintToolbarItemIdentifier imageName:@"ReplyWithPeppermint"];
	item.target = self;
	item.action = @selector(replyWithPeppermint:);

	return item;
}

- (IBAction)replyWithPeppermint:(id)sender
{
	XG_TRACE_FUNC();

	// debug code
	for (NSWindow* window in [NSApplication sharedApplication].windows)
	{
		XG_DEBUG(@"Window %@: Delegate %@", window.title, window.delegate);
		if ([NSStringFromClass(window.delegate.class) isEqual:@"DocumentEditor"])
		{
			XG_DEBUG(@"%@ wit attachments: %@", [(id)window.delegate document], [[(id)window.delegate document] attachments]);
		}
	}

	NSArray* basicHeaders = [NSClassFromString(@"MCMessageHeaders") basicHeaderKeys];
	XG_DEBUG(@"Headers: %@", basicHeaders);


	MCMutableMessageHeaders* headers = [NSClassFromString(@"MCMutableMessageHeaders") new];
	[headers setHeader:@"catflight@gmail.com" forKey:@"from"];
	[headers setHeader:@"Test" forKey:@"subject"];

	id message = [[NSClassFromString(@"MCMessageGenerator") new] newMessageWithAttributedString:[[NSAttributedString alloc] initWithString:@"Test"]
																		   headers:headers];
	XG_DEBUG(@"Message: %p - %@", message, NSStringFromClass([message class]));

	return;


	self.replyWithPeppermintWindowController = [XGReplyWithPeppermintWindowController controller];
//	[self.replyWithPeppermintWindowController showWindow:self.replyWithPeppermintWindowController.window];

	[[sender window] beginSheet:self.replyWithPeppermintWindowController.window completionHandler:^(NSModalResponse returnCode) {

		self.replyWithPeppermintWindowController = nil;
	}];
}

@end
