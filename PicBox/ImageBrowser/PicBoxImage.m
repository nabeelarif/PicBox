//
//  PicBoxImage.m
//  PicBox
//
//  Created by Nabeel Arif on 4/17/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "PicBoxImage.h"
#import "PicBoxImageBrowser.h"
#import "Utility.h"
#import <IMGGalleryImage.h>
#import <IMGGalleryAlbum.h>

// Private
@interface PicBoxImage () {
    // Image Sources
    NSString *_photoPath;
    
    // Image
    UIImage *_underlyingImage;
    
    // Other
    NSString *_caption;
    BOOL _loadingInProgress;
}

// Properties
@property (nonatomic, strong) UIImage *underlyingImage;

// Methods
- (void)imageLoadingComplete;

@end

@implementation PicBoxImage


// Properties
@synthesize underlyingImage = _underlyingImage,
photoURL = _photoURL,
caption = _caption;

#pragma mark Class Methods

+ (PicBoxImage *)photoWithImage:(UIImage *)image {
    return [[PicBoxImage alloc] initWithImage:image];
}

+ (PicBoxImage *)photoWithFilePath:(NSString *)path {
    return [[PicBoxImage alloc] initWithFilePath:path];
}

+ (PicBoxImage *)photoWithURL:(NSURL *)url {
    return [[PicBoxImage alloc] initWithURL:url];
}
+ (PicBoxImage *)photoWithIMGObject:(id<IMGObjectProtocol>)obj{
    return [[PicBoxImage alloc] initWithIMGObject:obj];
}

+ (NSArray *)photosWithImages:(NSArray *)imagesArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imagesArray.count];
    
    for (UIImage *image in imagesArray) {
        if ([image isKindOfClass:[UIImage class]]) {
            PicBoxImage *photo = [PicBoxImage photoWithImage:image];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:pathsArray.count];
    
    for (NSString *path in pathsArray) {
        if ([path isKindOfClass:[NSString class]]) {
            PicBoxImage *photo = [PicBoxImage photoWithFilePath:path];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithURLs:(NSArray *)urlsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:urlsArray.count];
    
    for (id url in urlsArray) {
        if ([url isKindOfClass:[NSURL class]]) {
            PicBoxImage *photo = [PicBoxImage photoWithURL:url];
            [photos addObject:photo];
        }
        else if ([url isKindOfClass:[NSString class]]) {
            PicBoxImage *photo = [PicBoxImage photoWithURL:[NSURL URLWithString:url]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}
+ (NSArray *)photosWithIMGObjects:(NSArray<IMGObjectProtocol> *)objs {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:objs.count];
    
    for (id<IMGObjectProtocol> obj in objs) {
        if ([obj conformsToProtocol:@protocol(IMGObjectProtocol)]) {
            PicBoxImage *photo = [PicBoxImage photoWithIMGObject:obj];
            [photos addObject:photo];
        }
    }
    
    return photos;
}
#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        self.underlyingImage = image;
    }
    return self;
}

- (id)initWithFilePath:(NSString *)path {
    if ((self = [super init])) {
        _photoPath = [path copy];
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        self.photoURL = [url copy];
    }
    return self;
}

- (instancetype)initWithIMGObject:(id<IMGObjectProtocol>)obj{
    
    if ((self = [super init])) {
        _imgObject = obj;
    }
    return self;
}
#pragma mark - Instance Methods
-(NSString *)caption{
    if (_imgObject) {
        IMGGalleryImage *image;
        NSMutableString *strCaption = [NSMutableString new];
        if ([_imgObject isAlbum]) {
//            IMGImage *cover = [_imgObject coverImage];
            IMGGalleryAlbum *album = (IMGGalleryAlbum *)_imgObject;
            [strCaption appendString:@"-- ALBUM COVER --\n"];
            if (album.title) {
                [strCaption appendFormat:@"[%@]\n",album.title];
            }else if (album.albumDescription){
                [strCaption appendFormat:@"%@\n",album.albumDescription];
            }
            [strCaption appendFormat:@"Views: %ld\n",(long)album.views];
            [strCaption appendFormat:@"Votes: %ld\n",(long)album.vote];
            [strCaption appendFormat:@"Ups: %ld\n",(long)album.ups];
            [strCaption appendFormat:@"Downs: %ld\n",(long)album.downs];
            [strCaption appendFormat:@"Scores: %ld\n",(long)album.score];
            [strCaption appendFormat:@"Created: %@\n",[Utility stringLocalTimeFromDate:album.datetime]];
            [strCaption appendFormat:@"Image Count: %ld\n",(long)album.imagesCount];
        }else{
            image = (IMGGalleryImage*)_imgObject;
            if (image.title) {
                [strCaption appendFormat:@"[%@]\n",image.title];
            }else if (image.imageDescription){
                [strCaption appendFormat:@"%@\n",image.imageDescription];
            }
            [strCaption appendFormat:@"Views: %ld\n",(long)image.views];
            [strCaption appendFormat:@"Votes: %ld\n",(long)image.vote];
            [strCaption appendFormat:@"Ups: %ld\n",(long)image.ups];
            [strCaption appendFormat:@"Downs: %ld\n",(long)image.downs];
            [strCaption appendFormat:@"Scores: %ld\n",(long)image.score];
            [strCaption appendFormat:@"Created: %@\n",[Utility stringLocalTimeFromDate:image.datetime]];
        }
        return [NSString stringWithString:strCaption];
    }
    return _caption;
}
-(NSURL *)photoURL{
    if (_imgObject) {
        IMGImage *image;
        if ([_imgObject isAlbum]) {
            image = [_imgObject coverImage];
        }else{
            image = (IMGImage*)_imgObject;
        }
        return image.url;
    }
    return _photoURL;
}
#pragma mark PicBoxImage Protocol Methods

- (UIImage *)underlyingImage {
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    _loadingInProgress = YES;
    if (self.underlyingImage) {
        // Image already loaded
        [self imageLoadingComplete];
    } else {
        if (_photoPath) {
            // Load async from file
            [self performSelectorInBackground:@selector(loadImageFromFileAsync) withObject:nil];
        } else if (self.photoURL) {
            // Load async from web (using SDWebImageManager)
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:self.photoURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                CGFloat progress = ((CGFloat)receivedSize)/((CGFloat)expectedSize);
                if (self.progressUpdateBlock) {
                    self.progressUpdateBlock(progress);
                }
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (image) {
                    self.underlyingImage = image;
                    [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
                }
            }];
            
        } else {
            // Failed - no source
            self.underlyingImage = nil;
            [self imageLoadingComplete];
        }
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
    
    if (self.underlyingImage && (_photoPath || self.photoURL)) {
        self.underlyingImage = nil;
    }
}

#pragma mark - Async Loading

- (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images)
    {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

// Called in background
// Load image in background from local file
- (void)loadImageFromFileAsync {
    @autoreleasepool {
        @try {
            self.underlyingImage = [UIImage imageWithContentsOfFile:_photoPath];
            if (!_underlyingImage) {
                //PicBoxLog(@"Error loading photo from path: %@", _photoPath);
            }
        } @finally {
            self.underlyingImage = [self decodedImageWithImage: self.underlyingImage];
            [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
        }
    }
}

// Called on main
- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:PicBoxImage_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}


@end
