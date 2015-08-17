//
//  QiangGouViewController.m
//  haitao
//
//  Created by SEM on 15/8/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "QiangGouViewController.h"
#import "App_Home_Bigegg.h"
#import "UrlImageButton.h"

@interface QiangGouViewController ()
{
     UITableView                 *_tableView;
}
@end

@implementation QiangGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,self.view.frame.size.width,SCREEN_HEIGHT-naviView.frame.size.height} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    //    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    //    _refresh.topEnabled=YES;
    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    
   

    // Do any additional setup after loading the view.
}
#pragma mark - Navigation
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    UIView *view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        view_bar1.backgroundColor =RGB(255, 13, 94);
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        view_bar1.backgroundColor =RGB(255, 13, 94);
        
    }
    
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"抢购";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"btn_back") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    return view_bar1;
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
//    CGRect lastFrame;
    UrlImageButton *btn;
    UILabel *label1;
    UILabel *label2;
    for (int i =0; i<self.listArr.count; i++)
    {
        App_Home_Bigegg *grabModel=self.listArr[i];
        btn=[[UrlImageButton alloc]initWithFrame:CGRectMake(20+i*(SCREEN_WIDTH-80)/3+i*20, floor(i/3)*(SCREEN_WIDTH-80)/3+10, (SCREEN_WIDTH-80)/3, (SCREEN_WIDTH-80)/3)];
        NSURL *imgUrl=[NSURL URLWithString:grabModel.img_url];
        [btn setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"default_02.png"]];
        btn.tag=i;
        //        [btn setImage:[UIImage imageNamed:@"default_02.png"] forState:0];
        //        - (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
        [cell addSubview:btn];
        [btn addTarget:self action:@selector(qianggouAct:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor clearColor];
        
        label1=[[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.frame.size.height+btn.frame.origin.y+3, btn.width, 15)];
        label1.text=grabModel.content;
        label1.textColor =hexColor(@"#333333");
        label1.font=[UIFont systemFontOfSize:11];
        label1.textAlignment=1;
        label1.backgroundColor=[UIColor clearColor];
        //        label1.lineBreakMode = UILineBreakModeWordWrap;
        label1.numberOfLines = 1;
        //        CGRect txtFrame = label1.frame;
        [cell addSubview:label1];
        
        label2=[[UILabel alloc]initWithFrame:CGRectMake(label1.left, label1.frame.size.height+label1.frame.origin.y, label1.width, 20)];
        label2.text=[NSString stringWithFormat:@"￥%.2f",grabModel.price_cn];
        label2.font=[UIFont boldSystemFontOfSize:14];
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor =hexColor(@"#ff0d5e");
        label2.textAlignment=1;
        label2.backgroundColor=[UIColor clearColor];
        //        if(maxFrame.origin.y<label2.frame.origin.y){
        //            maxFrame=label2.frame;
        //        }
        [cell addSubview:label2];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    CGRect cellFrame = [cell frame];
    cellFrame.origin=CGPointMake(0, 0);
    cellFrame.size.width=SCREEN_WIDTH;
    cellFrame.size.height=label2.top +label2.size.height+10;
    
    [cell setFrame:cellFrame];
    
    
    
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

#pragma mark退出
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
}

-(void)qianggouAct:(UrlImageButton *)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(qianggouActDo:) object:sender];
    [self performSelector:@selector(qianggouActDo:) withObject:sender afterDelay:0.3f];
}
-(void)qianggouActDo:(UrlImageButton *)sender{
    App_Home_Bigegg *grabModel=self.listArr[sender.tag];
    NSDictionary *parameters = @{@"id":grabModel.goods_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"addFav"]){
        ShowMessage(@"收藏成功");
    }
    
    if([urlname isEqualToString:@"getGoodsDetail"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSDictionary *goods_detail=[dataDic objectForKey:@"goods_detail"];
        NSDictionary *goods_ext=[dataDic objectForKey:@"goods_ext"];
        NSArray *goods_image=[dataDic objectForKey:@"goods_image"];
        NSDictionary *goods_attr=[dataDic objectForKey:@"goods_attr"];
        //        NSArray *priceArr=[goods_attr objectForKey:@"price"];
        //        NSArray *attr_infoArr=[goods_attr objectForKey:@"attr_info"];
        NSArray *goods_parity=[dataDic objectForKey:@"goods_parity"];
        New_Goods *newGoods = [New_Goods objectWithKeyValues:goods_detail] ;
        Goods_Ext *goodsExt=[Goods_Ext objectWithKeyValues:goods_ext];
        //        NSDictionary *menuIndexDic=[dataDic objectForKey:@"cat_index"];
        HTGoodDetailsViewController *htGoodDetailsViewController=[[HTGoodDetailsViewController alloc]init];
        htGoodDetailsViewController.goods_parity=goods_parity;
        htGoodDetailsViewController.goods=newGoods;
        htGoodDetailsViewController.goods_attr=goods_attr;
        htGoodDetailsViewController.goodsExt=goodsExt;
        htGoodDetailsViewController.goods_image=goods_image;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:htGoodDetailsViewController animated:YES];
        
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
