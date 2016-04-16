//
//  PicBoxTapDetectingView.m
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "PicBoxTapDetectingView.h"

@implementation PicBoxTapDetectingView

@synthesize tapDelegate;

- (id)init {
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        case 3:
            [self handleTripleTap:touch];
            break;
        default:
            break;
    }
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)handleSingleTap:(UITouch *)touch {
    if ([tapDelegate respondsToSelector:@selector(view:singleTapDetected:)])
        [tapDelegate view:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([tapDelegate respondsToSelector:@selector(view:doubleTapDetected:)])
        [tapDelegate view:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
    if ([tapDelegate respondsToSelector:@selector(view:tripleTapDetected:)])
        [tapDelegate view:self tripleTapDetected:touch];
}

@end
