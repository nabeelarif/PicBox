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
#import "SettingsModel.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@end
@implementation ImageCell

@end
/**
 *  This Category on IMGImage fixes a thumbnail url issue.
 *  In this particular issue url already has 'h' as suffix, so
 *  to get a thumbnail with suffix 'm' i.e medium so should remove 'h' first
 */
@interface IMGImage (URLIssueFixed)

- (NSURL *)fixedGifURLWithSize:(IMGSize)size;
@end
@implementation IMGImage (URLIssueFixed)

- (NSURL *)fixedGifURLWithSize:(IMGSize)size{
    NSURL *url = [self URLWithSize:size];
    NSString *lastPath = [[url absoluteString] lastPathComponent];
    if (lastPath.length>12) {
        NSString *absoluteStr = [url absoluteString];
        absoluteStr = [absoluteStr stringByReplacingCharactersInRange:NSMakeRange(absoluteStr.length-6, 1) withString:@""];
        url = [NSURL URLWithString:absoluteStr];
    }
    return url;
}

@end

@interface HomeViewController () <UICollectionViewDelegateFlowLayout, UISearchBarDelegate, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic,strong) NSMutableArray<PicBoxImage*> *arrayImages;
@property (nonatomic) BOOL isRequestInProgress;
@property (nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnAbout;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnSearch;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barBtnSettings;
- (IBAction)actionSearch:(id)sender;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *strSearch;
@property (nonatomic, strong) NSString *currentLayout;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.arrayImages = [[NSMutableArray<PicBoxImage*> alloc] init];
    self.collectionView.backgroundColor = [UIColor grayColor];
    [super viewDidLoad];
    if (self.currentAlbum) {
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }else{
        self.searchBar = [[UISearchBar alloc] init];
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.text = nil;
        _searchBar.placeholder = NSLocalizedString(@"Search Gallery ...", nil);
    }
    ((CHTCollectionViewWaterfallLayout*)self.collectionViewLayout).minimumColumnSpacing = 4;
    ((CHTCollectionViewWaterfallLayout*)self.collectionViewLayout).minimumInteritemSpacing = 4;
    _currentLayout = kImgurLayoutGrid;
    [self settingsLayoutUpdated:nil];
    [self addBottomRefreshControl:(self.currentAlbum==nil)];
    [self loadMoreData];
    
    //Add bottom refresh control
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(settingsUpdated:) name:kNotificationSettingsUpdated object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(settingsLayoutUpdated:) name:kNotificationSettingsLayoutUpdated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    _barBtnSettings = nil;
    _barBtnAbout = nil;
    _barBtnSearch = nil;
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationSettingsUpdated object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self name:kNotificationSettingsLayoutUpdated object:nil];
}
-(void)addBottomRefreshControl:(BOOL)add{
    if(add && self.collectionView.bottomRefreshControl == nil){
        
        UIRefreshControl *refreshControl = [UIRefreshControl new];
        refreshControl.triggerVerticalOffset = 100.;
        [refreshControl addTarget:self action:@selector(loadMoreData) forControlEvents:UIControlEventValueChanged];
        self.collectionView.bottomRefreshControl = refreshControl;
    }else if(!add && self.collectionView.bottomRefreshControl){
        self.collectionView.bottomRefreshControl = nil;
    }
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        [self setColumnCount];
        [self.collectionView reloadData];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
    }];
}
#pragma mark - Collection View Data Source
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
    NSURL * imageUrl;
    
