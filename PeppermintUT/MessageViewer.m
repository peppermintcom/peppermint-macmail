//
//  MessageViewer.m
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "Mail/MessageViewer.h"
#import <Foundation/Foundation.h>


// dummy implementation of the corresponding Mail class
@implementation MessageViewer

+ (NSArray*)allMessageViewers
{
	return @[];
}

+ (NSArray*)allSingleMessageViewers
{
	return @[];
}

- (IBAction)showComposeWindow:(id)sender
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	return @[NSToolbarFlexibleSpaceItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	return @[NSToolbarFlexibleSpaceItemIdentifier, NSToolbarCustomizeToolbarItemIdentifier];
}

- (NSToolbarItem*)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	return nil;
}

@end
