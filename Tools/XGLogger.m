//
//  XGLogger.m
//  Peppermint
//
//  Created by Boris Remizov on 12/09/15.
//  Copyright © 2015 Xgen Mobile. All rights reserved.
//

#import "XGLogger.h"

NSString* const XGTraceLevelKey = @"XGTraceLevel";
NSString* const XGTraceFileKey = @"XGTraceFile";
NSString* const XGTraceHistory = @"XGTraceHistory";


static void rollTraceFiles(NSString* path, NSInteger maxNumber)
{
    // iterate over stored versions of the path and increase their numbers
    // and remove files with numberslarger the maxNumber
    for (NSInteger index = maxNumber - 1; index >= 0; --index)
    {
        NSString* logFile = index > 0 ? [path stringByAppendingPathExtension:[@(index) stringValue]] : path;
        if ([[NSFileManager defaultManager] fileExistsAtPath:logFile])
        {
            NSError* error = nil;
            NSString* newName = [path stringByAppendingPathExtension:[@(index + 1) stringValue]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:newName])
                [[NSFileManager defaultManager] removeItemAtPath:newName error:&error];

            if (index < maxNumber - 1)
                [[NSFileManager defaultManager] moveItemAtPath:logFile toPath:newName error:&error];
        }
    }
}

static NSFileHandle* createLogFileForFile(NSString* file)
{
    if ([file isEqual:@"stdout"])
        return [NSFileHandle fileHandleWithStandardOutput];

    if ([file isEqual:@"stderr"])
        return [NSFileHandle fileHandleWithStandardError];

    // roll old log files
    NSNumber* traceHistory = [[NSUserDefaults standardUserDefaults] objectForKey:XGTraceHistory];
    rollTraceFiles(file, MIN(traceHistory ? [traceHistory unsignedIntegerValue] : 2, 9));

    // output to file
    return [NSFileHandle fileHandleForWritingAtPath:file];
}


void XGLog(NSInteger logLevel, NSString* format, ...)
{
    static NSFileHandle* logFile = nil;
    static NSDateFormatter* dateFormatter = nil;

    if ([[NSUserDefaults standardUserDefaults] integerForKey:XGTraceLevelKey] < logLevel)
        return;

    if (nil == logFile)
    {
        NSString* traceTo = [[NSUserDefaults standardUserDefaults] objectForKey:XGTraceFileKey];
        logFile = createLogFileForFile(traceTo ? traceTo : @"stdout");
    }

    if (nil == dateFormatter)
    {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }

    va_list ap;
    va_start(ap, format);
    NSString* logString = [[[NSString alloc] initWithFormat:format arguments:ap] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    va_end(ap);

    NSString* fullLogString = [NSString stringWithFormat:@"%@\t%@\t%@\n", [dateFormatter stringFromDate:[NSDate date]], @(logLevel), logString];

    [logFile writeData:[fullLogString dataUsingEncoding:NSUTF8StringEncoding]];
}
