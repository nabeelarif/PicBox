//
//  SettingsTableViewController.m
//  PicBox
//
//  Created by Nabeel Arif on 4/16/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Constants.h"
#import "SettingsModel.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrSection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrSort;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrLayout;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCtrWindow;
@property (weak, nonatomic) IBOutlet UISwitch *switchShowViral;

- (IBAction)actionSection:(UISegmentedControl *)sender;
- (IBAction)actionSort:(UISegmentedControl *)sender;
- (IBAction)actionLayout:(UISegmentedControl *)sender;
- (IBAction)actionWindow:(UISegmentedControl *)sender;
- (IBAction)actionStateChangedSwitch:(UISwitch *)sender;
- (IBAction)actionDone:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _segCtrSection.selectedSegmentIndex = [self indexForSectionName:[SettingsModel sharedInstance].section];
    _segCtrSort.selectedSegmentIndex = [self indexForSortName:[SettingsModel sharedInstance].sort];
    _segCtrLayout.selectedSegmentIndex = [self indexForLayoutName:[SettingsModel sharedInstance].layout];
    _segCtrWindow.selectedSegmentIndex = [self indexForWindowName:[SettingsModel sharedInstance].window];
    _switchShowViral.on = [SettingsModel sharedInstance].showViral.boolValue;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions
- (IBAction)actionSection:(UISegmentedControl *)sender {
}

- (IBAction)actionSort:(id)sender {
}

- (IBAction)actionLayout:(UISegmentedControl *)sender {
}

- (IBAction)actionWindow:(UISegmentedControl *)sender {
}

- (IBAction)actionStateChangedSwitch:(UISwitch *)sender {
}

- (IBAction)actionDone:(id)sender {
    [SettingsModel sharedInstance].section = [self sectionNameForIndex:_segCtrSection.selectedSegmentIndex];
    [SettingsModel sharedInstance].sort = [self sortNameForIndex:_segCtrSort.selectedSegmentIndex];
    [SettingsModel sharedInstance].layout = [self layoutNameForIndex:_segCtrLayout.selectedSegmentIndex];
    [SettingsModel sharedInstance].window = [self windowNameForIndex:_segCtrWindow.selectedSegmentIndex];
    [SettingsModel sharedInstance].showViral = @(_switchShowViral.on);
    [[SettingsModel sharedInstance] saveCurrentState];
    [self performSegueWithIdentifier:@"unwindToHome" sender:self];
}

- (IBAction)actionCancel:(id)sender {
    [self performSegueWithIdentifier:@"unwindToHome" sender:self];
}
#pragma mark - Names from index
-(NSString*)sectionNameForIndex:(NSInteger)index{
    NSString *newValue;
    switch (index) {
        case 0:
            newValue = kImgurSectionHot;
            break;
            
        case 1:
            newValue = kImgurSectionTop;
            break;
            
        case 2:
            newValue = kImgurSectionUser;
            break;
            
        default:
            break;
    }
    return newValue;
    
}
-(NSString*)sortNameForIndex:(NSInteger)index{
    NSString *newValue;
    switch (index) {
        case 0:
            newValue = kImgurSortViral;
            break;
            
        case 1:
            newValue = kImgurSortTop;
            break;
            
        case 2:
            newValue = kImgurSortTime;
            break;
            
        case 3:
            newValue = kImgurSortRising;
            break;
            
        default:
            break;
    }
    return newValue;
    
}
-(NSString*)layoutNameForIndex:(NSInteger)index{
    NSString *newValue;
    switch (index) {
        case 0:
            newValue = kImgurLayoutList;
            break;
            
        case 1:
            newValue = kImgurLayoutGrid;
            break;
            
        case 2:
            newValue = kImgurLayoutStaggeredGrid;
            break;
            
        default:
            break;
    }
    return newValue;
    
}
-(NSString*)windowNameForIndex:(NSInteger)index{
    NSString *newValue;
    switch (index) {
        case 0:
            newValue = kImgurWindowDay;
            break;
            
        case 1:
            newValue = kImgurWindowWeek;
            break;
            
        case 2:
            newValue = kImgurWindowMonth;
            break;
            
        case 3:
            newValue = kImgurWindowYear;
            break;
            
        case 4:
            newValue = kImgurWindowAll;
            break;
            
        default:
            break;
    }
    return newValue;
    
}
#pragma mark - Index from Name

-(NSInteger)indexForSectionName:(NSString*)name{
    NSInteger index;
    if ([name isEqualToString:kImgurSectionHot]) {
        index = 0;
    } else if ([name isEqualToString:kImgurSectionTop]) {
        index = 1;
    } else if ([name isEqualToString:kImgurSectionUser]) {
        index = 2;
    }
    return index;
    
}
-(NSInteger)indexForSortName:(NSString*)name{
    NSInteger index;
    if ([name isEqualToString:kImgurSortViral]) {
        index = 0;
    } else if ([name isEqualToString:kImgurSortTop]) {
        index = 1;
    } else if ([name isEqualToString:kImgurSortTime]) {
        index = 2;
    } else if ([name isEqualToString:kImgurSortRising]) {
        index = 3;
    }
    return index;
    
}
-(NSInteger)indexForLayoutName:(NSString*)name{
    NSInteger index;
    if ([name isEqualToString:kImgurLayoutList]) {
        index = 0;
    } else if ([name isEqualToString:kImgurLayoutGrid]) {
        index = 1;
    } else if ([name isEqualToString:kImgurLayoutStaggeredGrid]) {
        index = 2;
    }
    return index;
    
}
-(NSInteger)indexForWindowName:(NSString*)name{
    NSInteger index;
    if ([name isEqualToString:kImgurWindowDay]) {
        index = 0;
    } else if ([name isEqualToString:kImgurWindowWeek]) {
        index = 1;
    } else if ([name isEqualToString:kImgurWindowMonth]) {
        index = 2;
    } else if ([name isEqualToString:kImgurWindowYear]) {
        index = 3;
    } else if ([name isEqualToString:kImgurWindowAll]) {
        index = 4;
    }
    return index;
}
@end
