//
//  XGToolbarDelegateSwizzler.h
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// @brief You could override this class to catch calls of the swizzled class
//		  call [super toolbarXXXX] functions to pass control to the swizzled
//		  class (default implementation just does it)
@interface XGToolbarDelegateSwizzler : NSObject<NSToolbarDelegate>

@property (nonatomic, readonly) Class swizzledClass;

- (instancetype)initWithClass:(Class)classToSwizzle NS_DESIGNATED_INITIALIZER;

// @brief Get object of "swizzledClass" which method calls were overriden at
//		  this moment. Only available within the NSToolbarDelegate methods
// @return Initial object (but you are NOT allowed to use [self.currentSwizzledObject toolbar:...]
//	       invocations due to swizzle mechanism features - use [super toolbar:...] instead)
//		   or nil (if called outside the method calls. Calls on non-main thread are not allowed.
- (id)currentlySwizzledObject;

@end
