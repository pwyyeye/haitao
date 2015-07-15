//
//  ManitViewController.m
//  haitao
//
//  Created by SEM on 15/7/15.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#import "ZRScrollableTabBar.h"
#import "ManitViewController.h"
#import "TestViewController.h"
@interface ManitViewController ()

@end

@implementation ManitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestViewController *testViewController=[[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    NSArray *views = @[testViewController];
    for (UIViewController *viewController in views) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
    }
    
    self.viewControllers = viewControllers;
    [self initScrollableTabbar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeTabType)name:@"ChangeTabType"object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)ChangeTabType{
    [self.tabBar setHidden:YES];
    [tabBar setHidden:YES];
}
-(void)initScrollableTabbar
{
    // Tab bar
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:4];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:5];
    UITabBarItem *item6 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:6];
    UITabBarItem *item7 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:7];
    UITabBarItem *item8 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:8];
    UITabBarItem *item9 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:9];
    
    tabBar = [[ZRScrollableTabBar alloc] initWithItems:[NSArray arrayWithObjects: item1, item2, item3, item4, item5, item6, item7, item8, item9, nil]];
    tabBar.scrollableTabBarDelegate = self;
    
    [self.view addSubview:tabBar];
}

- (void)scrollableTabBar:(ZRScrollableTabBar *)tabBar didSelectItemWithTag:(int)tag
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
