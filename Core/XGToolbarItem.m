//
//  XGToolbarItem.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "XGToolbarItem.h"
#import "Core/XGLocalizedString.h"

@implementation XGToolbarItem

- (instancetype)initWithItemIdentifier:(NSString *)itemIdentifier imageName:(NSString*)imageName
{
	XG_TRACE_FUNC();

	self = [super initWithItemIdentifier:itemIdentifier];
	if (!self)
		return nil;
	
	// load image from our bundle, not the Mail's mainBundle
	if (imageName)
	{
		NSBundle* bundle = [NSBundle bundleForClass:[self class]];
		NSString* path = [bundle pathForResource:imageName ofType:@"tiff"];
		if (nil == path)
			XG_ERROR(@"Resource %@ cound not be found in bundle %@", imageName, [bundle bundlePath]);

		NSImage* image = [[NSImage alloc] initWithContentsOfFile:path];

		// create button instead of image
		NSButton* button = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width,
																	  image.size.height)];
		button.bezelStyle = NSTexturedRoundedBezelStyle;
		button.title = XGLocalizedString([itemIdentifier stringByAppendingString:@"_label"], "String of form ToolbarItemIdentifier_label");
		self.view = button;
		self.minSize = CGSizeMake(64, 23);
	}

	// initialize labels
	self.label = XGLocalizedString([itemIdentifier stringByAppendingString:@"_label"], "String of form ToolbarItemIdentifier_label");
	self.paletteLabel = XGLocalizedString([itemIdentifier stringByAppendingString:@"_paletteLabel"], "String of form ToolbarItemIdentifier_paletteLabel");
	
	return self;
}

@end
