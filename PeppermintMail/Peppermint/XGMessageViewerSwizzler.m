//
//  XGMessageViewerSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGMessageViewerSwizzler.h"
#import "XGAttachementGenerator.h"
#import "XGMessageViewerToolbarItem.h"
#import "AudioRecorder/XGAudioRecorderWindowController.h"
#import "Mail/MessageViewer.h"
#import "Mail/EditingMessageWebView.h"
#import "Mail/ComposeWindowController.h"
#import "Mail/ComposeViewController.h"
#import "Mail/MailWebViewEditor.h"

@import Cocoa;

static NSString* const XGReplyWithPeppermintToolbarItemIdentifier = @"replyWithPeppermint";

@interface XGMessageViewerSwizzler()

@property (nonatomic, strong) XGAudioRecorderWindowController* recordController;
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
	XGToolbarItem* item = [[XGMessageViewerToolbarItem alloc] initWithItemIdentifier:XGReplyWithPeppermintToolbarItemIdentifier
																		   imageName:@"icon_reply"];
	item.minSize = CGSizeMake(60, item.minSize.height);
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

		NSWindow* window = note.object;
		XG_ASSERT([window isKindOfClass:[NSWindow class]], @"Invalid object prameter, must be NSWindow");

		// find WebViewEditor class
		WebViewEditor* editor = nil;
		if ([window.windowController isKindOfClass:NSClassFromString(@"ComposeWindowController")])
		{
			// Mail 9
			editor = [(ComposeWindowController*)window.windowController contentViewController].webViewEditor;
		}
		else if ([window.delegate isKindOfClass:NSClassFromString(@"DocumentEditor")])
		{
			// Mail 8-
			editor = [(DocumentEditor*)window.delegate webViewEditor];
		}

		if (nil == editor)
		{
			XG_DEBUG(@"WebViewEditor not found skipping recording");
			return;
		}

		// check we already replied to the window
		NSSet* oldRecordings = [self.windowsBeingRepliedWithPeppermint objectsPassingTest:^BOOL(id obj, BOOL *stop) {
			*stop = [obj pointerValue] == (__bridge void *)(window);
			return *stop;
		}];

		if ([oldRecordings count] > 0)
		{
			XG_TRACE(@"Already did a recording in %@, skipped", window);
			return;
		}

		[self.windowsBeingRepliedWithPeppermint addObject:[NSValue valueWithPointer:(__bridge const void *)(window)]];

		// check another recording is already in progress
		if (self.recordController)
		{
			XG_DEBUG(@"Recording is already in progress, exiting");
			return;
		}

		// run recording
		XG_TRACE(@"Starting record sheet...");
		
		self.recordController = [XGAudioRecorderWindowController controller];
		[self.recordController beginSheetModalForWindow:note.object completionHandler:^(NSURL *audioFile, NSError* error) {
			
			XG_DEBUG(@"Url %@ got after the recording ended. Error: %@", audioFile, error);
			
			if (audioFile)
			{
				NSError* attachementError = nil;
				[[XGAttachementGenerator generatorWithEditor:editor] addAudioAttachment:audioFile error:&attachementError];
			}
			
			self.recordController = nil;
			
		}];
	}];

	// show reply sheet
	[messageViewer replyAllMessage:sender];
}

@end
