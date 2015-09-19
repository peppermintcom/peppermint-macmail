//
//  XGNumberFormatters.m
//  Peppermint
//
//  Created by Boris Remizov on 19/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XG2DigitsNumberFormatter : NSValueTransformer

@end

@implementation XG2DigitsNumberFormatter

+ (Class)transformedValueClass
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	return [NSString stringWithFormat:@"%02d", [value intValue]];
}

- (id)reverseTransformedValue:(id)value
{
	return @([value intValue]);
}

@end


@interface XG3DigitsNumberFormatter : NSFormatter

@end

@implementation XG3DigitsNumberFormatter

+ (Class)transformedValueClass
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	return [NSString stringWithFormat:@"%03d", [value intValue]];
}

- (id)reverseTransformedValue:(id)value
{
	return @([value intValue]);
}

@end
