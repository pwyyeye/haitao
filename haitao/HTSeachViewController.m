//
//  HTSeachViewController.m
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTSeachViewController.h"
#import "BAWineShoppingDockTavleView.h"
#import "BARightTableView.h"
#import "BADockCell.h"
#import "Header.h"
#import "BALabel.h"
#import "MenuModel.h"
#import "UIImageButton.h"
#import "UITableGridViewCell.h"
#import "LTKSeachResultViewController.h"
#define kImageWidth  75 //UITableViewCell里面图片的宽度
#define kImageHeight  90 //UITableViewCell里面图片的高度
@interface HTSeachViewController ()<DockTavleViewDelegate,RightTableViewDelegate>{
    UIView *view_bar1;
    BARightTableView *rightTableView ;
}
@property (nonatomic ,strong) BAWineShoppingDockTavleView *dockTavleView;

@property (nonatomic ,strong) BARightTableView *rightTableView;

@property (nonatomic ,strong) NSMutableArray *dockArray;

@property (nonatomic ,strong) NSMutableArray *offsArray;

@property (nonatomic ,weak) UILabel *totalPrice;

@property (nonatomic ,weak) BALabel *bottomLabel;

@property (nonatomic ,assign) NSInteger quantityInt;

@property (nonatomic ,strong) NSMutableDictionary *dic;

@property (nonatomic ,strong) NSMutableArray *key;

@property (nonatomic ,weak) UILabel *totalSingular;

@property (nonatomic ,weak) UIImageView *cartImage;
@end

