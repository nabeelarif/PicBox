//
//  BottomRefreshControl.m
//  Micro Git
//
//  Created by Nabeel Arif on 2/14/16.
//  Copyright © 2016 Nabeel. All rights reserved.
//

#import "BottomRefreshControl.h"
@interface BottomRefreshControl()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;

@end

@implementation BottomRefreshControl


+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}
- (IBAction)actionButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(bottomRefreshControlButtonClicked)]) {
        [_delegate bottomRefreshControlButtonClicked];
    }
}
-(void)showProgressAnimated:(BOOL)animated{
    [self.progressIndicator startAnimating];
    if (animated) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.progressIndicator.alpha=1.;
            self.button.alpha=0.;
        } completion:^(BOOL finished) {
            [self.button setEnabled:NO];
        }];
    }else{
        self.progressIndicator.alpha=1.;
        self.button.alpha=0.;
    }
}
-(void)showButtonWithTitle:(NSString*)title animated:(BOOL)animated{
    _button.titleLabel.text = title;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.progressIndicator.alpha=0.;
            self.button.alpha=1.;
        } completion:^(BOOL finished) {
            [self.button setEnabled:YES];
            [self.progressIndicator stopAnimating];
        }];
    }else{
        self.progressIndicator.alpha=0.;
        self.button.alpha=1.;
        [self.progressIndicator stopAnimating];
    }
}

@end
