//
//  PicBoxZoomingScrollView.h
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicBoxImageProtocol.h"
#import "PicBoxTapDetectingImageView.h"
#import "PicBoxTapDetectingView.h"

#import <DACircularProgress/DACircularProgressView.h>

@class PicBoxImageBrowser, PicBoxImage, PicBoxCaptionView;

@interface PicBoxZoomingScrollView : UIScrollView <UIScrollViewDelegate, PicBoxTapDetectingImageViewDelegate, PicBoxTapDetectingViewDelegate> {
    
    PicBoxImageBrowser *__weak _photoBrowser;
    id<PicBoxImage> _photo;
    
    // This view references the related caption view for simplified handling in photo browser
    PicBoxCaptionView *_captionView;
    
    PicBoxTapDetectingView *_tapView; // for background taps
    
    DACircularProgressView *_progressView;
}

@property (nonatomic, strong) PicBoxTapDetectingImageView *photoImageView;
@property (nonatomic, strong) PicBoxCaptionView *captionView;
@property (nonatomic, strong) id<PicBoxImage> photo;

- (id)initWithPhotoBrowser:(PicBoxImageBrowser *)browser;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setProgress:(CGFloat)progress forPhoto:(PicBoxImage*)photo;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

@end
