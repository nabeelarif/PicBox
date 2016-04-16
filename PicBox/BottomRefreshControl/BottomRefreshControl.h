//
//  BottomRefreshControl.h
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomRefreshControlDelegate <NSObject>

-(void)bottomRefreshControlButtonClicked;

@end

@interface BottomRefreshControl : UIView

+ (instancetype)instantiateFromNib;
-(void)showProgressAnimated:(BOOL)animated;
-(void)showButtonWithTitle:(NSString*)title animated:(BOOL)animated;
@property (nonatomic,weak) id<BottomRefreshControlDelegate> delegate;
@end
