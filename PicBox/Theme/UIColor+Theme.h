//
//  UIColor+Theme.h
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Theme)
+(UIColor*)labelColor;
+(UIColor*)tableViewCellBackgroundColor;
+(UIColor*)appColorWithLightness:(CGFloat)lightness;

#pragma mark - Util
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;
@end
