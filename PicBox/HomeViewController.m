//
//  ViewController.m
//  PicBox
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "HomeViewController.h"
#import <ImgurSession/ImgurSession.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
@implementation ImageCell

@end

@interface HomeViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray<IMGGalleryObjectProtocol> *arrayImages;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.arrayImages = [[NSMutableArray<IMGGalleryObjectProtocol> alloc] init];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [super viewDidLoad];
    [self reload];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrayImages.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = (ImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    id<IMGGalleryObjectProtocol> object = [self.arrayImages objectAtIndex:indexPath.row];
    IMGImage * cover = [object coverImage];
    NSURL * coverURL = [cover URLWithSize:IMGMediumThumbnailSize];
    
    if ([cover animated]) {
        NSLog(@"%@",coverURL);
    }
    if ([object isAlbum]) {
        IMGAlbum *album = (IMGAlbum *)object;
        cell.label.text = album.title;
    }else{
        IMGImage *image = (IMGImage *)object;
        cell.label.text = image.title;
    }
    [cell.imageView sd_setImageWithURL:coverURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            NSLog(@"Null: %@",imageURL);
        }
    }];

    return cell;
}

#pragma mark - Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width/2, 150.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return .0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return .0;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
-(void)reload{
    
    [IMGGalleryRequest hotGalleryPage:0 withViralSort:YES success:^(NSArray *objects) {
        
        //random object from gallery
//        id<IMGGalleryObjectProtocol> object = [objects objectAtIndex:arc4random_uniform((u_int32_t)objects.count)];
//        NSLog(@"retrieved gallery");
        [self.arrayImages addObjectsFromArray:objects];
        [self.collectionView reloadData];
        //get cover image
//        IMGImage * cover = [object coverImage];
//        //get link to 640x640 cover image
//        NSURL * coverURL = [cover URLWithSize:IMGLargeThumbnailSize];
//        
//        //set the image view
//        [self.coverView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:coverURL]]];
//        
//        //set the title
//        self.titleLabel.text = [cover title];
//        //description
//        self.desriptionLabel.text = [cover imageDescription];
        
    } failure:^(NSError *error) {
        
        NSLog(@"gallery request failed - %@" ,error.localizedDescription);
    }];
    
//    if([IMGSession sharedInstance].isAnonymous){
//        
//        self.stateLabel.text = @"Anonymous User";
//    } else {
//        
//        self.stateLabel.text = [NSString stringWithFormat:@"Logged on as: %@",[IMGSession sharedInstance].user.username];
//    }
}
@end
