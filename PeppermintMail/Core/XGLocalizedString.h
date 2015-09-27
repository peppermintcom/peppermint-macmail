//
//  XGLocalizedString.h
//  Peppermint
//
//  Created by Boris Remizov on 25/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XGLocalizedString(key, comment) \
	[[NSBundle bundleForClass:NSClassFromString(@"XGPeppermintPlugin")] localizedStringForKey:(key) value:@"" table:nil]

#define XGLocalizedStringFromTable(key, tbl, comment) \
	[[NSBundle bundleForClass:NSClassFromString(@"XGPeppermintPlugin")] localizedStringForKey:(key) value:@"" table:(tbl)]