//    if ([cover animated]) {
//        NSLog(@"%@",coverURL);
//    }
    if ([object isAlbum]) {
        cell.imageViewIcon.hidden = NO;
        cell.imageViewIcon.image = [[UIImage imageNamed:@"gallery_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageViewIcon.layer.cornerRadius = 3.0;
        cell.imageViewIcon.layer.masksToBounds=YES;
        cell.imageViewIcon.tintColor = [UIColor appColorWithLightness:0.3];
        IMGAlbum *album = (IMGAlbum *)object;        
        if (album.title) {
            cell.label.text = album.title;
        }else  if (album.albumDescription) {
            cell.label.text = album.albumDescription;
        }else{
            cell.label.text = nil;
        }
        IMGImage * cover = [object coverImage];
        imageUrl = [cover fixedGifURLWithSize:IMGMediumThumbnailSize];
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
        imageUrl = [image fixedGifURLWithSize:IMGMediumThumbnailSize];
    }
    [cell.imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    
    id<IMGObjectProtocol> object = [self.arrayImages objectAtIndex:indexPath.row].imgObject;
    IMGImage * cover;
    if ([object isAlbum]) {
        NSLog(@"isAlbum");
        cover = [object coverImage];
    }else{
        NSLog(@"Not isAlbum");
        cover = (IMGImage*)object;
    }
    
    if ([[SettingsModel sharedInstance].layout isEqualToString:kImgurLayoutList]) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width-4;
        return CGSizeMake(width, 180.0);
    }else if ([[SettingsModel sharedInstance].layout isEqualToString:kImgurLayoutGrid]) {
        CGFloat width =150;
        return CGSizeMake(width, 150.0);
    }else { // Staggered Grid
        CGFloat width =150;
        return CGSizeMake(width, [cover height]*(width/[cover width]));
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
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
    browser.displayActionButton = YES;
    browser.displayArrowButton = YES;
    browser.displayCounterLabel = YES;
    browser.usePopAnimation = YES;
    browser.scaleImage = sender.imageView.image;
    
    // Show
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - Unwinding Segue
- (IBAction)unwindToHome:(UIStoryboardSegue*)sender
{
}
#pragma mark - Notifications
-(void) settingsUpdated:(NSNotification*)notification{
    _strSearch = nil;
    self.title = nil;
    _searchBar.text = nil;
    self.arrayImages = [NSMutableArray new];
    [self.collectionView reloadData];
    _pageNumber = 0;
    [self loadMoreData];
}
-(void) settingsLayoutUpdated:(NSNotification*)notification{
    if ([_currentLayout isEqualToString:[SettingsModel sharedInstance].layout]==NO) {
        [self setColumnCount];
        _currentLayout = [SettingsModel sharedInstance].layout;
        [self.collectionView reloadData];
    }
}
- (void)setColumnCount{
    
    if ([[SettingsModel sharedInstance].layout isEqualToString:kImgurLayoutList]) {
        ((CHTCollectionViewWaterfallLayout*)self.collectionViewLayout).columnCount = 1;
    }else{
        ((CHTCollectionViewWaterfallLayout*)self.collectionViewLayout).columnCount = [UIScreen mainScreen].bounds.size.width/160;
    }
}
#pragma mark Search

- (IBAction)actionSearch:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        ((UIView*)[_barBtnSearch valueForKey:@"view"]).alpha = 0.0f;
        ((UIView*)[_barBtnAbout valueForKey:@"view"]).alpha = 0.0;
        ((UIView*)[_barBtnSettings valueForKey:@"view"]).alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        // remove the search button
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftBarButtonItem = nil;
        // add the search bar (which will start out hidden).
        self.navigationItem.titleView = _searchBar;
        _searchBar.alpha = 0.0;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             _searchBar.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [_searchBar becomeFirstResponder];
                         }];
        
    }];
}
#pragma mark UISearchBarDelegate methods
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [UIView animateWithDuration:0.5f animations:^{
        _searchBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.navigationItem.titleView = nil;
        self.navigationItem.rightBarButtonItems = @[_barBtnAbout, _barBtnSearch];
        self.navigationItem.leftBarButtonItem = _barBtnSettings;
        ((UIView*)[_barBtnSearch valueForKey:@"view"]).alpha = 0.0f;
        ((UIView*)[_barBtnAbout valueForKey:@"view"]).alpha = 0.0;
        ((UIView*)[_barBtnSettings valueForKey:@"view"]).alpha = 0.0;  // set this *after* adding it back
        [UIView animateWithDuration:0.5f animations:^ {
            ((UIView*)[_barBtnSearch valueForKey:@"view"]).alpha = 1.0f;
            ((UIView*)[_barBtnAbout valueForKey:@"view"]).alpha = 1.0;
            ((UIView*)[_barBtnSettings valueForKey:@"view"]).alpha = 1.0;
        }];
    }];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search");
    
    [self searchBarCancelButtonClicked:_searchBar];
    if (searchBar.text.length>0 && [self.strSearch isEqualToString:_searchBar.text]==NO) {
        self.strSearch = searchBar.text;
        self.title = self.strSearch;
        self.arrayImages = [NSMutableArray new];
        [self.collectionView reloadData];
        _pageNumber = 0;
        [self loadMoreData];
    }
}
#pragma mark - Load Data

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
    
    NSString *path = [NSString stringWithFormat:@"%@/gallery",IMGAPIVersion];
    if (_strSearch) {
        path = [path stringByAppendingPathComponent:@"search"];
    }
    
    if(!_strSearch){
        path = [path stringByAppendingPathComponent:[SettingsModel sharedInstance].section];
    }
    
    path = [path stringByAppendingPathComponent:[SettingsModel sharedInstance].sort];
    path = [path stringByAppendingPathComponent:[SettingsModel sharedInstance].window];
    
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld?page=%ld", (long)_pageNumber,_pageNumber]];
    
    if(!_strSearch && [[SettingsModel sharedInstance].section isEqualToString:kImgurSectionUser]){
        path = [path stringByAppendingString:[NSString stringWithFormat:@"&showViral=%@",[SettingsModel sharedInstance].showViral.boolValue ? @"true" : @"false"]];
    }
    if (_strSearch) {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"&q=%@",_strSearch]];
    }
    if (self.arrayImages.count==0) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = NSLocalizedString(@"Loading ...", nil);
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.color = [UIColor whiteColor];
        _hud.labelColor = [UIColor blackColor];
        _hud.detailsLabelColor = [UIColor blackColor];
    }
    [[IMGSession sharedInstance] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * jsonArray = responseObject;
        NSMutableArray * images = [NSMutableArray new];
        
        for(NSDictionary * json in jsonArray){
            
            if([json[@"is_album"] boolValue]){
                NSError *JSONError = nil;
                IMGGalleryAlbum * album = [[IMGGalleryAlbum alloc] initWithJSONObject:json error:&JSONError];
                if(!JSONError && album)
                    [images addObject:album];
            } else {
                
                NSError *JSONError = nil;
                IMGGalleryImage * image = [[IMGGalleryImage alloc] initWithJSONObject:json error:&JSONError];
                if(!JSONError && image)
                    [images addObject:image];
            }
        }
        [self.arrayImages addObjectsFromArray:[PicBoxImage photosWithIMGObjects:(NSArray<IMGObjectProtocol> *)images]];
        _isRequestInProgress = NO;
        _pageNumber++;
        [self.collectionView.bottomRefreshControl endRefreshing];
        [self.collectionView reloadData];
        if (self.arrayImages.count>0) {
            [_hud hide:YES];
        }else{
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = nil;
            _hud.detailsLabelText = NSLocalizedString(@"No data available.", nil);
            [_hud hide:YES afterDelay:3.0];
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.bottomRefreshControl endRefreshing];
        _isRequestInProgress = NO;
        
        NSLog(@"gallery request failed - %@" ,error.localizedDescription);
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = nil;
        _hud.detailsLabelText = NSLocalizedString(@"An error occurred, please try again later", nil);
        [_hud hide:YES afterDelay:3.0];
    }];
}
-(void)loadDataForAlbum:(IMGAlbum*)album{
    if (_isRequestInProgress) {
        return;
    }
    _isRequestInProgress =YES;
    
    if (self.arrayImages.count==0) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = NSLocalizedString(@"Loading ...", nil);
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.color = [UIColor whiteColor];
        _hud.labelColor = [UIColor blackColor];
    }
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
        
        if (self.arrayImages.count>0) {
            [_hud hide:YES];
        }else{
            _hud.mode = MBProgressHUDModeText;
            _hud.labelText = nil;
            _hud.detailsLabelText = NSLocalizedString(@"No data available.", nil);
            [_hud hide:YES afterDelay:3.0];
        }
        
    } failure:^(NSError *error) {
        [self.collectionView.bottomRefreshControl endRefreshing];
        _isRequestInProgress = NO;
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = nil;
        _hud.detailsLabelText = NSLocalizedString(@"An error occurred, please try again later", nil);
        [_hud hide:YES afterDelay:3.0];
    }];
}
@end
