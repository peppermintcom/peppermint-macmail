/*
 *     Generated by class-dump 3.4 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2012 by Steve Nygard.
 */

@import Foundation;

@class NSData;

@interface MCMessageHeaders : NSObject <NSCopying, NSMutableCopying>
{
    NSData *_data;
    id _sender;
    unsigned long long _encodingHint;
}

+ (id)headerKeysFromLocalizedHeaders:(id)arg1;
+ (id)englishHeadersFromLocalizedHeaders:(id)arg1;
+ (id)localizedHeadersFromEnglishHeaders:(id)arg1;
+ (id)_localizedHeadersForKeys;
+ (id)localizedHeaderForKey:(id)arg1;
+ (id)localizedHeaders;
+ (void)setCustomDisplayedHeaders:(id)arg1;
+ (BOOL)_customHeadersEnabled;
+ (id)customHeadersIgnoringDisabledState;
+ (id)customDisplayedHeaders;
+ (id)basicHeaderKeys;
+ (const char *)cstringForKey:(id)arg1;
+ (BOOL)isHumanReadableHeaderKey:(id)arg1;
+ (BOOL)isMessageIDHeaderKey:(id)arg1;
+ (BOOL)isAddressHeaderKey:(id)arg1;
+ (void)initialize;
@property(readonly, nonatomic) unsigned long long encodingHint; // @synthesize encodingHint=_encodingHint;
//- (void).cxx_destruct;
- (void)_appendAddressList:(id)arg1 toData:(id)arg2;
- (id)description;
- (void)appendHeaderData:(id)arg1 recipients:(id)arg2 recipientsByHeaderKey:(id)arg3 expandGroups:(BOOL)arg4 includeComment:(BOOL)arg5;
- (void)appendHeaderData:(id)arg1 recipients:(id)arg2;
- (id)encodedHeadersIncludingFromSpace:(BOOL)arg1;
- (BOOL)messageIsFromMicrosoft;
- (id)mailVersion;
- (id)_newDecodedMessageIDFromDataInRange:(struct _NSRange)arg1 sender:(id)arg2 consumedLength:(unsigned long long *)arg3;
- (id)_newDecodedAddressFromDataInRange:(struct _NSRange)arg1 sender:(id)arg2 consumedLength:(unsigned long long *)arg3;
- (id)_firstMessageIDForKey:(id)arg1 sender:(id)arg2;
- (id)firstMessageIDForKey:(id)arg1;
- (id)messageIDListForKey:(id)arg1;
- (id)_firstAddressForKey:(id)arg1 sender:(id)arg2;
- (id)firstAddressForKey:(id)arg1;
- (id)addressListForKey:(id)arg1;
- (id)_newHeaderValueForKey:(id)arg1 offset:(unsigned long long *)arg2;
- (id)firstHeaderForKey:(id)arg1;
- (id)_headersForKey:(id)arg1;
- (id)headersForKey:(id)arg1;
- (BOOL)hasHeaderForKey:(id)arg1;
- (void)_setCapitalizedKey:(id)arg1 forKey:(id)arg2;
- (id)_capitalizedKeyForKey:(id)arg1;
- (id)allHeaderKeys;
- (void)_resetSender;
- (id)_sender;
- (id)headerData;
- (id)headersDictionaryForMessageType:(BOOL)arg1;
- (id)_attributedStringForHeaders:(id)arg1;
- (id)attributedStringForAllHeaders;
- (id)attributedString;
- (id)_htmlValueWithKey:(id)arg1 value:(id)arg2 useBold:(BOOL)arg3;
- (id)_htmlHeaderKey:(id)arg1 useBold:(BOOL)arg2 useGray:(BOOL)arg3;
- (id)htmlStringUseBold:(BOOL)arg1 useGray:(BOOL)arg2;
- (id)_headersToDisplayFromHeaderKeys:(id)arg1;
- (id)mutableCopyWithZone:(struct _NSZone *)arg1;
- (id)copyWithZone:(struct _NSZone *)arg1;
- (id)init;
- (id)initWithHeaderData:(id)arg1 encodingHint:(unsigned long long)arg2;

@end

