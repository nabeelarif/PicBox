//
//  PicBoxImage.h
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicBoxImageProtocol.h"
#import <SDWebImage/SDWebImageManager.h>
#import <IMGImage.h>
#import <IMGAlbum.h>

/**
 *  This class models a photo/image and it's caption
 *  yourself then you can simply ensure your custom data model
 *  conforms to PicBoxPhotoProtocol
 */
@interface PicBoxImage : NSObject <PicBoxImage>

// Progress download block, used to update the circularView
typedef void (^PicBoxProgressUpdateBlock)(CGFloat progress);

#pragma mark - Properties
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) PicBoxProgressUpdateBlock progressUpdateBlock;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) id<IMGObjectProtocol> imgObject;

#pragma mark - Factory methods
+ (PicBoxImage *)photoWithImage:(UIImage *)image;
+ (PicBoxImage *)photoWithFilePath:(NSString *)path;
+ (PicBoxImage *)photoWithURL:(NSURL *)url;
+ (PicBoxImage *)photoWithIMGObject:(id<IMGObjectProtocol>)obj;

+ (NSArray *)photosWithImages:(NSArray *)imagesArray;
+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray;
+ (NSArray *)photosWithURLs:(NSArray *)urlsArray;
+ (NSArray *)photosWithIMGObjects:(NSArray<IMGObjectProtocol> *)objs;

#pragma mark - Initializers
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithFilePath:(NSString *)path;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithIMGObject:(id<IMGObjectProtocol>)obj;

@end
