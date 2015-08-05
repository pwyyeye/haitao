//
//  SpecialContentViewController.m
//  haitao
//
//  Created by SEM on 15/7/25.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#import "SpecialContentViewController.h"
#import "SpecialModel.h"
#import "New_Goods.h"
#import "ScreenViewController.h"
@interface SpecialContentViewController ()
{
    UITableView                 *_tableView;
    UrlImageView *imageV;
    SpecialModel *specialModel;
    UIView *view_bar1;
    UIButton*btnItem1; //上部五个按钮
    UIButton*btnItem2;
    UIButton*btnItem3;
    UIButton*btnItem4;
    UIButton*btnItem5;
    UIImageView*  tabBarArrow;//上部桔红线条
}

@end

@implementation SpecialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    NSArray *goodArr=[self.spcDic objectForKey:@"goods"];
    specialModel=[self.spcDic objectForKey:@"detail"];
    listArr=[[NSMutableArray alloc]init];
    [self getGoodlist:goodArr];
    // Do any additional setup after loading the view.
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
    title_label.text=@"专题";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"left_grey") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    return view_bar1;
}
#pragma mark退出
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark置顶按钮栏
-(UIView*)getToolBar
{
    UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,35 )];
    imageView.backgroundColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0];
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    
    btnItem1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem1 setFrame:CGRectMake(0, 0, 320/5, 35)];
    btnItem1.exclusiveTouch=YES;
    btnItem1.tag = 100;
    [btnItem1 setTitle:@"默认" forState:0];
//    btnItem1.titleLabel.textAlignment=1;
//    btnItem1.titleLabel.textColor=   hongShe;
    
    [btnItem1 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
    btnItem1.backgroundColor=[UIColor whiteColor];
    [btnItem1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnItem1];
    
    
    btnItem2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem2 setFrame:CGRectMake(320/5*1+1, 0, 320/5, 35)];
    
    btnItem2.exclusiveTouch=YES;
    btnItem2.tag = 101;
    btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    [btnItem2 setTitle:@"销量" forState:0];
    [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0];
    [btnItem2 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnItem2];
    
    btnItem3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem3 setFrame:CGRectMake(320/5*2+2, 0, 320/5, 35)];
    btnItem3.exclusiveTouch=YES;
    btnItem3.tag = 102;
    btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    [btnItem3 setTitle:@"折扣" forState:0];
    [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0];
    [btnItem3 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnItem3];
    
    btnItem4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem4 setFrame:CGRectMake(320/5*3+3, 0, 320/5, 35)];
    btnItem4.exclusiveTouch=YES;
    btnItem4.tag = 103;
    btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    [btnItem4 setTitle:@"价格" forState:0];
    [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0];
    [btnItem4 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnItem4];
    
    btnItem5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnItem5 setFrame:CGRectMake(320/5*4+4, 0, 320/5, 35)];
    btnItem5.exclusiveTouch=YES;
    btnItem5.tag = 104;
    btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
    [btnItem5 setTitle:@"筛选" forState:0];
    [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0];
    [btnItem5 addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:btnItem5];
    
