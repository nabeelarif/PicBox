//
//  PicBoxCaptionView.h
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicBoxImageProtocol.h"

@interface PicBoxCaptionView : UIView

/**
 *  Initializer for CaptionView
 *
 *  @param photo An instance of object confirming to PicBoxImage protocol
 *
 *  @return instance of PicBoxCaptionView
 */
- (id)initWithPhoto:(id<PicBoxImage>)photo;
/**
 *  To create your own custom caption view, subclass this view
 *  and override the following two methods (as well as any other
 *  UIView methods that you see fit):

 *  Override -setupCaption so setup your subviews and customise the appearance
 *  of your custom caption
 *  You can access the photo's data by accessing the _photo ivar
 *  If you need more data per photo then simply subclass PicBoxPhoto and return your
 *  subclass to the photo browsers -photoBrowser:photoAtIndex: delegate method
 */
- (void)setupCaption;
/**
 *  Override -sizeThatFits: and return a CGSize specifying the height of your
 *  custom caption view. With width property is ignored and the caption is displayed
 *  the full width of the screen
 */
- (CGSize)sizeThatFits:(CGSize)size;

@end
