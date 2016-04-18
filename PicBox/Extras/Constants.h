//
//  Constants.h
//  PicBox
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNotificationSettingsUpdated;
extern NSString *const kNotificationSettingsLayoutUpdated;
extern NSString *const kImgurClientId;
extern NSString *const kImgurClientSecret;
extern NSString *const kImgurSectionHot;
extern NSString *const kImgurSectionTop;
extern NSString *const kImgurSectionUser;
extern NSString *const kImgurSortViral;
extern NSString *const kImgurSortTop;
extern NSString *const kImgurSortTime;
extern NSString *const kImgurSortRising;
extern NSString *const kImgurLayoutList;
extern NSString *const kImgurLayoutGrid;
extern NSString *const kImgurLayoutStaggeredGrid;
extern NSString *const kImgurWindowDay;
extern NSString *const kImgurWindowWeek;
extern NSString *const kImgurWindowMonth;
extern NSString *const kImgurWindowYear;
extern NSString *const kImgurWindowAll;


#define PADDING                 10
#define PAGE_INDEX_TAG_OFFSET   1000
#define PAGE_INDEX(page)        ([(page) tag] - PAGE_INDEX_TAG_OFFSET)

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define PicBoxLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define PicBoxLog(x, ...)
#endif
//
// System Versioning Preprocessor Macros
//

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