//    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 34, 320, 1)];
//    line.image=BundleImage(@"line_01_.png");
//    [imageView addSubview:line];
//    
//    tabBarArrow=[[UIImageView alloc]init];
//    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], 34, 320/8, 2);
//    tabBarArrow.image=BundleImage(@"line_p_.png");
//    [imageView addSubview:tabBarArrow];
    
    return  imageView;
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.view.frame.size.width/5;
    return (tabIndex * tabItemWidth+ tabItemWidth/5-4);
}
#pragma mark5个按钮事件
-(void)change:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    
    [UIView beginAnimations:Nil context:Nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame=tabBarArrow.frame;
    frame.origin.x=[self horizontalLocationFor:btn.tag-100];
    tabBarArrow.frame=frame;
    [UIView commitAnimations];
    
    if (btn.tag==100)
    {
        [btnItem1 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor whiteColor];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
        
    }else if(btn.tag==101)
    {
        [btnItem2 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        btnItem2.backgroundColor=[UIColor whiteColor];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==102)
    {
        [btnItem3 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor whiteColor];
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==103)
    {
        [btnItem4 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
        btnItem4.backgroundColor=[UIColor whiteColor];
        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        [btnItem5 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
        btnItem5.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    else if(btn.tag==104)
    {
        ScreenViewController *screenViewController=[[ScreenViewController alloc]init];
        screenViewController.indexDic=nil;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:screenViewController animated:YES];
//        [btnItem5 setTitleColor:[UIColor colorWithRed:1.0 green:.23 blue:.49 alpha:1.0] forState:0]   ;
//        btnItem5.backgroundColor=[UIColor whiteColor];
//        [btnItem1 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem1.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem2 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem2.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem4 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem4.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
//        [btnItem3 setTitleColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0] forState:0]   ;
//        btnItem3.backgroundColor=[UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1.0];
        
    }
    
}

#pragma mark获取商品数据
-(void)getGoodlist:(NSArray *)arr{
    int nowCount;
    [listArr removeAllObjects];
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:2];
    for (int i=0; i<arr.count; i++) {
        New_Goods *new_Goods= arr[i];
        
        if(nowCount%2==0){
            [pageArr addObject:new_Goods];
            [listArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:2];
        }else{
            [pageArr addObject:new_Goods];
            if(i==arr.count-1){
                [listArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    [_tableView reloadData];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else{
        return listArr.count;
    }
//    return spcList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return 0;
    }
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==1){
        return  [self getToolBar];
    }
    UIView * uiview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] ;
    return uiview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        static NSString *contet_cell = @"contet_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contet_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor redColor];
        }
        UrlImageButton *urlImageView=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
        NSURL *url =[NSURL URLWithString:specialModel.img];
        [urlImageView setImageWithURL:url];
        urlImageView.backgroundColor=[UIColor clearColor];
        [cell addSubview:urlImageView ];

        return cell;
    }else{
        static NSString *CellIdentifier = @"cate_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            
        }
        CGRect lastFrame;
        NSArray *arrTemp=listArr[indexPath.row];
        for (int i =0; i<arrTemp.count; i++)
        {
            New_Goods *new_Goods=arrTemp[i];
            imageV=[[UrlImageView alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10, 140, 140)];
            imageV.backgroundColor=[UIColor redColor];
            imageV.userInteractionEnabled=YES;
            //            btn.layer.shadowOffset = CGSizeMake(1,1);
            //            btn.layer.shadowOpacity = 0.2f;
            //            btn.layer.shadowRadius = 3.0;
            imageV.layer.borderWidth=1;//描边
            imageV.layer.cornerRadius=4;//圆角
            imageV.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            imageV.backgroundColor=[UIColor whiteColor];
            
            [cell addSubview:imageV];
            
            UrlImageButton*btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(2, 2, 140-4, 140-4)];
            btn.userInteractionEnabled=YES;
            btn.layer.borderWidth=1;//描边
            btn.layer.cornerRadius=4;//圆角
            btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            btn.backgroundColor=[UIColor whiteColor];
            
            NSString *urlStr=new_Goods.img;
            if((urlStr==nil)||[urlStr isEqualToString:@""]){
                [btn setBackgroundImage:BundleImage(@"df_04_.png") forState:0];
            }else{
                NSURL *imgUrl=[NSURL URLWithString:urlStr];
                [btn setImageWithURL:imgUrl];
            }
            
            [btn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
            //            [imageV addSubview:btn];
            [imageV insertSubview:btn aboveSubview:imageV];
            
            UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+10+140, 140, 40)];
            _label.text=new_Goods.title;
            _label.font=[UIFont boldSystemFontOfSize:14];
            _label.backgroundColor=[UIColor clearColor];
            _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
            _label.numberOfLines=2;
            _label.textAlignment=0;
            
            [cell addSubview:_label];
            
            
            
            
            
            UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13, floor(i/2)*200+140+10+_label.frame.size.height, 65, 20)];
            title_label.text=[NSString stringWithFormat:@"%f",new_Goods.price];
            
            title_label.font=[UIFont systemFontOfSize:12];
            title_label.backgroundColor=[UIColor clearColor];
            title_label.textColor =hongShe;
            title_label.textAlignment=0;
            lastFrame=title_label.frame;
            //
            [cell addSubview:title_label];
            
            UILabel *title_label1=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13+title_label.frame.size.width, floor(i/2)*200+140+10+_label.frame.size.height, 65, 20)];
            title_label1.text=@"199.70";
            title_label1.font=[UIFont systemFontOfSize:10];
            title_label1.backgroundColor=[UIColor clearColor];
            title_label1.textColor =[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
            title_label1.textAlignment=0;
            
            [cell addSubview:title_label1];
            
            //高度固定不折行，根据字的多少计算label的宽度
            NSString *str = title_label1.text;
            CGSize size = [str sizeWithFont:title_label.font constrainedToSize:CGSizeMake(MAXFLOAT, title_label.frame.size.height)];
            //                     NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
            //根据计算结果重新设置UILabel的尺寸
            
            
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, title_label1.frame.size.height/2, size.width, 1)];
            line.image=BundleImage(@"line_01_.png");
            [title_label1 addSubview:line];
            
        }
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=320;
        cellFrame.size.height=140+40+10+20+10;
        [cell setFrame:cellFrame];
        
        
        
        return cell;

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 120;
    }
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
-(void)goodContentTouch:(id)sender{
    
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
#pragma mark  下拉刷新
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
//        [self getSpecialData];
    }
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
}
#pragma mark  下拉刷新
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
}
@end
