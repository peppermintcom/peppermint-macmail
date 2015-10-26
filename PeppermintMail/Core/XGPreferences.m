//
//  XGPreferences.m
//  Peppermint
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGPreferences.h"
#import "Core/XGLocalizedString.h"

static NSString* const XGPreferencesComposeBodyTextKey = @"XGComposeBodyText";
static NSString* const XGPreferencesComposeSubjectTextKey = @"XGComposeSubjectText";
static NSString* const XGPreferencesReplyBodyTextKey = @"XGReplyBodyText";
static NSString* const XGPreferencesReplySubjectTextKey = @"XGReplySubjectText";

@interface XGPreferences()

@property (nonatomic) BOOL mergeWithDefaults;

@end


@implementation XGPreferences

@dynamic composeBodyText, composeSubjectText, replyBodyText, replySubjectText;

+ (instancetype)userPreferences
{
	static XGPreferences* singleton;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [XGPreferences new];
	});
	return singleton;
}

+ (instancetype)activePreferences
{
	static XGPreferences* singleton;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		singleton = [XGPreferences new];
		singleton.mergeWithDefaults = YES;
	});
	return singleton;
}

+ (NSString*)preferenceKeyForValueKey:(NSString*)key
{
	XG_ASSERT([key length] > 1, @"Preference keys MUST be at least two chanracter length");

	NSString* capitalLetter = [[key capitalizedString] substringWithRange:NSMakeRange(0, 1)];
	return [NSString stringWithFormat:@"XG%@%@", capitalLetter, [key substringFromIndex:1]];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
	XG_ASSERT(nil == value || [value isKindOfClass:[NSString class]], @"Value must be of NSString class, instead of %@",
			  NSStringFromClass([value class]));

	// normalize key
	NSString* preferenceKey = [XGPreferences preferenceKeyForValueKey:key];
	XG_DEBUG(@"[XGPreferences setValue:%@ forKey:%@] <- preference:%@", value, key, preferenceKey);
	NSString* preferenceValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([preferenceValue length] > 0)
		[[NSUserDefaults standardUserDefaults] setObject:preferenceValue forKey:preferenceKey];
	else
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:preferenceKey];
}

- (id)valueForKey:(NSString*)key
{
	NSString* preferenceKey = [XGPreferences preferenceKeyForValueKey:key];

	XG_DEBUG(@"[XGPreferences valueForKey:%@] -> preference:%@", key, preferenceKey);
	NSString* text = [[NSUserDefaults standardUserDefaults] stringForKey:preferenceKey];
	if (text)
		return text;
	return self.mergeWithDefaults ? XGLocalizedString(preferenceKey, "") : nil;
}

#pragma mark - partial implementations

- (void)setComposeBodyText:(NSString *)composeBodyText
{
	[self setValue:composeBodyText forKey:@"composeBodyText"];
}

- (NSString*)composeBodyText
{
	return [self valueForKey:@"composeBodyText"];
}

- (void)setReplyBodyText:(NSString *)replyBodyText
{
	[self setValue:replyBodyText forKey:@"replyBodyText"];
}

- (NSString*)replyBodyText
{
	return [self valueForKey:@"replyBodyText"];
}

- (NSString*)composeSubjectText
{
	return [self valueForKey:@"composeSubjectText"];
}

- (void)setComposeSubjectText:(NSString *)composeSubjectText
{
	[self setValue:composeSubjectText forKey:@"composeSubjectText"];
}

- (NSString*)replySubjectText
{
	return [self valueForKey:@"replySubjectText"];
}

- (void)setReplySubjectText:(NSString *)replySubjectText
{
	[self setValue:replySubjectText forKey:@"replySubjectText"];
}

@end
