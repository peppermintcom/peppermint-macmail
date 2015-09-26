//
//  XGLogger.h
//  Peppermint
//
//  Created by Boris Remizov on 12/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/cdefs.h>

// calue type NSNumber, NSUserDefaults key to control trace level, default is 0 - all logs
extern NSString* const XGTraceLevelKey;

// value type NSString, NSUserDefaults key to specify log file be used, default is 'stdout'
extern NSString* const XGTraceFileKey;

// value type NSNumber, NSUserDefaults key to specify maximum number of old log files to keep, min 0, default is 2, max 9
extern NSString* const XGTraceHistory;

__BEGIN_DECLS

extern int XGLog(NSInteger logLevel, NSString* format, ...);

#define XG_PRINT(format, ...) XGLog(0, format, ##__VA_ARGS__)

#define XG_TRACE_FUNC() XGLog(2, @"%s@%@:%d", __PRETTY_FUNCTION__, [[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent], __LINE__)
#define XG_DEBUG(format, ...) XGLog(3, format, ##__VA_ARGS__)
#define XG_TRACE(format, ...) XGLog(2, format, ##__VA_ARGS__)
#define XG_WARNING(format, ...) XGLog(1, format, ##__VA_ARGS__)
#define XG_ERROR(format, ...) XGLog(0, format, ##__VA_ARGS__)

#define XG_CHECK(expr, format, ...) if (!(expr)) XGLog(0, format, ##__VA_ARGS__)

#define XG_ASSERT(expr, format, ...)  if (!(expr)) {XGLog(0, format, ##__VA_ARGS__); assert(false);}

__END_DECLS
