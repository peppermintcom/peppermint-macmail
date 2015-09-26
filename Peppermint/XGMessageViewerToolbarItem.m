//
//  XGMessageViewerToolbarItem.m
//  PeppermintMail
//
//  Created by Boris Remizov on 26/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGMessageViewerToolbarItem.h"
#import "Mail/MessageViewer.h"
#import "Mail/MCMessage.h"
#import "Mail/MCMessageHeaders.h"

@interface XGMessagesToBoolValueTransformer : NSValueTransformer

@end

@implementation XGMessagesToBoolValueTransformer

// information that can be used to analyze available transformer instances (especially used inside Interface Builder)
+ (Class)transformedValueClass
{
	return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (nullable id)transformedValue:(nullable id)value
{
	XG_DEBUG(@"%d messages to bool", [value count]);

	if (nil == value)
		return @FALSE;

	XG_ASSERT([value isKindOfClass:[NSArray class]], @"Unsupported value type %@ for transformer XGArrayToBoolValueTransformer",
			  NSStringFromClass([value class]));

	// can't replyWithPeppermint to multiple messages simultaneously
	// TODO: check the original reply behavior
	if ([value count] != 1)
		return @FALSE;

	// check among the message there are at least one with the _sender field filled
	MCMessage* message = [value lastObject];
	return @(nil != message.headers._sender);
}

@end


@interface XGMessageViewerToolbarItem()

@property (nonatomic, strong) MessageViewer* messageViewer;

@end

@implementation XGMessageViewerToolbarItem

- (void)validate
{
	if (self.messageViewer)
	{
		self.enabled = [[[XGMessagesToBoolValueTransformer new] transformedValue:self.messageViewer.selectedMessages] boolValue];
	}
	else
	{
		// observe our MessageViewer's selectedMessages property to enable/disable us respectively
		self.messageViewer = (MessageViewer*)self.view.window.delegate;
		XG_ASSERT([self.messageViewer isKindOfClass:NSClassFromString(@"MessageViewer")], @"Unexpected class %@ of MessageViewer",
				  NSStringFromClass([self.messageViewer class]));

	//	[self.messageViewer addObserver:self forKeyPath:@"selectedMessages" options:NSKeyValueObservingOptionNew context:NULL];

		[self bind:@"enabled" toObject:self.messageViewer withKeyPath:@"selectedMessages" options:@{
			NSValueTransformerBindingOption : [XGMessagesToBoolValueTransformer new]
		}];
	}
}

- (void)dealloc
{
	if (self.messageViewer)
		[self unbind:@"enabled"];
}

@end