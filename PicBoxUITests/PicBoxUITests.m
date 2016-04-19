//
//  PicBoxUITests.m
//  PicBoxUITests
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SettingsModel.h"
#import "Constants.h"

@interface PicBoxUITests : XCTestCase

@end

@implementation PicBoxUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
//    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
//
//    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testUIElements
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *settingsIconButton = app.navigationBars.buttons[@"settings icon"];
    XCUIElement *aboutButton = app.navigationBars.buttons[@"about icon"];
    XCUIElement *searchButton = app.navigationBars.buttons[@"Search"];
    
    XCTAssert(settingsIconButton.exists, @"Settings button exist");
    XCTAssert(aboutButton.exists, @"About button Exists");
    XCTAssert(searchButton.exists, @"Search Button Exists");
    
}
-(void)testTapSearchOpensSearchBar{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *searchButton = app.navigationBars.buttons[@"Search"];
    XCTAssert(searchButton.exists, @"Search Button Exists");
    [searchButton tap];
    
    
    XCUIElement *searchGallerySearchField = app.navigationBars.searchFields[@"Search Gallery ..."];
    
    [self waitForElementToAppear:searchGallerySearchField withTimeout:3.0];
    
    XCTAssert(searchGallerySearchField.exists, @"Search Bar is Opened");
}
-(void)testSearchingChangesTitleOfNavigationBar{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *searcBarhButton = app.navigationBars.buttons[@"Search"];
    XCTAssert(searcBarhButton.exists, @"Search Button Exists");
    [searcBarhButton tap];
    
    XCUIElement *searchGallerySearchField = app.navigationBars.searchFields[@"Search Gallery ..."];
    
    [self waitForElementToAppear:searchGallerySearchField withTimeout:3.0];

    
    [searchGallerySearchField typeText:@"pakistan"];
    
    XCUIElement *searchButton = app.buttons[@"Search"];
    [searchButton tap];
    
    XCTAssertTrue(app.navigationBars[@"pakistan"].exists, @"Title is changed");
    
}
- (void)testSettingsUIOpened {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElement *settingsIconButton = app.navigationBars.buttons[@"settings icon"];
    [settingsIconButton tap];
    
    XCUIElement *settingsNavigationBar = app.navigationBars[@"Settings"];
    XCTAssert(settingsNavigationBar.exists, @"Settings controller is Launhed");
    
}
- (void)testAboutUIOpened {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *aboutButton = app.navigationBars.buttons[@"about icon"];
    [aboutButton tap];
    
    XCUIElement *settingsNavigationBar = app.navigationBars[@"About"];
    XCTAssert(settingsNavigationBar.exists, @"About controller is Launhed");
}
-(void)testSearchButton{
    
}

#pragma mark - wait method for an element to appear
- (void)waitForElementToAppear:(XCUIElement *)element withTimeout:(NSTimeInterval)timeout
{
    NSUInteger line = __LINE__;
    NSString *file = [NSString stringWithUTF8String:__FILE__];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == true"];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:element handler:nil];
    
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSString *message = [NSString stringWithFormat:@"Failed to find %@ after %f seconds",element,timeout];
            [self recordFailureWithDescription:message inFile:file atLine:line expected:YES];
        }
    }];
}
@end
