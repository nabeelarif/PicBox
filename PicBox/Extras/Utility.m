//
//  Utility.m
//  PicBox
//
//  Created by Nabeel Arif on 4/18/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "Utility.h"

@implementation Utility

#pragma mark - Build version and dates
+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) appBuildNumber
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

+ (NSString *) versionBuild
{
    NSString * version = [self appVersion];
    NSString * build = [self appBuildNumber];
    
    NSString * versionBuild = [NSString stringWithFormat: @"%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}
+ (NSString *) buildDate {
    NSString *_buildDate;
    
    // Get build date and time, format to 'yyMMddHHmm'
    //NSString *dateStr = [NSString stringWithFormat:@"%@ %@", [NSString stringWithUTF8String:__DATE__], [NSString stringWithUTF8String:__TIME__]];
    NSString * buildDate = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"];
    
    // Convert to date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"LLL d yyyy HH:mm:ss z"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    NSDate *date = [dateFormat dateFromString:buildDate];
    
    // Set output format and convert to string
    dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    dateFormat.timeStyle = NSDateFormatterMediumStyle;
    _buildDate = [dateFormat stringFromDate:date];
    
    return _buildDate;
}

@end
