//
//  AppDelegate.h
//  haitao
//
//  Created by pwy on 15-7-13.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "LTKNavigationViewController.h"
#import "EAIntroView.h"
#import "Reachability.h"
#define UmengAppkey @"55d9670e67e58e5f5e0074ea"
//55cc18e567e58eb91f000701
@interface AppDelegate : UIResponder <UIApplicationDelegate,HTTPControllerProtocol,EAIntroDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong,nonatomic)TMNavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) NSMutableArray *menuArr;
@property(strong,nonatomic) NSString *s_app_id;
@property(strong,nonatomic) Reachability *reach;
@property (strong, nonatomic) NSDictionary *userInfo;
@property(strong,nonatomic) NSTimer *timer;
- (void)startLoading;
- (void)stopLoading;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@property (strong,nonatomic)LTKNavigationViewController *navigationController;

@end

