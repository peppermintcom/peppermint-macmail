//
//  XGSwizzle.m
//  Peppermint
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGSwizzle.h"
#import <objc/runtime.h>

SEL class_swizzleMethod(Class dst, SEL dstName, Class src, SEL srcName, SEL backupName)
{
	XG_TRACE_FUNC();

	if (!backupName)
	{
		NSString* backupString = [NSString stringWithFormat: @"_%x%x_%@",
								  (unsigned int)[NSStringFromClass(src) hash],
								  (unsigned int)[NSStringFromSelector(srcName) hash],
								  NSStringFromSelector(dstName)];
		backupName = NSSelectorFromString(backupString);
	}

	Method original = class_getInstanceMethod(dst, dstName);
	BOOL result = class_addMethod(dst, backupName, method_getImplementation(original), method_getTypeEncoding(original));
	if (!result)
		return FALSE;

	Method overrider = class_getInstanceMethod(src, srcName);
	class_replaceMethod(dst, dstName, method_getImplementation(overrider),
						method_getTypeEncoding(overrider));

	XG_DEBUG(@"[%@ %@] overriden with implementation of [%@ %@]. Backup saved as [%@ %@]",
			 NSStringFromClass(dst), NSStringFromSelector(dstName), NSStringFromSelector(srcName),
			 NSStringFromSelector(srcName), NSStringFromClass(src), NSStringFromSelector(backupName));

	return backupName;
}

BOOL class_unswizzleMethod(Class dst, SEL dstName, SEL swizzleName)
{
	// TODO: need to implement
	return FALSE;
}
