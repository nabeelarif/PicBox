//
//  SettingsModel.h
//  PicBox
//
//  Created by Nabeel Arif on 4/18/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultBaseModel.h"

@interface SettingsModel : UserDefaultBaseModel
@property (nonatomic, strong) NSString *section;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *layout;
@property (nonatomic, strong) NSString *window;
@property (nonatomic, strong) NSNumber *showViral;

#pragma mark - Singleton pattern
+(instancetype)sharedInstance;
@end
