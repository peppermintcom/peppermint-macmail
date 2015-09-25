//
//  XGAttachementGenerator.m
//  PeppermintMail
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "XGAttachementGenerator.h"
#import "Peppermint/XGPreferences.h"
#import "Mail/MailWebViewEditor.h"
#import "Mail/ComposeBackEnd.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/EditingMessageWebView.h"


@interface XGAttachementGenerator()

@property (nonatomic, strong) DocumentEditor* documentEditor;

@end

@implementation XGAttachementGenerator

+ (instancetype)generatorWithDocument:(DocumentEditor*)documentEditor
{
	XGAttachementGenerator* maker = [XGAttachementGenerator new];
	maker.documentEditor = documentEditor;
	return maker;
}

- (BOOL)addAudioAttachment:(NSURL*)url error:(NSError**)error
{
	XG_ASSERT(url, @"url must be non-nil to attach");
	
	[self.documentEditor.webViewEditor addAttachmentsForFiles:@[url]];
	
	// determine what is it - new mail or reply
	NSString* audioCommentString = nil;
	if (self.documentEditor.backEnd.originalMessageHeaders._sender > 0)
	{
		// it is reply
		XG_TRACE(@"Getting reply comment, due to original headers: %@", self.documentEditor.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].replyBodyText stringByAppendingString:@"\n\n"];
	}
	else
	{
		// looks like it is composing (new mail)
		XG_TRACE(@"Getting compose (new mail) comment, due to original headers: %@", self.documentEditor.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].composeBodyText stringByAppendingString:@"\n\n"];
	}
	
	// add text comment to attachement
	if ([audioCommentString length] > 0)
	{
		NSAttributedString* attributedComent = [[NSAttributedString alloc] initWithHTML:[audioCommentString dataUsingEncoding:NSUTF8StringEncoding]
																	 documentAttributes:nil];
		[self.documentEditor.webViewEditor.webView insertText:attributedComent replacementRange:NSMakeRange(0, 0)];
	}
	else
		XG_DEBUG(@"Skipping insertion of body text %@", audioCommentString);
	
	return TRUE;
}

@end
