//
//  ManitViewController.m
//  haitao
//
//  Created by SEM on 15/7/15.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ManitViewController.h"
#import "HomeViewController.h"
#import "Toolkit.h"
#import "AFNetworking.h"

@interface ManitViewController ()

@end

@implementation ManitViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏导航栏
    //    [self.navigationItem setHidesBackButton:YES];
}
-(UIView *)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    UIView *view_bar =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
//        [view_bar addSubview:imageV];
        
        
    }else{
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
//        [view_bar addSubview:imageV];
        
    }
    view_bar.backgroundColor=[UIColor clearColor];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:BundleImage(@"ic_01_h.png") selectedImage:BundleImage(@"ic_01_h.png")];
    
    item1.tag=1;
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:4];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:5];
    UITabBarItem *item6 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:6];
    UITabBarItem *item7 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:7];
    UITabBarItem *item8 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:8];
    UITabBarItem *item9 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:9];
    
    tabBar = [[ZRScrollableTabBar alloc] initWithItems:[NSArray arrayWithObjects: item1, item2,item3,item4,item5,item6,item7,item8,item9,nil]withFrame:view_bar.frame];
    tabBar.scrollableTabBarDelegate = self;
    [view_bar addSubview:tabBar];
    [self.view addSubview: view_bar];
    return view_bar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawViewRect];
    HomeViewController *homeViewController=[[HomeViewController alloc]init];
    homeViewController.mainFrame=mainFrame;
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    NSArray *views = @[homeViewController];
    for (UIViewController *viewController in views) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
    }
    
    self.viewControllers = viewControllers;
    
    //    [self getNavigationBar];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeTabType)name:@"ChangeTabType"object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)drawViewRect
{
    UIView *naviView=(UIView*) [self getNavigationBar];
    mainFrame=CGRectMake(0, naviView.frame.size.height-20, self.view.frame.size.width, self.view.frame.size.height-naviView.frame.size.height-49);
}
-(void)ChangeTabType{
    [self.tabBar setHidden:YES];
    [tabBar setHidden:YES];
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
