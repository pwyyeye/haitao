//
//  TariffViewController.m
//  haitao
//
//  Created by pwy on 15/8/1.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "TariffViewController.h"

@interface TariffViewController ()

@end

@implementation TariffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值
    
    //    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)]];
    //
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"关税缴纳";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    NSArray *segmentedArray = @[@"全部",@"已付关税",@"未付关税"];
    
    UISegmentedControl *seg=[[UISegmentedControl alloc] initWithItems:segmentedArray];
    
    seg.frame=CGRectMake(0, 0, (SCREEN_WIDTH/4)*4, 34);
    seg.selectedSegmentIndex = 0;//设置默认选择项索引
    
    //清除原有格式颜色
    seg.tintColor=[UIColor clearColor];
    //设置背景色
    [seg setBackgroundColor:RGB(237, 237, 237)];
    //设置字体样式
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                             NSForegroundColorAttributeName: RGB(255, 13, 94)};
    [seg setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13],
                                               NSForegroundColorAttributeName: [UIColor colorWithWhite:0.6 alpha:1]};
    [seg setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    
    // 使用颜色创建UIImage//未选中颜色
    CGSize imageSize = CGSizeMake((SCREEN_WIDTH/4), 34);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [RGB(237, 237, 237) set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置未选中背景色
    [seg setBackgroundImage:normalImg forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // 使用颜色创建UIImage //选中颜色
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *selectedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //设置选中背景色
    [seg setBackgroundImage:selectedImg forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    [self.view addSubview:seg];
    
    [seg addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];  //添加委托方法
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData{
    
    
}

-(void)gotoBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showEmptyView];
}

-(void)showEmptyView{
     [_empty_view removeFromSuperview];
    if(_result_array.count==0){
        _empty_view=[[UIView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104)];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, SCREEN_HEIGHT/2-164, 200, 20)];
        label.text=@"暂无关税信息";
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=RGB(51, 51, 51);
        [_empty_view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.view addSubview:_empty_view];
    }
    
    
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    NSLog(@"Index %i", Index);
    
    //    static NSString *prediStr1 = @"cat_name LIKE '*'";
    //
    //    //    1）.等于查询
    //    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", "Ansel"];
    //    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    //    //
    //    //    2）.模糊查询
    //    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", @"A"]; //predicate只能是对象
    //    //    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
    //
    //    switch (Index) {
    //        case 0:{
    //
    //            prediStr1 = @"status LIKE '*'";
    //
    //        }
    //            break;
    //        case 1:{
    //
    //            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 1];
    //        }
    //            break;
    //        case 2:{
    //
    //            prediStr1 = [NSString stringWithFormat:@"status=='%d'", 0];
    //
    //        }
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",prediStr1]];
    //    
    //    self.result_array = [self.Coupons_array filteredArrayUsingPredicate:predicate];
    //    [self.tableView reloadData];
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
