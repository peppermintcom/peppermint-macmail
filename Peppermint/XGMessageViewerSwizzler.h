//
//  XGMessageViewerSwizzler.h
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "Core/XGToolbarDelegateSwizzler.h"
#import <Foundation/Foundation.h>

@interface XGMessageViewerSwizzler : XGToolbarDelegateSwizzler

+ (instancetype)sharedInstance;

@end
