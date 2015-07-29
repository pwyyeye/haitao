//
//  FCTabBarController.m
//  
//
//  Created by  on 13-4-17.
//  Copyright (c) 2013年 chen wei. All rights reserved.
//

#import "FCTabBarController.h"
#import "LTKNavigationViewController.h"
#import "ManitViewController.h"
#import "HTSeachViewController.h"
#import "HTBoutiqueViewController.h"
#import "HTCartViewController.h"
#import "UserCenterCollention.h"
//#import "TMClassicViewController.h"
//#import "TMShopStoreViewController.h"
//#import "TMBuildShopStoreViewController.h"
//#import "TMMySotreViewController.h"
//#import "LTKSeachViewController.h"

@implementation FCTabBarController

//-(void)reachabilityChanged:(NSNotification*)note
//{
//    Reachability* curReach=[note object];
//    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
//    NetworkStatus status=[curReach currentReachabilityStatus];
//    if (status==NotReachable) {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        [alert release];
//    }
//    
//}

-(void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
         self.navigationController.navigationBarHidden=YES;
   
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    self.delegate=self;
    self.tabBarController.delegate=self;
 

    //首页
   ManitViewController  *manitViewController= [[ManitViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"gre icon_01.png"]tag:-300];
    manitViewController.tabBarItem =item1;
    //搜索页
    HTSeachViewController *seachViewController= [[HTSeachViewController alloc] init];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"gre icon_04.png"]tag:-301];
    seachViewController.tabBarItem=item2;
    //精品推荐
    
    HTBoutiqueViewController *boutiqueViewController= [[HTBoutiqueViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"gre icon_02.png"]tag:-302];
    boutiqueViewController.tabBarItem=item3;
    //购物车
    HTCartViewController *cartViewController= [[HTCartViewController alloc] init];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"gre icon_02.png"]tag:-303];
    cartViewController.tabBarItem=item4;
    //个人中心
    UserCenterCollention  *userCenter= [[UserCenterCollention alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"gre icon_05.png"]tag:-304];
    userCenter.tabBarItem=item5;
    //
    LTKNavigationViewController*navigationController1= [[LTKNavigationViewController alloc] initWithRootViewController:manitViewController] ;
    LTKNavigationViewController*navigationController2= [[LTKNavigationViewController alloc] initWithRootViewController:seachViewController] ;
    LTKNavigationViewController*navigationController3= [[LTKNavigationViewController alloc] initWithRootViewController:boutiqueViewController] ;
    LTKNavigationViewController*navigationController4= [[LTKNavigationViewController alloc] initWithRootViewController:cartViewController] ;
    LTKNavigationViewController*navigationController5= [[LTKNavigationViewController alloc] initWithRootViewController:userCenter] ;

    NSArray *viewArray = [NSArray arrayWithObjects:navigationController1,navigationController2,navigationController3,navigationController4,navigationController5,nil];

    self.viewControllers = viewArray;

}



-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//
    [viewController viewWillAppear:animated];

}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewControlle{
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([MyUtil isEmptyString:app.s_app_id]) {
        [tabBarController setSelectedIndex:0];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"----pass-didSelectItem%@---",item);
}
-(void)btnPress:(id)sender
{


}

@end
