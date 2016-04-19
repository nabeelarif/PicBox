//
//  PicBoxTests.m
//  PicBoxTests
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Utility.h"
#import "SettingsModel.h"
#import "Constants.h"

@interface PicBoxTests : XCTestCase

@end

@implementation PicBoxTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUtilityAppVersion {
    NSString *value = [Utility appVersion];
    XCTAssertNotNil(value);
}
- (void)testUtilityBuildNumber {
    NSString *value = [Utility appBuildNumber];
    XCTAssertNotNil(value);
}
- (void)testUtilityVersionBuild {
    NSString *value = [Utility versionBuild];
    XCTAssertNotNil(value);
}
- (void)testUtilityBuildDate {
    NSString *value = [Utility buildDate];
    XCTAssertNotNil(value);
}
- (void)testUtilityStringToLocalTime {
    NSString *value = [Utility stringLocalTimeFromDate:[NSDate date]];
    XCTAssertNotNil(value);
}
- (void)testSettingsModel {
    XCTAssertNotNil([SettingsModel sharedInstance]);
    // Clear data to go back to defaults
    NSLog(@"H - (%@) - %@",[SettingsModel sharedInstance].section,[SettingsModel sharedInstance].sort);
    XCTAssertNotNil([SettingsModel sharedInstance].section);
    XCTAssertNotNil([SettingsModel sharedInstance].sort);
    XCTAssertNotNil([SettingsModel sharedInstance].window);
    XCTAssertNotNil([SettingsModel sharedInstance].layout);
    XCTAssertNotNil([SettingsModel sharedInstance].showViral);
    
}
@end
