//
//  ViewController.h
//  PicBox
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicBoxImageBrowser.h"

@class IMGAlbum;
@interface HomeViewController : UICollectionViewController <PicBoxImageBrowserDelegate>
@property (strong, nonatomic) IMGAlbum *currentAlbum;

@end

