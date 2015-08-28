//
//  AppDelegate.m
//  haitao
//
//  Created by pwy on 15-7-13.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
 
#import "AppDelegate.h"
#import "FCTabBarController.h"
#import "DejalActivityView.h"
#import "LoginViewController.h"
#import "MenuModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UMSocial.h"
#import "UMSocialControllerService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMessage.h"
#import "MCCore.h"
@interface AppDelegate ()

@end
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    //美洽客服
    [MCCore initWithAppkey:@"55debfd94eae351a2b000010" expcetionDelegate:nil];
    //为美洽注册推送
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    //    [self isConnectionAvailable];
    self.menuArr=[[NSMutableArray alloc]init];
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //AppID：wxf1e19b28e6b1613c
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wx5996980f24fd25bd" appSecret:@"3f55485b6f1077e552820ea2e40dcf83" url:@"http://sns.whalecloud.com/sina2/callback"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

    if (![[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
        [self showIntroWithCrossDissolve];
    }else{
        [self doInit];
    }
    
    //一定要设置为全局变量 否则不可用
    _reach = [Reachability reachabilityWithHostName:@"www.apple.com"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    [_reach startNotifier];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(doHeart) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停
    
//    [self isConnectionAvailable:_reach];
    //推送
    [UMessage startWithAppkey:@"55d9670e67e58e5f5e0074ea" launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:YES];
   
    return YES;
    
}
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self isConnectionAvailable:curReach];
}
-(BOOL) isConnectionAvailable:(Reachability *)reach {
    
    BOOL isExistenceNetwork = YES;
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        ShowMessage(@"您的网络状况好像不太好！");
        return NO;
    }
    
    return isExistenceNetwork;
}

-(void)doHeart{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_doHeart withType:GETURL withUrlName:@"doheart"];
    httpController.delegate = self;
    [httpController onSearch];

}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
-(void)getMenuData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    //    http://www.peikua.com/app.php?app.php?m=home&a=app&f=getHomeData
    NSString* url =[NSString stringWithFormat:@"%@&m=home&f=getHomeNav",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getHomeNav"];
    httpController.delegate = self;
    [httpController onSearch];
}

//获取数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
   
    if([urlname isEqualToString:@"getHomeNav"]){
        NSArray *arrtemp=[dictemp objectForKey:@"data"];
        if ((NSNull *)arrtemp == [NSNull null]) {
            showMessage(@"暂无数据!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
        for (NSDictionary *employeeDic in arrtemp) {
            MenuModel *menuModel= [MenuModel objectWithKeyValues:employeeDic] ;
            NSArray *arr=menuModel.child;
            NSMutableArray *childList=[[NSMutableArray alloc]init];
            for (NSDictionary *childDic in arr) {
                MenuModel *menuTepm= [MenuModel objectWithKeyValues:childDic] ;
                [childList addObject:menuTepm];
            }
            menuModel.child = childList;
            [self.menuArr addObject:menuModel];
            
        }
        FCTabBarController *rootViewController= [[FCTabBarController alloc] init];
        
//        rootViewController.menuArray=menuArr;
        self.navigationController=[[LTKNavigationViewController alloc]initWithRootViewController:rootViewController];
        self.window.rootViewController=self.navigationController;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }else{
        NSLog(@"----pass-doheart%@---",urlname);
    }
    
    
}
#pragma mark--引导页
- (void)showIntroWithCrossDissolve {
//    EAIntroPage *page1 = [EAIntroPage page];
    //    page1.title = @"Hello world";
    //    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
//    page1.bgImage = [UIImage imageNamed:@"1.jpg"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    if (isRetina) {
        page2.bgImage = [UIImage imageNamed:@"2_retina.jpg"];
    }else{
        page2.bgImage = [UIImage imageNamed:@"2.jpg"];
    }
    
    
    EAIntroPage *page3 = [EAIntroPage page];
    
    if (isRetina) {
        page3.bgImage = [UIImage imageNamed:@"3_retina.jpg"];
    }else{
        page3.bgImage = [UIImage imageNamed:@"3.jpg"];
    }
    
    EAIntroPage *page4 = [EAIntroPage page];
    
    if (isRetina) {
        page4.bgImage = [UIImage imageNamed:@"4_retina.jpg"];
    }else{
        page4.bgImage = [UIImage imageNamed:@"4.jpg"];
    }
    
//    page4.titleImage = [UIImage imageNamed:@"skip-btn"];
//    
//    page4.imgPositionY = SCREEN_HEIGHT-100;

    page4.customView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 30)];
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.window.bounds andPages:@[page2,page3,page4]];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-55, 0, 110, 28)];
    [button setBackgroundImage:[UIImage imageNamed:@"skip-btn"] forState:UIControlStateNormal];
    [button addTarget:intro action:@selector(skipIntroduction) forControlEvents:UIControlEventTouchUpInside];
    [page4.customView addSubview:button];
    [page4.customView bringSubviewToFront:button];//显示到最前面
    
    
    
    
    intro.skipButton = [[UIButton alloc] initWithFrame:CGRectZero];
    
    [intro setDelegate:self];
    [intro showInView:self.window animateDuration:1.0];
}
- (void)introDidFinish{
    NSLog(@"----pass-introDidFinish%@---",@"introDidFinish");
    [USER_DEFAULT setObject:@"NO" forKey:@"firstUseApp"];

    [self doInit];
    
}
-(void)doInit{
    [self getMenuData];
}
- (void)startLoading
{
        [DejalBezelActivityView activityViewForView:self.window];
}

- (void)stopLoading
{
        [DejalBezelActivityView removeViewAnimated:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //退出到后台时，告诉美洽SDK开启推送
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    [MCCore letUserOffOnlineIsSynchronizationWithDeviceToken:[userData objectForKey:@"deviceToken"]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[USER_DEFAULT objectForKey:@"firstUseApp"] isEqualToString:@"NO"]) {
        NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        NSString *username=[userdefault objectForKey:@"user_name"];
        NSString *password=[userdefault objectForKey:@"user_pass"];
        
        if (![MyUtil isEmptyString:username]&&![MyUtil isEmptyString:password]) {
            LoginViewController *login=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [login login:nil];
        }
    }
    [_timer setFireDate:[NSDate distantPast]];//开启

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    /*
     NSString *string =[url absoluteString];
     if ([string hasPrefix:@"wb"])
     {
     return [WeiboSDK handleOpenURL:url delegate:self];
     }
     else if ([string hasPrefix:@"wx"])
     {
     return [WXApi handleOpenURL:url delegate:self];
     }weixin
     return YES;
     */
    NSString *string =[url absoluteString];
    if([string hasPrefix:@"wx"]){
        return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
    }
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return YES;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.quekua.haitao" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"haitao" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"haitao.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
    //美洽token
    NSString* _deviceToken = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
    //保存deviceToken
    [userData setObject:_deviceToken forKey:@"deviceToken"];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    //    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //        
    //    }
}
@end
