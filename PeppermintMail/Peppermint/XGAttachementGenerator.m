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
#import "Mail/EditingMessageWebView.h"
#import "Mail/HeadersEditor.h"
#import "Mail/ComposeBackEnd.h"
#import "Mail/MCMutableMessageHeaders.h"
#import "Mail/MCOutgoingMessage.h"
#import "Mail/MCMessageBody.h"


@interface XGAttachementGenerator()

@property (nonatomic, strong) WebViewEditor* editor;
@property (nonatomic, strong) ComposeBackEnd* backEnd;
@property (nonatomic, strong) HeadersEditor* headersEditor;

@end

@implementation XGAttachementGenerator

+ (instancetype)generatorWithEditor:(WebViewEditor*)editor headersEditor:(HeadersEditor*)headersEditor
{
	XGAttachementGenerator* maker = [XGAttachementGenerator new];
	maker.editor = editor;
	maker.backEnd = editor.composeBackEnd;
	maker.headersEditor = headersEditor;
	return maker;
}

- (BOOL)addAudioAttachment:(NSURL*)url error:(NSError**)error
{
	XG_ASSERT(url, @"url must be non-nil to attach");

	// compose the Subject
	XG_DEBUG(@"Subj(%@):%@", NSStringFromClass([self.backEnd.subject class]), self.backEnd.subject);

	if ([self.backEnd.subject length] == 0)
	{
		// insert our header
		NSString* localizedSubject = [XGPreferences activePreferences].composeSubjectText;
		[self.headersEditor.subjectField setStringValue:localizedSubject];
		self.backEnd.subject = localizedSubject;
	}

	// add attachement with user friendly name
	NSDateFormatter* formatter = [NSDateFormatter new];
	formatter.dateFormat= @"yyyy-MM-dd_hhmmss";
	NSString* fileName = [NSString stringWithFormat:@"Peppermint Message %@.%@",
						  [formatter stringFromDate:[NSDate date]], [url pathExtension]];
	NSURL* targetURL = [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:fileName];

	BOOL result = [[NSFileManager defaultManager] moveItemAtPath:[url path]
														  toPath:[targetURL path] error:error];
	if (!result)
	{
		XG_ERROR(@"Could not move %@ to %@. %@", url, targetURL, error);
		return FALSE;
	}

	[self.editor addAttachmentsForFiles:@[targetURL]];

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