@implementation HTSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    menuArr=[[NSMutableArray alloc]init];
    
    UIView *naviView=(UIView*) [self getNavigationBar];
    //CGRectMake(self.view.frame.size.width-50, naviView.frame.size.height+10, 42, 42)
    
    
    BAWineShoppingDockTavleView *dockTavleView =[[BAWineShoppingDockTavleView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,75,kWindowHeight-50}];
    dockTavleView.rowHeight=50;
    dockTavleView.dockDelegate=self;
    dockTavleView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
    [dockTavleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:dockTavleView];
    _dockTavleView =dockTavleView;
    
    rightTableView =[[BARightTableView alloc]initWithFrame:(CGRect){75,naviView.frame.size.height+1,kWindowWidth-75,kWindowHeight-50}];
    rightTableView.rowHeight=90;
    rightTableView.rightDelegate=self;
    rightTableView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
    [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    rightTableView.delegate=self;
    rightTableView.dataSource=self;
    [self.view addSubview:rightTableView];
    _rightTableView=rightTableView;
    
    
    _dockArray =[NSMutableArray array];
    
 
    _offsArray =[NSMutableArray array];
    
    
    
    
    
    _dic=[NSMutableDictionary dictionary];
    _key=[NSMutableArray array];
    //    UIButton *btn =[[UIButton alloc]initWithFrame:(CGRect){200,300,100,100}];
    //    btn.backgroundColor=[UIColor redColor];
    //    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:btn];
    
    [self getMenuData];
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
}
-(void)getMenuData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSString* url =[NSString stringWithFormat:@"%@&m=home&f=getHomeNav",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"menu"];
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
    if([urlname isEqualToString:@"menu"]){
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
            [menuArr addObject:menuModel];
        }
        [self initTable];
        NSLog(@"");
        //保存数据
        
    }
    
    
}
-(void)initTable{
    for ( int i=0; i<menuArr.count; i++) {
        MenuModel *menu=menuArr[i];
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        
//        NSMutableArray *array =[NSMutableArray array];
        
        NSArray *childArr=menu.child;
        NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:3];
        NSMutableArray *rightArr=[[NSMutableArray alloc]initWithCapacity:3];
        int nowCount=1;
        for (int j=0; j<childArr.count-1; j++) {
            MenuModel *menuChild=childArr[j];
            if(nowCount%3==0){
                [pageArr addObject:menuChild];
                [rightArr addObject:pageArr];
                pageArr=[[NSMutableArray alloc]initWithCapacity:6];
            }else{
                [pageArr addObject:menuChild];
                if(j==childArr.count-1){
                    
                    [rightArr addObject:pageArr];
                }
            }

            nowCount++;
        }
        
        dic =[@{@"dockName":menu.name,@"right":rightArr} mutableCopy];
        [_dockArray addObject:dic];    
    }
    _dockTavleView.dockArray=_dockArray;
    for ( int i=0; i<[_dockArray count]; i++) {
        CGPoint point =CGPointMake(0, 0);
        [_offsArray addObject:NSStringFromCGPoint(point)];
    }
    [_dockTavleView reloadData];
    NSMutableDictionary *dic =_dockArray[0];
    rightTableView.rightArray=[dic objectForKey:@"right"];
    [rightTableView reloadData];
}
-(void)bottomLabelClick
{
    UIViewController *vc =[[UIViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dockClickindexPathRow:(NSMutableArray *)array index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath
{
//    [_rightTableView setContentOffset:_rightTableView.contentOffset animated:NO];
//    _offsArray[index.row] =NSStringFromCGPoint(_rightTableView.contentOffset);
    rightTableView.rightArray=array;
    [rightTableView reloadData];
//    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
//    [_rightTableView setContentOffset:point];
//    [_rightTableView setNeedsDisplay];
    //    NSLog(@"%@",row);
}
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"商品快寻";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnSeach=[UIButton buttonWithType:0];
    btnSeach.frame=CGRectMake(view_bar1.frame.size.width-55, view_bar1.frame.size.height-45, 49, 45);
    
    [btnSeach setTitle:@"订单" forState:0];
    [btnSeach setImage:BundleImage(@"sskx_search.png") forState:0];
    [btnSeach addTarget:self action:@selector(btnSeach:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnSeach];

    //    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    ////        title_label.text=@"商品详情";
    //    title_label.font=[UIFont boldSystemFontOfSize:20];
    //    title_label.backgroundColor=[UIColor clearColor];
    //    title_label.textColor =[UIColor whiteColor];
    //    title_label.textAlignment=1;
    //    [view_bar1 addSubview:title_label];
    
    
    
    
    
    return view_bar1;
}
-(void)btnSeach:(id)sender
{
    LTKSeachResultViewController *seachR=[[LTKSeachResultViewController alloc]init];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.navigationController pushViewController:seachR animated:YES];
    
}
-(void)cartImageClick
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return rightTableView.rightArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    //自定义UITableGridViewCell，里面加了个NSArray用于放置里面的3个图片按钮
    UITableGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] init];   
    }
    for(UIView *view in [cell subviews])
    {
        [view removeFromSuperview];
        
    }
    NSMutableArray *array = [NSMutableArray array];
    NSArray *arr=rightTableView.rightArray[indexPath.row];
    for (int i=0; i<arr.count; i++) {
        MenuModel *menu=arr[i];
        NSLog(menu.name);
        //自定义继续UIButton的UIImageButton 里面只是加了2个row和column属性
        UIImageButton *button = [UIImageButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, kImageWidth, kImageHeight);
        button.center = CGPointMake((1 + i) * 5 + kImageWidth *( 0.5 + i) , 5 + kImageHeight * 0.5);
        //button.column = i;
        [button setValue:[NSNumber numberWithInt:i] forKey:@"column"];
        button.tag=indexPath.row;
        UIImage *image = [rightTableView cutCenterImage:[UIImage imageNamed:@"奶粉.jpg"]  size:CGSizeMake(60, 60)];
        [button addTarget:self action:@selector(imageItemClick:) forControlEvents:UIControlEventTouchUpInside];             [button setBackgroundImage:image forState:UIControlStateNormal];
        [cell addSubview:button];
        [array addObject:button];
        UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x,button.frame.origin.y+button.frame.size.height+5,kImageWidth,40)];
        _label.text=menu.name;
        _label.font=[UIFont boldSystemFontOfSize:14];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        _label.numberOfLines=1;
        _label.textAlignment=NSTextAlignmentCenter;
        _label.tag=indexPath.row;
        [cell addSubview:_label];
    }
    [cell setValue:array forKey:@"buttons"];
    //获取到里面的cell里面的3个图片按钮引用
    NSArray *imageButtons =cell.buttons;
    //设置UIImageButton里面的row属性
    [imageButtons setValue:[NSNumber numberWithInt:indexPath.row] forKey:@"row"];
    return cell;
    /*
     BARightCell *cell =[BARightCell cellWithTableView:tableView];
     cell.TapActionBlock=^(NSInteger pageIndex ,NSInteger money,NSString *key){
     if ([self.rightDelegate respondsToSelector:@selector(quantity:money:key:)]) {
     [self.rightDelegate quantity:pageIndex money:money key:key];
     }
     
     };
     
     cell.backgroundColor=UIColorRGBA(246, 246, 246, 1);
     cell.rightData=_rightArray[indexPath.row];
     return cell;
     */
    
}
-(void)imageItemClick:(UIImageButton *)button{
    NSString *msg = [NSString stringWithFormat:@"第%i行 第%i列",button.row + 1, button.column + 1];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好的，知道了"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kImageHeight + 50;
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
