//
//  XGPreferences.h
//  Peppermint
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGPreferences : NSObject

+ (instancetype)userPreferences;
+ (instancetype)activePreferences;

@property (nonatomic, copy) NSString* composeBodyText;
@property (nonatomic, copy) NSString* composeSubjectText;
@property (nonatomic, copy) NSString* replyBodyText;
@property (nonatomic, copy) NSString* replySubjectText;

@end
