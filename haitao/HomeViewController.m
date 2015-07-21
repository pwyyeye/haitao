//
//  HomeViewController.m
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HomeViewController.h"
#import"EScrollerView.h"
#import "Toolkit.h"
#import "UrlImageButton.h"
#import "HTGoodDetailsViewController.h"
#import "App_Home_Bigegg.h"
@interface HomeViewController ()
{
    UrlImageButton *btn;
    UILabel *label1;
    UrlImageButton *fourBtn;
    UILabel *fourLab;
    UIView *_view;
    UILabel *label2;
    UILabel *label3;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    app_home_bigegg=[[NSMutableArray alloc]init] ;//首页通栏即广告栏
    app_home_grab=[[NSMutableArray alloc]init];//手机端抢购
    app_home_command=[[NSMutableArray alloc]init];//手机端精品推荐
    app_home_brand=[[NSMutableArray alloc]init];//手机端国际名品
    new_goods=[[NSMutableArray alloc]init];//手机端国际名品
    [self getMenuData];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_scrollView){
        _scrollView.frame=self.mainFrame;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)drawViewRect
{
    
    _scrollView=[[UIScrollView alloc]initWithFrame:self.mainFrame];
    _scrollView.backgroundColor=[UIColor blackColor];
    if (IS_IPHONE_5) {
        
        [_scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+15)];
    }else{
        [_scrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+120)];
    }
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.view addSubview:_scrollView];
    //
//    [imagePathArray addObject:[dic objectForKey:@"ititle"]];
//    [titleArray addObject:[dic objectForKey:@"mainHeading"]];
//    [idArray addObject:[dic objectForKey:@"id"]];
    NSMutableArray *bigArr=[[NSMutableArray alloc]init];
    for (App_Home_Bigegg *bigTemp in app_home_bigegg) {
        NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
        [dicTemp setObject:bigTemp.img_url forKey:@"ititle"];
        [dicTemp setObject:bigTemp.content forKey:@"mainHeading"];
        [bigArr addObject:dicTemp];
    }
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 160)
                                                          scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
    scroller.delegate=self;
    scroller.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:scroller];
    
    UIImageView*img=[[UIImageView alloc]initWithFrame:CGRectMake(0,scroller.frame.size.height+scroller.frame.origin.y, self.view.frame.size.width, 33)];
    img.image=BundleImage(@"titlebar.png");
    img.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:img];

    for (int i =0; i<3; i++)
    {
        btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(12+i*100, img.frame.size.height+img.frame.origin.y+10, 95, 70)];
        [btn setImage:[UIImage imageNamed:@"default_02.png"] forState:0];
        [_scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnGoodsList:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor clearColor];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(12+i*100, btn.frame.size.height+btn.frame.origin.y+5, 95, 20)];
        label1.text=@"OLAY紧肤霜";
        label1.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        label1.font=[UIFont systemFontOfSize:12];
        label1.textAlignment=1;
        label1.backgroundColor=[UIColor clearColor];
        
        [_scrollView addSubview:label1];
        
        label2=[[UILabel alloc]initWithFrame:CGRectMake(12+i*100, label1.frame.size.height+label1.frame.origin.y+15, 95, 20)];
        label2.text=@"$60.00";
        label2.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        label2.font=[UIFont systemFontOfSize:12];
        label2.textAlignment=1;
        label2.backgroundColor=[UIColor clearColor];
        
        [_scrollView addSubview:label2];
        
    }
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(0,label2.frame.size.height+label2.frame.origin.y+6 , self.view.frame.size.width, 33)];
    img1.image=BundleImage(@"titlebar.png");
    img1.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:img1];
    for (int i =0; i<8; i++)
    {
        fourBtn=[[UrlImageButton alloc]initWithFrame:CGRectMake(12+i*75, img1.frame.size.height+img1.frame.origin.y+8, 70, 70)];
        [fourBtn addTarget:self action:@selector(btnShopStore:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:fourBtn];
        [fourBtn setBackgroundImage: [UIImage imageNamed:@"default_02.png"] forState:0];
        [fourBtn setImage: [UIImage imageNamed:@"spic_01.png"] forState:0];
        fourLab=[[UILabel alloc]initWithFrame:CGRectMake(12+i*75, fourBtn.frame.size.height+fourBtn.frame.origin.y+8, 70, 20)];
        fourLab.text=@"孝敬父母";
        fourLab.textColor=[UIColor grayColor];
        fourLab.font=[UIFont boldSystemFontOfSize:10];
        fourLab.textAlignment=1;
        fourLab.backgroundColor=[UIColor clearColor];
        [_scrollView addSubview:fourLab];
        
    }
    

   
    
}
-(void)getMenuData{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    //    http://www.peikua.com/app.php?app.php?m=home&a=app&f=getHomeData
    NSString* url =[NSString stringWithFormat:@"%@&m=home&f=getHomeData",requestUrl]
    ;
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getHomeData"];
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
    if([urlname isEqualToString:@"getHomeData"]){
         NSDictionary *dic=[dictemp objectForKey:@"data"];
        if ((NSNull *)dic == [NSNull null]) {
            showMessage(@"暂无数据!");
            //            [self showMessage:@"暂无数据!"];
            return;
            
        }
//        app_home_bigegg=[[NSMutableArray alloc]init] ;//首页通栏即广告栏
//        app_home_grab=[[NSMutableArray alloc]init];//手机端抢购
//        app_home_command=[[NSMutableArray alloc]init];//手机端精品推荐
//        app_home_brand=[[NSMutableArray alloc]init];//手机端国际名品
//        new_goods=[[NSMutableArray alloc]init];//手机端国际名品
        NSDictionary *ad_infoDic=[dic objectForKey:@"ad_info"];
       //首页通栏即广告栏
        NSArray *app_home_bigeggArr= [ad_infoDic objectForKey:@"app_home_bigegg"];
        for (NSDictionary *bigeggDic in app_home_bigeggArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:bigeggDic] ;
            [app_home_bigegg addObject:app_Home_Bigegg];
        }
        NSArray *app_home_grabArr= [ad_infoDic objectForKey:@"app_home_grab"];
        for (NSDictionary *grabDic in app_home_grabArr) {
            App_Home_Bigegg *app_Home_Bigegg= [App_Home_Bigegg objectWithKeyValues:grabDic] ;
            [app_home_bigegg addObject:app_Home_Bigegg];
        }
        [self drawViewRect];
    }
    
    
}
-(void)EScrollerViewDidClicked:(NSUInteger)index{
    NSLog([NSString stringWithFormat:@"第几个%ld",index]);
}
-(void)btnShopStore:(id)sender
{
    
    //
}
-(void)btnGoodsList:(id)sender
{
    HTGoodDetailsViewController *shop=[[HTGoodDetailsViewController alloc]init];
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.navigationController pushViewController:shop animated:YES];
    //HTGoodsDetailsViewController
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
