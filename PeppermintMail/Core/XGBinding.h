//
//  SP2WayBinder.h
//  Out Of Your Head
//
//  Created by Boris Remizov on 7/15/14.
//
//

#import <Foundation/Foundation.h>

@interface XGBinding : NSObject

@property (nonatomic, readonly) NSObject* object1;
@property (nonatomic, readonly) NSString* binding1;
@property (nonatomic, readonly) NSObject* object2;
@property (nonatomic, readonly) NSString* binding2;

+ (instancetype)bind:(NSString *)binding ofObject:(NSObject*)object toObject:(id)observable withKeyPath:(NSString *)keyPath;

- (void)unbind;

@end
