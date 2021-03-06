//
//  MicroGitTheme.m
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import "AppTheme.h"
#import <UIKit/UIKit.h>
#import "UIColor+Theme.h"
#import "UIFont+Theme.h"

@implementation AppTheme
+ (void)applyTheme
{
    [self applyThemeToTableCells];
    [self applyThemeToStatusBar];
    [self applyThemeToNavigationBar];
    [self applyThemeToControls];
}

+ (void)applyThemeToTableCells
{
    //Selected background Appearance
    UIView *selectionView = [UIView new];
    selectionView.backgroundColor = [UIColor appColorWithLightness:0.95];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectionView];
    
    // Set progress tint color
    [[UIActivityIndicatorView appearance] setColor:[UIColor appColorWithLightness:0.1]];
    
    //UISearchBar
    [[UISearchBar appearance] setTintColor:[UIColor appColorWithLightness:0.2]];
    
}

+ (void)applyThemeToStatusBar
{
//    [UIStatusBar appearance]
}
+ (void)applyThemeToControls{
    [[UISegmentedControl appearance] setTintColor:[UIColor appColorWithLightness:0.4]];
    [[UISwitch appearance] setTintColor:[UIColor appColorWithLightness:0.3]];
    [[UISwitch appearance] setOnTintColor:[UIColor appColorWithLightness:0.4]];
}
+ (void)applyThemeToNavigationBar
{
    [[UINavigationBar appearance] setBackgroundColor:[UIColor appColorWithLightness:0.5]];
    [[UINavigationBar appearance] setTintColor:[UIColor appColorWithLightness:0.3]];
    [[UILabel appearanceWhenContainedIn:UINavigationBar.class, nil]
     setTextColor:UIColor.redColor];
    
    // Title attribute
    NSShadow * shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor lightGrayColor];
    shadow.shadowOffset = CGSizeMake(0, -2);
    
    NSDictionary * navBarTitleTextAttributes =
  @{ NSForegroundColorAttributeName : [UIColor appColorWithLightness:0.2],
     NSShadowAttributeName          : shadow,
     NSFontAttributeName            : [UIFont boldSystemFontOfSize:18] };
    
    [[UINavigationBar appearance] setTitleTextAttributes:navBarTitleTextAttributes];
}

@end
