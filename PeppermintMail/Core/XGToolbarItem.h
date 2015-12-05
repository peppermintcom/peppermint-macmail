//
//  XGToolbarItem.h
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

@import Cocoa;

@interface XGToolbarItem : NSToolbarItem

@property (nonatomic, assign) id hint;

- (instancetype)initWithItemIdentifier:(NSString *)itemIdentifier imageName:(NSString*)imageName;

@end
