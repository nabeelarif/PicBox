//
//  UIFont+Theme.h
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Theme)
+ (UIFont *)labelFont;
+ (UIFont *)labelFontOfSize:(CGFloat)size;
+ (UIFont *)gitFont;
+ (UIFont *)gitFontOfSize:(CGFloat)size;
@end
