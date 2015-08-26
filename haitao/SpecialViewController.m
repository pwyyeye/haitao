//
//  SpecialViewController.m
//  haitao
//
//  Created by SEM on 15/7/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "SpecialViewController.h"
#import "SpecialModel.h"
#import "SpeciaButton.h"
#import "New_Goods.h"
#import "SpecialContentViewController.h"
@interface SpecialViewController ()
{
    UIView *view_bar1;
    UITableView                 *_tableView;
    NSMutableArray *spcList;
}

@end

@implementation SpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=0;
    spcList =[[NSMutableArray alloc]init];
    _tableView =[[UITableView alloc]initWithFrame:self.mainFrame style:UITableViewStylePlain];
    _tableView.tableHeaderView.backgroundColor=[UIColor blueColor];
//   [_tableView.tableHeaderView setHidden:YES];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
//    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    [_refresh startRefreshingDirection:DJRefreshDirectionTop animation:YES];
    //左右滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedRightButton:)];
    
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.view addGestureRecognizer:swipeLeft];
    
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tappedLeftButton:)];
    
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self.view addGestureRecognizer:swipeRight];
//    [self getSpecialData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark  下拉刷新
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
        [self getSpecialData];
    }
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
}
#pragma mark  下拉刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}
#pragma mark  获取专题列表
-(void)getSpecialData{
    [spcList removeAllObjects];
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectList",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getSubjectList"];
//    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    httpController.delegate = self;
    [httpController onSearch];

}
#pragma mark  获取专题详细信息
-(void)getSpecialContentData:(NSString *)sid{
    
    NSDictionary *parameters = @{@"id":sid};
    sidTemp=sid;
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectInfo",requestUrl]
    ;
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app startLoading];

    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getSubjectInfo"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}

#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app stopLoading];

    if([urlname isEqualToString:@"getSubjectList"]){
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        if ((NSNull *)dataArr == [NSNull null]) {
            showMessage(@"暂无商品!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
        for (NSDictionary *brandDic in dataArr) {
            SpecialModel *specialModel= [SpecialModel objectWithKeyValues:brandDic] ;
            [spcList addObject:specialModel];
        }
        [_tableView reloadData];
    }
    
    if([urlname isEqualToString:@"getSubjectInfo"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSDictionary *detailDic=[dataDic objectForKey:@"detail"];
        NSArray *goodsArr=[dataDic objectForKey:@"goods"];
        SpecialModel *specialModel= [SpecialModel objectWithKeyValues:detailDic] ;
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        NSDictionary *spdic=@{@"detail":specialModel,@"goods":goodsModelArr};
        SpecialContentViewController *specialContentViewController=[[SpecialContentViewController alloc]init];
        specialContentViewController.spcDic=spdic;
        specialContentViewController.sid=sidTemp;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:specialContentViewController animated:YES];
    }
}
#pragma mark tableView
-(void)querySpContent:(SpeciaButton *)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(querySpContentDo:) object:sender];
    [self performSelector:@selector(querySpContentDo:) withObject:sender afterDelay:0.2f];
    
}
-(void)querySpContentDo:(SpeciaButton *)sender{
    [self getSpecialContentData:sender.specialModel.id];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return spcList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    UITableViewCell *cell =nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
        
    }
    SpecialModel *specialModel=spcList[indexPath.row];
    CGRect cellFrame = [cell frame];
    cellFrame.origin=CGPointMake(0, 0);
    cellFrame.size.width=320;
    cellFrame.size.height=120;
    [cell setFrame:cellFrame];
    
    
    SpeciaButton *line=[[SpeciaButton alloc]initWithFrame:cellFrame];
    if(![specialModel.img isEqual:@""]){
        NSURL *imgUrl=[NSURL URLWithString:specialModel.img];
        [line setImageWithURL:imgUrl];
    }
    [line addTarget:self action:@selector(querySpContent:) forControlEvents:UIControlEventTouchUpInside];
    line.specialModel=specialModel;
    [cell addSubview:line];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    //    TMThirdClassViewController *goods=[[TMThirdClassViewController alloc]init];
    //
    //    [delegate.navigationController pushViewController:goods animated:YES];
}

- (IBAction) tappedRightButton:(id)sender

{
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    
    
    NSArray *aryViewController = self.tabBarController.viewControllers;
    
    if (selectedIndex < aryViewController.count - 1) {
        UIView *fromView = [self.tabBarController.selectedViewController view];
        
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1] view];
        toView.left=SCREEN_WIDTH;
        // 动画开始
        
        [UIView beginAnimations:nil context:nil];
        
        // 动画时间曲线 EaseInOut效果
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        // 动画时间
        
        [UIView setAnimationDuration:0.5];
        
        fromView.left =-SCREEN_WIDTH;
        toView.left=0;
        // 动画结束（或者用提交也不错）
        
        [UIView commitAnimations];
        
        [self.tabBarController setSelectedIndex:selectedIndex + 1];
        NSString *ss=[NSString stringWithFormat:@"%ld",selectedIndex+1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMenu" object:ss];
        
        
        
        
    }
    
    
    
}



- (IBAction) tappedLeftButton:(id)sender

{
    
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    
    
    
    if (selectedIndex > 0) {
        
        UIView *fromView = [self.tabBarController.selectedViewController view];
        
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex - 1] view];
        toView.left=-SCREEN_WIDTH;
        // 动画开始
        
        [UIView beginAnimations:nil context:nil];
        
        // 动画时间曲线 EaseInOut效果
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        // 动画时间
        
        [UIView setAnimationDuration:0.5];
        
        fromView.left =SCREEN_WIDTH;
        toView.left=0;
        // 动画结束（或者用提交也不错）
        
        [UIView commitAnimations];
        [self.tabBarController setSelectedIndex:selectedIndex - 1];
        NSString *ss=[NSString stringWithFormat:@"%ld",selectedIndex-1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMenu" object:ss];
        
        
    }
    
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
