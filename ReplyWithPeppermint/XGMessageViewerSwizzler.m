//
//  XGMessageViewerSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGMessageViewerSwizzler.h"
#import "XGAttachementGenerator.h"
#import "XGAttachPeppermintWindowController.h"
#import "Core/XGToolbarItem.h"
#import "Mail/MessageViewer.h"
#import "Mail/MCMessageGenerator.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/EditingMessageWebView.h"
@import Cocoa;

static NSString* const XGReplyWithPeppermintToolbarItemIdentifier = @"replyWithPeppermint";

@interface XGMessageViewerSwizzler()

@property (nonatomic, strong) XGAttachPeppermintWindowController* recordController;
@property (nonatomic, strong) id<NSObject> windowObserver;
@property (nonatomic, strong) NSMutableSet* windowsBeingRepliedWithPeppermint;

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

- (instancetype)initWithClass:(Class)classToSwizzle
{
	self = [super initWithClass:classToSwizzle];
	if (!self)
		return nil;
	
	self.windowsBeingRepliedWithPeppermint = [NSMutableSet set];
	
	return self;
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

	MessageViewer* messageViewer = (MessageViewer*)[[sender window] delegate];
	XG_ASSERT([messageViewer isKindOfClass:NSClassFromString(@"MessageViewer")], @"Unexpected class %@ of MessageViewer", NSStringFromClass([messageViewer class]));

	// subscribe on window appearence events to catch event the DocumentEditor appeared and make it showing the recording sheet
	self.windowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidBecomeKeyNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^(NSNotification *note) {
		
		// unsubscribe, since we are awaiting just one window
		[[NSNotificationCenter defaultCenter] removeObserver:self.windowObserver];
		self.windowObserver = nil;

		NSWindow* documentEditorWindow = note.object;
		XG_ASSERT([documentEditorWindow isKindOfClass:[NSWindow class]], @"Invalid object prameter, must be NSWindow");
		
		if (![[note.object delegate] isKindOfClass:NSClassFromString(@"DocumentEditor")])
		{
			XG_DEBUG(@"Unexpected class of window delegate, skipping recording");
			return;
		}
		
		NSSet* oldRecordings = [self.windowsBeingRepliedWithPeppermint objectsPassingTest:^BOOL(id obj, BOOL *stop) {
			*stop = [obj pointerValue] == (__bridge void *)(documentEditorWindow);
			return *stop;
		}];

		if ([oldRecordings count] > 0)
		{
			XG_TRACE(@"Already did a recording in %@, skipped", documentEditorWindow);
			return;
		}
		
		[self.windowsBeingRepliedWithPeppermint addObject:[NSValue valueWithPointer:(__bridge const void *)(documentEditorWindow)]];
		
		if (self.recordController)
		{
			// recording is already in progress
			XG_DEBUG(@"Recording is already in progress, exiting");
			return;
		}

		// run recording
		XG_TRACE(@"Starting record sheet...");
		
		self.recordController = [XGAttachPeppermintWindowController controller];
		[self.recordController beginSheetModalForWindow:note.object completionHandler:^(NSURL *audioFile, NSError* error) {
			
			XG_DEBUG(@"Url %@ got after the recording ended. Error: %@", audioFile, error);
			
			if (audioFile)
			{
				NSError* attachementError = nil;
				[[XGAttachementGenerator generatorWithDocument:(DocumentEditor*)[note.object delegate]] addAudioAttachment:audioFile error:&attachementError];
			}
			
			self.recordController = nil;
			
		}];
	}];

	// show reply sheet
	[messageViewer replyAllMessage:sender];
}

@end
