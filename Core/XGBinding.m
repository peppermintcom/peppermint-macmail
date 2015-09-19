//
//  SP2WayBinding.m
//  Out Of Your Head
//
//  Created by Boris Remizov on 7/15/14.
//
//

#import "XGBinding.h"
@import AppKit;

@implementation XGBinding
{
    NSDictionary* _observable;
	NSMutableSet* _ignoredObjects;
}

@dynamic binding1, binding2, object1, object2;

+ (XGBinding*)bind:(NSString *)binding ofObject:(NSObject*)object toObject:(id)observable withKeyPath:(NSString *)keyPath
{
	return [[XGBinding alloc] initAndBind:binding ofObject:object toObject:observable withKeyPath:keyPath];
}

- (id)initAndBind:(NSString *)binding ofObject:(NSObject*)object toObject:(id)observable withKeyPath:(NSString *)keyPath
{
    self = [super init];
    if (!self)
        return nil;

	_ignoredObjects = [NSMutableSet new];
	_observable = @{
		@"Object": object,
		@"Observable": observable,
		@"Binding": [NSString stringWithString:binding],
		@"KeyPath": [NSString stringWithString:keyPath]
	};

	[object bind:binding toObject:observable withKeyPath:keyPath options:nil];
	[object addObserver:self forKeyPath:binding options:NSKeyValueObservingOptionNew context:(void*)100500];
	
//	[object addObserver:self forKeyPath:binding options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior context:(void*)100501];
//	[observable addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior context:(void*)100501];
	
	return self;
}

- (void)dealloc
{
	[self unbind];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ((void*)100500 == context)
	{
		[_observable[@"Observable"] setValue:change[NSKeyValueChangeNewKey] forKeyPath:_observable[@"KeyPath"]];
	}
	else if ((void*)100501 == context)
	{
		// place to ignorance list
		[_ignoredObjects addObject:object];
	}
}

- (void)unbind
{
	// unbind
	[_observable[@"Object"] removeObserver:self forKeyPath:_observable[@"Binding"] context:(void*)100500];
	[_observable[@"Object"] unbind:_observable[@"Binding"]];

	_observable = nil;
}

- (NSObject*)object1
{
	return _observable[@"Object"];
}

- (NSString*)binding1
{
	return _observable[@"Binding"];
}

- (NSObject*)object2
{
	return _observable[@"Observable"];
}

- (NSString*)binding2
{
	return _observable[@"KeyPath"];
}

@end
