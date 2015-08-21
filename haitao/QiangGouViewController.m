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
#import "CusCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
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
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake((view_bar1.width-130)/2, (view_bar1.frame.size.height-20-44)/2+20, 130, 44)];
    title_label.text=@"抢购";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, (view_bar1.frame.size.height-20-34)/2+20, 47, 34);
    [btnBack setImage:BundleImage(@"btn_back") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    return view_bar1;
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CusCell";
    
    CusCell *cell = (CusCell *)[_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (CusCell *)[nibArray objectAtIndex:0];
        cell.backgroundColor=[UIColor clearColor];
        [cell.shopbtn addTarget:self action:@selector(qianggouAct:) forControlEvents:UIControlEventTouchUpInside];
//        cell.lineLal.height=0.5;
        UILabel *lineLal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 92, 300, 0.5)];
        lineLal1.backgroundColor=RGB(237, 237, 237);
        [cell addSubview:lineLal1];
    }
    
    App_Home_Bigegg *grabModel=self.listArr[indexPath.row];
    cell.shopbtn.tag=indexPath.row;
    cell.shopName.text=grabModel.content;
    NSURL *imgUrl=[NSURL URLWithString:grabModel.img_url];
    [cell.shopImgView setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"default_02.png"]];
    cell.shipName.text=grabModel.country_name;
    [cell.shipImgView setImageWithURL:[NSURL URLWithString:grabModel.country_flag_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    cell.priceLbl.text=[NSString stringWithFormat:@"￥%.2f",grabModel.price_cn];
//    @property (weak, nonatomic) IBOutlet UILabel *shopName;
//    @property (weak, nonatomic) IBOutlet UrlImageView *shopImgView;
//    @property (weak, nonatomic) IBOutlet UILabel *shipName;
//    @property (weak, nonatomic) IBOutlet UIButton *shopbtn;
//    @property (weak, nonatomic) IBOutlet UrlImageView *shipImgView;
//    @property (weak, nonatomic) IBOutlet UILabel *priceLbl;

    
    
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 98;
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

-(void)qianggouAct:(UIButton *)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(qianggouActDo:) object:sender];
    [self performSelector:@selector(qianggouActDo:) withObject:sender afterDelay:0.3f];
}
-(void)qianggouActDo:(UIButton *)sender{
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
