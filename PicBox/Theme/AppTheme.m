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
#import "BottomRefreshControl.h"

@implementation AppTheme
+ (void)applyTheme
{
    [self applyThemeToTableCells];
    [self applyThemeToStatusBar];
    [self applyThemeToNavigationBar];
}

+ (void)applyThemeToTableCells
{
    //Applay theme to UITableView
//    [[UITableView appearance] setBackgroundColor:[UIColor appColorWithLightness:0.95]];
    
    // Apply effects to general label
    [[UILabel appearanceWhenContainedIn:UITableViewCell.class, nil]
     setFont:UIFont.labelFont];
    [[UILabel appearanceWhenContainedIn:UITableViewCell.class, nil]
     setTextColor:UIColor.labelColor];
//    [[UITableViewCell appearance]
//     setBackgroundColor:[UIColor appColorWithLightness:0.95]];
    
    //Selected background Appearance
    UIView *selectionView = [UIView new];
    selectionView.backgroundColor = [UIColor appColorWithLightness:0.95];
    [[UITableViewCell appearance] setSelectedBackgroundView:selectionView];
    
    // Set progress tint color
    [[UIActivityIndicatorView appearance] setColor:[UIColor appColorWithLightness:0.1]];
    
    // BottomRefreshcontrol
    [[BottomRefreshControl appearance] setBackgroundColor:[UIColor appColorWithLightness:0.9]];
    
    //UISearchBar
    [[UISearchBar appearance] setTintColor:[UIColor appColorWithLightness:0.2]];
    
}

+ (void)applyThemeToStatusBar
{
//    [UIStatusBar appearance]
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
