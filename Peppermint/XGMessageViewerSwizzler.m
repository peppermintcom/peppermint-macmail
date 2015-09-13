//
//  XGMessageViewerSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGMessageViewerSwizzler.h"
#import <Cocoa/Cocoa.h>
#import <objc/runtime.h>

@interface XGMessageViewerSwizzler(SwizzleOriginals)

- (NSArray*)peppermintSwizzled_toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray*)peppermintSwizzled_toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (NSToolbarItem*)peppermintSwizzled_toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag;

@end

@interface XGMessageViewerSwizzler(SwizzleOverrides)

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag;

@end

@implementation XGMessageViewerSwizzler

static BOOL class_copyMethod(Class cls, SEL src, SEL dst)
{
	XG_TRACE_FUNC();

	Method original = class_getInstanceMethod(cls, src);
	return class_addMethod(cls, dst, method_getImplementation(original), method_getTypeEncoding(original));
}

static BOOL class_replaceMethodWithAnother(Class dst, SEL dstName, Class src, SEL srcName)
{
	XG_TRACE_FUNC();

	Method overrider = class_getInstanceMethod(src, srcName);
	class_replaceMethod(dst, dstName, method_getImplementation(overrider),
						method_getTypeEncoding(overrider));
	return TRUE;
}

+ (BOOL)swizzle:(NSError**)error
{
	XG_TRACE_FUNC();

	NSError __autoreleasing* internalError = nil;
	if (NULL == error)
		error = &internalError;

	// find the target MailViewer class in the runtime we called
	Class MessageViewer = NSClassFromString(@"MessageViewer");
	if (NULL == MessageViewer)
	{
		XG_ERROR(@"Could not find class MessageViewer");
		*error = [NSError errorWithDomain:NSOSStatusErrorDomain code:-50 userInfo:nil];
		return FALSE;
	}

	// replace some NSToolbarDelegate implementations with our wrappers (save originals first)
	class_copyMethod(MessageViewer, @selector(toolbarAllowedItemIdentifiers:), @selector(peppermintSwizzled_toolbarAllowedItemIdentifiers:));
	class_replaceMethodWithAnother(MessageViewer, @selector(toolbarAllowedItemIdentifiers:),
						self, @selector(toolbarAllowedItemIdentifiers:));

	class_copyMethod(MessageViewer, @selector(toolbarDefaultItemIdentifiers:), @selector(peppermintSwizzled_toolbarDefaultItemIdentifiers:));
	class_replaceMethodWithAnother(MessageViewer, @selector(toolbarDefaultItemIdentifiers:),
						self, @selector(toolbarDefaultItemIdentifiers:));

	class_copyMethod(MessageViewer, @selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:), @selector(peppermintSwizzled_toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:));
	class_replaceMethodWithAnother(MessageViewer, @selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:),
						[self class], @selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:));

	return TRUE;
}

@end


@implementation XGMessageViewerSwizzler(SwizzleOverrides)

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	return [self peppermintSwizzled_toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	return [self peppermintSwizzled_toolbarDefaultItemIdentifiers:toolbar];
}

- (NSToolbarItem*)toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag
{
	XG_TRACE_FUNC();

	return [self peppermintSwizzled_toolbar:toolbar itemForItemIdentifier:identifier willBeInsertedIntoToolbar:flag];
}

@end

// these methods will be a backups of original methods of Mail's class MailViewer
// the stub implemetations are needed only to avoid warning during compillation,
// and should not be called on runtime
@implementation XGMessageViewerSwizzler(SwizzleOriginals)

- (NSArray*)peppermintSwizzled_toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	// shouldn't be called
	assert(false);
	return nil;
}

- (NSArray*)peppermintSwizzled_toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	// shouldn't be called
	assert(false);
	return nil;
}

- (NSToolbarItem*)peppermintSwizzled_toolbar:(NSToolbar*)toolbar itemForItemIdentifier:(NSString*)identifier willBeInsertedIntoToolbar:(BOOL)flag
{
	// shouldn't be called
	assert(false);
	return nil;
}

@end
