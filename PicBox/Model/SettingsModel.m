//
//  SettingsModel.m
//  PicBox
//
//  Created by Nabeel Arif on 4/18/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "SettingsModel.h"

@implementation SettingsModel

#pragma mark - Singleton Pattern
+(instancetype)sharedInstance
{
    static SettingsModel *sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:NSStringFromClass([self class])];
        sharedManager = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if(!sharedManager)
        {
            sharedManager.section = @"top";
            sharedManager.sort = @"viral";
            sharedManager.window = @"day";
            sharedManager.showViral = @(YES);
        }
    });
    
    return sharedManager;
}
@end
