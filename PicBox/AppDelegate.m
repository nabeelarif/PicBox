//
//  AppDelegate.m
//  PicBox
//
//  Created by Nabeel Arif on 4/14/16.
//  Copyright © 2016 Nabeel Arif. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "AppTheme.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMGSession anonymousSessionWithClientID:kImgurClientId withDelegate:self];
    [AppTheme applyTheme];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //app must register url scheme which starts the app at this endpoint with the url containing the code
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [[url query] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
    
    NSString * pinCode = params[@"code"];
    
    if(!pinCode){
        NSLog(@"error: %@", params[@"error"]);
        
        self.continueHandler = nil;
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error Title") message:NSLocalizedString(@"Access was denied by Imgur", @"Error desc on Imgur deep linking url.") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        [alert addAction:actionOk];
        [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
        
        return NO;
    }
    
    [[IMGSession sharedInstance] authenticateWithCode:pinCode];
    
    if(_continueHandler)
        self.continueHandler();
    
    
    return YES;
}

-(void)imgurSessionNeedsExternalWebview:(NSURL *)url completion:(void (^)())completion{
    
    self.continueHandler = [completion copy];
    
    //go to safari to login, configure your imgur app to redirect to this app using URL scheme.
    [[UIApplication sharedApplication] openURL:url];
    
}

-(void)imgurSessionRateLimitExceeded{
    
    
}
@end
