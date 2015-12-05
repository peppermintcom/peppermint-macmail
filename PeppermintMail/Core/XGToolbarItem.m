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
{
	SEL _action;
	id _target;
}

- (instancetype)initWithItemIdentifier:(NSString *)itemIdentifier imageName:(NSString*)imageName
{
	XG_TRACE_FUNC();

	self = [super initWithItemIdentifier:itemIdentifier];
	if (!self)
		return nil;
	
	// create button instead of image
	NSButton* button = [[NSButton alloc] initWithFrame:CGRectZero];
	button.bezelStyle = NSTexturedRoundedBezelStyle;
	self.view = button;

	if (imageName)
	{
		// load image from our bundle, not the Mail's mainBundle
		NSBundle* bundle = [NSBundle bundleForClass:[self class]];
		NSString* path = [bundle pathForResource:imageName ofType:@"tiff"];
		if (nil == path)
			XG_ERROR(@"Resource %@ cound not be found in bundle %@", imageName, [bundle bundlePath]);
		button.image = [[NSImage alloc] initWithContentsOfFile:path];
		button.imagePosition = NSImageOnly;
	}

	button.target = self;
	button.action = @selector(buttonPressed:);

	self.minSize = CGSizeMake(40, 23);

	// initialize labels
	self.label = XGLocalizedString([itemIdentifier stringByAppendingString:@"_label"], "String of form ToolbarItemIdentifier_label");
	self.paletteLabel = XGLocalizedString([itemIdentifier stringByAppendingString:@"_paletteLabel"], "String of form ToolbarItemIdentifier_paletteLabel");
	
	return self;
}

- (void)buttonPressed:(id)sender
{
	if (_target && _action)
		[_target performSelector:_action withObject:self];
}

- (void)setTarget:(id)target
{
	_target = target;
}

- (id)target
{
	return _target;
}

- (void)setAction:(SEL)action
{
	_action = action;
}

- (SEL)action
{
	return _action;
}

@end
