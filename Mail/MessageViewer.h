//
//  MessageViewer.h
//  Peppermint
//
//  Created by Boris Remizov on 14/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Mail class partial declaration
@interface MessageViewer : NSResponder<NSToolbarDelegate>

+ (NSArray*)allMessageViewers;
+ (NSArray*)allSingleMessageViewers;

- (IBAction)showComposeWindow:(id)sender;

@end
