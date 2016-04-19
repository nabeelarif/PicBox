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
    
    [[UIApplication sharedApplication] openURL:url];
}

-(void)imgurSessionRateLimitExceeded{
    
    
}
@end
