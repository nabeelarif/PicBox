//
//  PicBoxTapDetectingImageView.m
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "PicBoxTapDetectingImageView.h"

@implementation PicBoxTapDetectingImageView

@synthesize tapDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
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
    if ([tapDelegate respondsToSelector:@selector(imageView:singleTapDetected:)])
        [tapDelegate imageView:self singleTapDetected:touch];
}

- (void)handleDoubleTap:(UITouch *)touch {
    if ([tapDelegate respondsToSelector:@selector(imageView:doubleTapDetected:)])
        [tapDelegate imageView:self doubleTapDetected:touch];
}

- (void)handleTripleTap:(UITouch *)touch {
    if ([tapDelegate respondsToSelector:@selector(imageView:tripleTapDetected:)])
        [tapDelegate imageView:self tripleTapDetected:touch];
}

@end
