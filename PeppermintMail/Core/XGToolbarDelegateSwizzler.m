//
//  XGToolbarDelegateSwizzler.m
//  Peppermint
//
//  Created by Boris Remizov on 13/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGToolbarDelegateSwizzler.h"
#import "XGSwizzle.h"

static NSMutableDictionary* swizzlers = nil;

static NSMutableDictionary* swizzleContextForClass(Class class)
{
	NSString* className = NSStringFromClass(class);

	// find swizzler
	NSMutableDictionary* info = swizzlers[className];
	if (nil == info)
	{
		// error, can't find info for self
		XG_ERROR(@"Can not find swizzle context for %@]", className);
		return nil;
	}

	return info;
}


@interface XGToolbarDelegateSwizzler(Override)

- (NSToolbarItem *)overrideToolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray*)overrideToolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray*)overrideToolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;

@end


@protocol XGToolbarDelegateSwizzlerOriginal

- (NSToolbarItem*)originalToolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
- (NSArray*)originalToolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray*)originalToolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;

@end


@implementation XGToolbarDelegateSwizzler
{
	Class _swizzledClass;
}

+ (void)initialize
{
	XG_TRACE_FUNC();

	if (swizzlers)
		return;

	swizzlers = [NSMutableDictionary new];
}

- (instancetype)initWithClass:(Class)classToSwizzle
{
	self = [super init];
	if (!self)
		return nil;

	_swizzledClass = classToSwizzle;

	XG_ERROR(@"%s called on thread %@", __PRETTY_FUNCTION__, [NSThread currentThread]);
	NSAssert([NSThread isMainThread], @"%s must be called on the main thread only", __PRETTY_FUNCTION__);

	NSString* classNameToSwizzle = NSStringFromClass(classToSwizzle);

	// check the class if already swizzled (no chaining support)
	if (swizzlers[classNameToSwizzle])
	{
		XG_ERROR(@"Class %@ already swizzled. %@", classNameToSwizzle,
				 [swizzlers[classNameToSwizzle][@"Swizzler"] nonretainedObjectValue]);
		return nil;
	}

	// register us
	swizzlers[classNameToSwizzle] = [NSMutableDictionary dictionaryWithDictionary:@{
		@"Swizzler" : [NSValue valueWithNonretainedObject:self]
	}];

	// swizzle
	class_swizzleMethod(classToSwizzle, @selector(toolbarAllowedItemIdentifiers:),
						[XGToolbarDelegateSwizzler class], @selector(overrideToolbarAllowedItemIdentifiers:),
						@selector(originalToolbarAllowedItemIdentifiers:));

	class_swizzleMethod(classToSwizzle, @selector(toolbarDefaultItemIdentifiers:),
						[XGToolbarDelegateSwizzler class], @selector(overrideToolbarDefaultItemIdentifiers:),
						@selector(originalToolbarDefaultItemIdentifiers:));

	class_swizzleMethod(classToSwizzle, @selector(toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:),
						[XGToolbarDelegateSwizzler class], @selector(overrideToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:),
						@selector(originalToolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:));

	return self;
}

- (void)dealloc
{
	XG_TRACE_FUNC();

	// TODO: unswizzle
}

- (id)currentlySwizzledObject
{
	// call original method (got from current context)
	NSDictionary* context = swizzleContextForClass(self.swizzledClass);
	return [context[@"Original"] nonretainedObjectValue];
}

// default NSToolbarDelegate implementation
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	XG_TRACE_FUNC();

	// call original method (got from current context)
	id<XGToolbarDelegateSwizzlerOriginal> original = self.currentlySwizzledObject;
	XG_ASSERT(original, @"The Original pointer not found in swizzle context");
	return [original originalToolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];
}

- (NSArray*)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	// call original method (got from current context)
	id<XGToolbarDelegateSwizzlerOriginal> original = self.currentlySwizzledObject;
	XG_ASSERT(original, @"The Original pointer not found in swizzle context");
	return [original originalToolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray*)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	XG_TRACE_FUNC();

	// call original method (got from current context)
	id<XGToolbarDelegateSwizzlerOriginal> original = self.currentlySwizzledObject;
	XG_ASSERT(original, @"The Original pointer not found in swizzle context");
	return [original originalToolbarAllowedItemIdentifiers:toolbar];
}

@end

@implementation XGToolbarDelegateSwizzler(Override)

- (NSToolbarItem *)overrideToolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	XG_DEBUG(@"%s called in class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));

	NSMutableDictionary* context = swizzleContextForClass([self class]);
	id<NSToolbarDelegate> swizzler = [context[@"Swizzler"] nonretainedObjectValue];

	// update context and call overriding method in overriding class
	// self here is an object of the "swizzledClass", not XGToolbarDelegateSwizzler
	context[@"Original"] = [NSValue valueWithNonretainedObject:self];

	// forward call to "swizzler" i.e. our XGToolbarDelegateSwizzler class/subclass
	NSToolbarItem* item = [swizzler toolbar:toolbar itemForItemIdentifier:itemIdentifier willBeInsertedIntoToolbar:flag];

	[context removeObjectForKey:@"Original"];

	return item;
}

- (NSArray*)overrideToolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	XG_DEBUG(@"%s called in class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));

	NSMutableDictionary* context = swizzleContextForClass([self class]);
	id<NSToolbarDelegate> swizzler = [context[@"Swizzler"] nonretainedObjectValue];

	// update context and call overriding method in overriding class
	// self here is an object of the "swizzledClass", not XGToolbarDelegateSwizzler
	context[@"Original"] = [NSValue valueWithNonretainedObject:self];

	// forward call to "swizzler" i.e. our XGToolbarDelegateSwizzler class/subclass
	NSArray* identifiers = [swizzler toolbarDefaultItemIdentifiers:toolbar];

	[context removeObjectForKey:@"Original"];

	return identifiers;

}

- (NSArray*)overrideToolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	XG_DEBUG(@"%s called in class %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));

	NSMutableDictionary* context = swizzleContextForClass([self class]);
	id<NSToolbarDelegate> swizzler = [context[@"Swizzler"] nonretainedObjectValue];

	// update context and call overriding method in overriding class
	// self here is an object of the "swizzledClass", not XGToolbarDelegateSwizzler
	context[@"Original"] = [NSValue valueWithNonretainedObject:self];

	// forward call to "swizzler" i.e. our XGToolbarDelegateSwizzler class/subclass
	NSArray* identifiers = [swizzler toolbarAllowedItemIdentifiers:toolbar];

	[context removeObjectForKey:@"Original"];

	return identifiers;
}

@end
