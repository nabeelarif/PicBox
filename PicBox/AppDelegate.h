//
//  AppDelegate.h
//  PicBox
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImgurSession/ImgurSession.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,IMGSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (copy) void(^continueHandler)();

@end

