//
//  XGAttachementGenerator.m
//  PeppermintMail
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "XGAttachementGenerator.h"
#import "Core/XGPreferences.h"
#import "Mail/MailWebViewEditor.h"
#import "Mail/ComposeBackEnd.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/EditingMessageWebView.h"
#import "Mail/MCOutgoingMessage.h"
#import "Mail/MCMessageBody.h"


@interface XGAttachementGenerator()

@property (nonatomic, strong) WebViewEditor* editor;
@property (nonatomic, strong) ComposeBackEnd* backEnd;

@end

@implementation XGAttachementGenerator

+ (instancetype)generatorWithEditor:(WebViewEditor*)editor
{
	XGAttachementGenerator* maker = [XGAttachementGenerator new];
	maker.editor = editor;
	maker.backEnd = editor.composeBackEnd;
	return maker;
}

- (BOOL)addAudioAttachment:(NSURL*)url error:(NSError**)error
{
	XG_ASSERT(url, @"url must be non-nil to attach");

	[self.editor addAttachmentsForFiles:@[url]];

	// determine what is it - new mail or reply
	NSString* audioCommentString = nil;
	if (self.backEnd.originalMessageHeaders._sender > 0)
	{
		// it is reply
		XG_TRACE(@"Getting reply comment, due to original headers: %@", self.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].replyBodyText stringByAppendingString:@"\n\n"];
	}
	else
	{
		// looks like it is composing (new mail)
		XG_TRACE(@"Getting compose (new mail) comment, due to original headers: %@", self.backEnd.originalMessageHeaders);
		audioCommentString = [[XGPreferences activePreferences].composeBodyText stringByAppendingString:@"\n\n"];
	}

	if ([audioCommentString length] == 0)
	{
		XG_DEBUG(@"Skipping insertion of body text %@", audioCommentString);
		return TRUE;
	}

	NSAttributedString* attributedComment = [[NSAttributedString alloc] initWithHTML:[audioCommentString dataUsingEncoding:NSUTF8StringEncoding]
																documentAttributes:nil];
	NSString* __block stringToMatch = nil;
	[attributedComment enumerateAttributesInRange:NSMakeRange(0, attributedComment.length)
										  options:0
									   usingBlock:^(NSDictionary*attrs, NSRange range, BOOL *stop){
		// unattributed string
		NSString* strippedSubstring = [[attributedComment attributedSubstringFromRange:range] string];
		if ([strippedSubstring length] > [stringToMatch length])
			stringToMatch = strippedSubstring;
	}];

	if ([stringToMatch length] > 5)
	{
		// check mail already have some peppermint attachements
		NSString* bodyString = [[NSString alloc] initWithData:self.backEnd.message.bodyData
													 encoding:NSUTF8StringEncoding];
		if ([bodyString rangeOfString:stringToMatch].location != NSNotFound)
		{
			XG_DEBUG(@"Skipping insertion of duplicate audio comment string %@", audioCommentString);
			return TRUE;
		}
	}

	[self.editor.webView insertText:attributedComment replacementRange:NSMakeRange(0, 0)];

	return TRUE;
}

@end
