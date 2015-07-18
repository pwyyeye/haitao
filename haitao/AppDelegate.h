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
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong,nonatomic)TMNavigationController *navigationController;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)startLoading;
- (void)stopLoading;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@property (strong,nonatomic)LTKNavigationViewController *navigationController;

@end

