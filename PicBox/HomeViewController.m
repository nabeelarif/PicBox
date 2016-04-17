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
#import "UIColor+Theme.h"
#import "PicBoxImage.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@end
@implementation ImageCell

@end

@interface HomeViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSMutableArray<PicBoxImage*> *arrayImages;
@property (nonatomic) BOOL isRequestInProgress;
@property (nonatomic) NSInteger pageNumber;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.arrayImages = [[NSMutableArray<PicBoxImage*> alloc] init];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [super viewDidLoad];
    if (self.currentAlbum) {
        [self loadDataForAlbum:self.currentAlbum];
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        [self reload];
    }
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 100.;
    [refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
    self.collectionView.bottomRefreshControl = refreshControl;
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

    id<IMGObjectProtocol> object = [self.arrayImages objectAtIndex:indexPath.row].imgObject;
    IMGImage * cover = [object coverImage];
    NSURL * coverURL = [cover URLWithSize:IMGMediumThumbnailSize];
    
    if ([cover animated]) {
        NSLog(@"%@",coverURL);
    }
    if ([object isAlbum]) {
        cell.imageViewIcon.hidden = NO;
        cell.imageViewIcon.image = [[UIImage imageNamed:@"gallery_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageViewIcon.layer.cornerRadius = 3.0;
        cell.imageViewIcon.layer.masksToBounds=YES;
        cell.imageViewIcon.tintColor = [UIColor appColorWithLightness:0.3];
        IMGAlbum *album = (IMGAlbum *)object;
        cell.label.text = album.title;
    }else{
        cell.imageViewIcon.hidden = YES;
        IMGImage *image = (IMGImage *)object;
        if (image.title) {
            cell.label.text = image.title;
        }else  if (image.imageDescription) {
            cell.label.text = image.imageDescription;
        }else{
            cell.label.text = nil;
        }
    }
    [cell.imageView sd_setImageWithURL:coverURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            NSLog(@"Null: %@",imageURL);
        }
    }];

    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicBoxImage *pbImage = [self.arrayImages objectAtIndex:indexPath.row];
    id<IMGObjectProtocol> object = pbImage.imgObject;
    
    ImageCell *cell = [self imageCellAtIndexPath:indexPath];
    if ([object isAlbum]) {
        [self launchGalleryForAlbum:(IMGAlbum*)object];
    }else{
        [self launchImageBrowserForImageAtIndex:indexPath sender:cell];
    }
}
- (ImageCell*)imageCellAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *visibleIndexPath = [self.collectionView indexPathForCell:cell];
        if ([indexPath isEqual:visibleIndexPath]) {
            return (ImageCell*)cell;
        }
    }
    return nil;
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
-(void)loadMoreData{
    
    if (self.currentAlbum) {
        [self loadDataForAlbum:self.currentAlbum];
    }else{
        [self reload];
    }
}
-(void)reload{
    
    if (_isRequestInProgress) {
        return;
    }
    _isRequestInProgress =YES;
    [IMGGalleryRequest hotGalleryPage:_pageNumber withViralSort:YES success:^(NSArray *objects) {
        [self.arrayImages addObjectsFromArray:[PicBoxImage photosWithIMGObjects:(NSArray<IMGObjectProtocol> *)objects]];
        _isRequestInProgress = NO;
        _pageNumber++;
        [self.collectionView.bottomRefreshControl endRefreshing];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.bottomRefreshControl endRefreshing];
        _isRequestInProgress = NO;
        
        NSLog(@"gallery request failed - %@" ,error.localizedDescription);
    }];
}
-(void)loadDataForAlbum:(IMGAlbum*)album{
    if (_isRequestInProgress) {
        return;
    }
    _isRequestInProgress =YES;
    [[IMGSession sharedInstance] GET:[NSString stringWithFormat:@"%@/album/%@/images",IMGAPIVersion,album.albumID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * jsonArray = responseObject;
        NSMutableArray * images = [NSMutableArray new];
        
        for(NSDictionary * json in jsonArray){
                NSError *JSONError = nil;
                IMGGalleryImage * image = [[IMGGalleryImage alloc] initWithJSONObject:json error:&JSONError];
                if(!JSONError && image)
                    [images addObject:image];
        }
        [self.arrayImages addObjectsFromArray:[PicBoxImage photosWithIMGObjects:(NSArray<IMGObjectProtocol> *)images]];
        [self.collectionView.bottomRefreshControl endRefreshing];
        _isRequestInProgress = NO;
        _pageNumber++;
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.collectionView.bottomRefreshControl endRefreshing];
        _isRequestInProgress = NO;
        //
    }];
}
#pragma mark - 
-(void)launchGalleryForAlbum:(IMGAlbum*)album{
    HomeViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    home.currentAlbum = album;
    [self.navigationController pushViewController:home animated:YES];
}

- (void)launchImageBrowserForImageAtIndex:(NSIndexPath*)indexPath sender:(ImageCell* )sender
{
    // Create and setup browser
    PicBoxImageBrowser *browser = [[PicBoxImageBrowser alloc] initWithPhotos:self.arrayImages animatedFromView:sender];
    
    [browser setInitialPageIndex:indexPath.row];
    browser.delegate = self;
    browser.displayActionButton = NO;
    browser.displayArrowButton = YES;
    browser.displayCounterLabel = YES;
    browser.usePopAnimation = YES;
    browser.scaleImage = sender.imageView.image;
    
    // Show
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - 
- (IBAction)unwindToHome:(UIStoryboardSegue*)sender
{
}
@end
