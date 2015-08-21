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
#import "SpecialViewController.h"
#import "CustomViewController.h"
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
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 49+20);
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
//        [view_bar addSubview:imageV];
        
        
    }else{
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 49);
//        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
//        [view_bar addSubview:imageV];
        
    }
    view_bar.backgroundColor=RGB(255, 13, 94);
    /*
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:BundleImage(@"ic_01_h.png") selectedImage:BundleImage(@"ic_01_h.png")];
    
    item1.tag=1;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *menuArrNew=app.menuArr;
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:12];
    int j=1;
    [barArr addObject:item1];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        MenuModel *me=menuArrNew[i];
        UITabBarItem *itemTemp = [[UITabBarItem alloc] initWithTitle:me.name image:BundleImage(@"ic_01_h.png") selectedImage:BundleImage(@"ic_01_h.png")];
        j++;
        itemTemp.tag=j;
        [barArr addObject:itemTemp];
    }
    j++;
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"专题" image:BundleImage(@"ic_01_h.png") selectedImage:BundleImage(@"ic_01_h.png")];
    
    item2.tag=j;
    [barArr addObject:item2];
    tabBar = [[ZRScrollableTabBar alloc] initWithItems:barArr withFrame:view_bar.frame];
    tabBar.scrollableTabBarDelegate = self;
    [view_bar addSubview:tabBar];
     */
    CGRect rect;
    
    rect = [[UIApplication sharedApplication] statusBarFrame];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *menuArrNew=app.menuArr;
    NSMutableArray *barArr=[[NSMutableArray alloc]initWithCapacity:12];
    NSMutableDictionary *itme1 =[[NSMutableDictionary alloc]init] ;
    [itme1 setObject: @"NavigationBar_icon_home" forKey:NOMALKEY];
    [itme1 setObject: @"NavigationBar_icon_home" forKey:HEIGHTKEY];
    [itme1 setObject: @"首页" forKey:TITLEKEY];
    [itme1 setObject:[NSNumber numberWithFloat:view_bar.width/5]  forKey:TITLEWIDTH];
    [barArr addObject:itme1];
    for (int i=0; i<=menuArrNew.count-1; i++) {
        MenuModel *me=menuArrNew[i];
        NSMutableDictionary *itemTemp =[[NSMutableDictionary alloc]init] ;
        [itemTemp setObject:me.img forKey:NOMALKEY];
        [itemTemp setObject: @"NavBar_icon_XiangBao" forKey:HEIGHTKEY];
        [itemTemp setObject: me.name forKey:TITLEKEY];
        [itemTemp setObject:[NSNumber numberWithFloat:view_bar.width/5]  forKey:TITLEWIDTH];

        [barArr addObject:itemTemp];
    }
    NSMutableDictionary *itme2 =[[NSMutableDictionary alloc]init] ;
    [itme2 setObject: @"NavBar_icon_ZhuangTi" forKey:NOMALKEY];
    [itme2 setObject: @"NavBar_icon_ZhuangTi" forKey:HEIGHTKEY];
    [itme2 setObject: @"专题" forKey:TITLEKEY];
    [itme2 setObject:[NSNumber numberWithFloat:view_bar.width/5]  forKey:TITLEWIDTH];
    [barArr addObject:itme2];

    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, rect.size.height, view_bar.width, view_bar.height-rect.size.height) ButtonItems:barArr];
        mMenuHriZontal.delegate = self;
    }
    [view_bar addSubview:mMenuHriZontal];
    [self.view addSubview: view_bar];
    
    return view_bar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeBottom];
    [self drawViewRect];
    HomeViewController *homeViewController=[[HomeViewController alloc]init];
    homeViewController.mainFrame=mainFrame;
    SpecialViewController *specialViewController=[[SpecialViewController alloc]init];
    specialViewController.mainFrame=mainFrame;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:12];
    NSMutableArray *views =[NSMutableArray arrayWithCapacity:12];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSArray *menuArrNew=app.menuArr;
    [views addObject:homeViewController];
   
    for (int i=0; i<=menuArrNew.count-1; i++) {
        MenuModel *menuModel=menuArrNew[i];
        CustomViewController *custome=[[CustomViewController alloc]init];
        custome.menuModel=menuModel;
        custome.mainFrame=mainFrame;
        [views addObject:custome];
    }
    [views addObject:specialViewController];
    for (UIViewController *viewController in views) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewControllers addObject:nav];
    }
    
    self.viewControllers = views;
    
    //    [self getNavigationBar];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeTabType)name:@"ChangeTabType"object:nil];
    
    // Do any additional setup after loading the view.
}
-(void)drawViewRect
{
    UIView *naviView=(UIView*) [self getNavigationBar];
    mainFrame=CGRectMake(0, naviView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-naviView.frame.size.height-49);
}
-(void)ChangeTabType{
    [self.tabBar setHidden:YES];
    [tabBar setHidden:YES];
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
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"getHomeNav"]){
        NSArray *arrtemp=[dictemp objectForKey:@"data"];
        if ((NSNull *)arrtemp == [NSNull null]) {
            showMessage(@"暂无商品!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
//        for (NSDictionary *employeeDic in arrtemp) {
//            MenuModel *menuModel= [MenuModel objectWithKeyValues:employeeDic] ;
//            NSArray *arr=menuModel.child;
//            NSMutableArray *childList=[[NSMutableArray alloc]init];
//            for (NSDictionary *childDic in arr) {
//                MenuModel *menuTepm= [MenuModel objectWithKeyValues:childDic] ;
//                [childList addObject:menuTepm];
//            }
//            menuModel.child = childList;
//            [menuArr addObject:menuModel];
//        }
//        [self initTable];
//        NSLog(@"");
        //保存数据
        
    }
    
    
}

- (void)scrollableTabBar:(ZRScrollableTabBar *)tabBar didSelectItemWithTag:(int)tag
{
    int j=self.selectedIndex ;
    self.selectedIndex = tag-1;
}
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    self.selectedIndex = aIndex;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCus" object:nil];
    
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
