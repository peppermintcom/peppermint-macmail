//
//  XGAttachementGenerator.h
//  PeppermintMail
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "Mail/DocumentEditor.h"
#import <Foundation/Foundation.h>

@interface XGAttachementGenerator : NSObject

+ (instancetype)generatorWithDocument:(DocumentEditor*)documentEditor;

- (BOOL)addAudioAttachment:(NSURL*)url error:(NSError**)error;

@end
