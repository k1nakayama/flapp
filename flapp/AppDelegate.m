//
//  AppDelegate.m
//  flapp
//
//  Created by 中山桂一 on 2014/03/18.
//  Copyright (c) 2014年 Pocket Solution Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "BannerListViewController.h"
#import "PointExchangeViewController.h"
#import "MenuViewController.h"
#import "AppApiUtil.h"

void uncaughtExceptionHandler (NSException *exception){
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@",[exception callStackSymbols]);
    
}
@implementation AppDelegate
@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    
    //ViewControllerを格納する配列を作る
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    //それぞれのViewControllerの初期化
    BannerListViewController *bannerListViewController = [[BannerListViewController alloc] initWithNibName:@"BannerListViewController" bundle:nil];
    PointExchangeViewController *pointExchangeViewController = [[PointExchangeViewController alloc] initWithNibName:@"PointExchangeViewController" bundle:nil];
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
 
    //それぞれNavigationContorllerにセット
    UINavigationController *bannerListNavi = [[UINavigationController alloc] initWithRootViewController:bannerListViewController];
    [bannerListNavi setTitle:@"BannerList"];
    [viewControllers addObject:bannerListNavi];
    
    UINavigationController *pointExchangeNavi = [[UINavigationController alloc] initWithRootViewController:pointExchangeViewController];
    [pointExchangeNavi setNavigationBarHidden:YES];
    [pointExchangeNavi setTitle:@"PointExchange"];
    [viewControllers addObject:pointExchangeNavi];

    UINavigationController *menuNavi = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    [menuNavi setTitle:@"Menu"];
    [viewControllers addObject:menuNavi];

    //最後にTabBarをセット
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    //self.tabBarController.tabBar.barTintColor = [UIColor orangeColor];
    self.tabBarController.tabBar.barTintColor= [UIColor colorWithRed:1.0 green:0.398 blue:0 alpha:1.0];
    
    [self.tabBarController setViewControllers:viewControllers];
    
    self.window.rootViewController = self.tabBarController;
    
    //UUID取得
    AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
    NSString *user_id = [apiUtil getUserId];
    NSLog(@"user_id: %@",user_id);
    NSDictionary *user_info = [apiUtil getUserInfo];
    NSLog(@"user_info: %@",user_info);
    
    //Push Notificationの許可
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"device Token: %@",deviceToken);
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableData *postToken = [NSMutableData data];
    [postToken appendData:[token dataUsingEncoding:NSUTF8StringEncoding]];
    [self sendProviderDeviceToken:postToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error inregistration Error: %@",error);
}
-(void)sendProviderDeviceToken:(NSData *)token{
    //UserDefaultにTokenがあるか調べる
    NSString *tokenkey = TOKEN_KEY;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *ud_token = [ud stringForKey:tokenkey];
    if(!ud_token){
        AppApiUtil *apiUtil = [[AppApiUtil alloc] init];
        NSDictionary *result= [apiUtil registNotification:token];
        NSLog(@"regist notification result: %@",result);
    }
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
