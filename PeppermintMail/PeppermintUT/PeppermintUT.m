//
//  PeppermintUT.m
//  PeppermintUT
//
//  Created by Boris Remizov on 15/09/15.
//  Copyright (c) 2015 Xgen Mobile. All rights reserved.
//

#import "Peppermint/XGPeppermintPlugin.h"
#import "Mail/MessageViewer.h"
#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface PeppermintUT : XCTestCase

@property (nonatomic, strong) XGPeppermintPlugin* peppermintPluign;

@end

@implementation PeppermintUT

- (void)setUp
{
    [super setUp];
	
	// instantiate Peppermint principal class (like Mail does)
	NSBundle* peppermintBundle = [NSBundle bundleWithPath:[@"~/Library/Mail/Bundles/Peppermint.mailbundle" stringByExpandingTildeInPath]];
	XCTAssert(peppermintBundle, @"Can not load the Peppermint plugin");
	
	self.peppermintPluign = [[peppermintBundle principalClass] new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstantiateToolbar {

	// instantiate toolbar
	MessageViewer* messageViewer = [MessageViewer new];
	
	NSToolbar* toolbar = [NSToolbar new];
	toolbar.delegate = messageViewer;
	toolbar.sizeMode = NSToolbarSizeModeDefault;
	toolbar.showsBaselineSeparator = TRUE;
	
	NSWindow* window  = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 300, 200)
													 styleMask:NSResizableWindowMask | NSTitledWindowMask
													   backing:NSBackingStoreBuffered
														 defer:NO];
	window.toolbar = toolbar;
	[window makeKeyAndOrderFront:self];
	[window toggleToolbarShown:self];

	[[NSRunLoop currentRunLoop] run];
}

@end
