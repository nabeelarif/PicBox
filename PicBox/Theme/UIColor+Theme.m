//
//  UIColor+Theme.m
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import "UIColor+Theme.h"

#define appColorArray [NSArray arrayWithObjects:@"#ffffff",@"#ebfafa",@"#d6f5f5",@"#c2f0f0",@"#adebeb",@"#99e6e6",@"#85e0e0",@"#70dbdb",@"#5cd6d6",@"#47d1d1",@"#33cccc",@"#2eb8b8",@"#29a3a3",@"#248f8f",@"#1f7a7a",@"#196666",@"#145252",@"#0f3d3d",@"#0a2929",@"#051414",@"#000000", nil]
#define appColorArrayRed [NSArray arrayWithObjects:@"#ffffff",@"#ffe6e6",@"#ffcccc",@"#ffb3b3",@"#ff9999",@"#ff8080",@"#ff6666",@"#ff4d4d",@"#ff3333",@"#ff1a1a",@"#ff0000",@"#e60000",@"#cc0000",@"#b30000",@"#990000",@"#800000",@"#660000",@"#4d0000",@"#330000",@"#1a0000",@"#000000",nil]


@implementation UIColor (Theme)

+(UIColor*)labelColor{
    return [UIColor blackColor];
}
+(UIColor*)tableViewCellBackgroundColor{
    return [UIColor whiteColor];
}
+(UIColor*)appColorWithLightness:(CGFloat)lightness
{
    NSInteger index = round(lightness*20.);
    index = index%20;
    index = 20-index;
    NSString *colorCode = (NSString *)[appColorArray objectAtIndex:index];
    return [self colorWithHex:colorCode alpha:1.0];
}

#pragma mark - Util methods

+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    
    assert(7 == [hex length]);
    assert('#' == [hex characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
}
@end
