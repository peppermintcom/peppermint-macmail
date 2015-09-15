//
//  XGToolbarDelegateSwizzler.h
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// You could override this class to catch calls of the swizzled class
// call [super toolbarXXXX] functions to pass control to the swizzled
// class (default implementation just does it)
@interface XGToolbarDelegateSwizzler : NSObject<NSToolbarDelegate>

@property (nonatomic, readonly) Class swizzledClass;

- (instancetype)initWithClass:(Class)classToSwizzle;

@end
