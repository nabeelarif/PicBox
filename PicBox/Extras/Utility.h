//
//  Utility.h
//  PicBox
//
//  Created by Nabeel Arif on 4/18/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

#pragma mark -
#pragma mark - Build version and dates
+ (NSString *) appVersion;
+ (NSString *) appBuildNumber;
+ (NSString *) versionBuild;
+ (NSString *) buildDate;

@end
