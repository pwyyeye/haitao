//
//  ConfirmOrderController.m
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ConfirmOrderController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "OrderListCell.h"
#import "GoodsAttrModel.h"
#import "ChoosePayController.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "HTGoodDetailsViewController.h"
@interface ConfirmOrderController ()

@end

@implementation ConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"确认订单";
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    //    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    self.tableView.tableFooterView=[[UIView alloc]init];
    [self initData];
    [self getAddress];
    
    _step=30;
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(commitWait) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//暂停
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    //tableView的高度时header＋footer＋cell高度*cell个数
    NSArray *list=_confirmOrderModel.list;
    int i=0;
    int j=list.count;
    for (ConfirmPackage *package in list) {
        i+=package.list.count;
    }
    
    self.tableViewHeight.constant=128*j+80*i;
    //自身高度＝tableview的y坐标＋tableView的高度＋coll的高度*个数＋coll展开view的最大高度
    self.viewHeight.constant=self.tableView.frame.origin.y+self.tableViewHeight.constant+_coll.cellHeight+200;
    
    
}
-(void)gotoBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getAddress{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getAddress withType:POSTURL withPam:nil  withUrlName:@"getAddress"];
    httpController.delegate = self;
    [httpController onSearch];

}

-(void)initData{
    if (_ids==nil) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getOrderInfo withType:POSTURL withPam:@{@"ids":_ids} withUrlName:@"getOrderInfo"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
#pragma mark -  http 回调
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{

    //返回原来界面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        
        
        if ([urlname isEqualToString:@"getOrderInfo"]) {
            NSDictionary *dic=[dictemp objectForKey:@"data"];

            if (dic.count==0) {
                return;
            }
            _confirmOrderModel=[ConfirmOrderModel objectWithKeyValues:dic];
            NSLog(@"----pass-_confirmOrderModel%@---",dic);
            [_tableView reloadData];
            
            _coll=[[CollapseClick alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
            _coll.CollapseClickDelegate = self;
            _coll.cellSpace=0;
            _coll.cellHeight=40;
            _coll.scrollEnabled=NO;
            [_coll reloadCollapseClick];
            //    // If you want a cell open on load, run this method:
            //展开第一个
            //            [_coll openCollapseClickCellAtIndex:0 animated:NO];
            
            [self.myFooter addSubview:_coll];
            
            self.myFooter.backgroundColor=[UIColor whiteColor];
            
            if (_footerBar!=nil) {
                [_footerBar removeFromSuperview];
            }
            
            
            //设置底部按钮
            _footerBar=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-47-64, SCREEN_WIDTH, 47)];
            self.footerBar.backgroundColor=[UIColor whiteColor];
            //分割线
            UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
            jianju.backgroundColor=RGB(237, 237, 237);
            [self.footerBar addSubview:jianju];
            
            //合计
            UIButton *heji=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*3, 47)];
            
            //金额
            UILabel *hejiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 3.5, SCREEN_WIDTH/5*3-40, 40)];
            
            NSString *heji_jiner=[NSString stringWithFormat:@"%@%.2f",@"合计： ¥",_confirmOrderModel.all_info.all_amount];
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:heji_jiner];
            
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:RGB(128, 128, 128)
             
                                  range:NSMakeRange(0, 3)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:RGB(255, 13, 94)
             
                                  range:NSMakeRange(3, heji_jiner.length-3)];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:13]
             
                                  range:NSMakeRange(0, 3)];
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont boldSystemFontOfSize:17]
             
                                  range:NSMakeRange(3, heji_jiner.length-3)];
            
            hejiLabel.attributedText=AttributedStr;
            
            [heji addSubview:hejiLabel];
            //右边图标
            UIButton *rightIcon=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*3-40, 8, 30, 30)];
            [rightIcon setImage:[UIImage imageNamed:@"icon_Drop-downList"] forState:UIControlStateNormal];
            [_addressButton addSubview:rightIcon];
            
            [rightIcon addTarget:self action:@selector(showAmountDetail) forControlEvents:UIControlEventTouchUpInside];

            [heji addSubview:rightIcon];
            
            [heji addTarget:self action:@selector(showAmountDetail) forControlEvents:UIControlEventTouchUpInside];
            
            //提交订单
            _btn_confirm=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 8, SCREEN_WIDTH/5*2,35)];
            [_btn_confirm setBackgroundImage:[UIImage imageNamed:@"commitOrder"]  forState:UIControlStateNormal];
            [_btn_confirm addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
            [_btn_confirm.imageView setContentMode:UIViewContentModeScaleAspectFill];
            
            //添加进入 footerBar
            [self.footerBar addSubview:heji];
            [self.footerBar addSubview:_btn_confirm];
            
            self.myFooter.backgroundColor=RGB(237, 237, 237);
            [self.myView addSubview:_footerBar];
            self.myScrollView.delegate=self;
            self.myScrollView.bounces=NO;
            
        }else if([urlname isEqualToString:@"getAddress"]){
            NSArray *list=[dictemp objectForKey:@"data"];
            if (list.count==0) {
                [self loadAddressToXib];
                return;
            }
            NSArray *addressList=[AddressModel objectArrayWithKeyValuesArray:list];
            _selectedAddress=addressList[0];
            
            [self loadAddressToXib];
        
        }else if([urlname isEqualToString:@"addOrder"]){
            NSString *orderNo=[NSString stringWithFormat:@"%@",[dictemp objectForKey:@"data"]] ;
            ChoosePayController *detailViewController =[[ChoosePayController alloc] init];
            detailViewController.orderNo=orderNo;
            detailViewController.payAmount=_confirmOrderModel.all_info.all_amount;
            ConfirmPackage *package=_confirmOrderModel.list[0];
            ShoppingCartModel *shop = package.list[0];
            detailViewController.productName=shop.goods_detail.title;
            detailViewController.productDescription=@"暂无";
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            
            [self.navigationController pushViewController:detailViewController animated:YES];
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
}
#pragma mark - 事件方法
-(void)loadAddressToXib{
    [_addressButton removeFromSuperview];
    _addressButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];

    if (_selectedAddress==nil || [_selectedAddress isEqual:[NSNull null]]) {
        //左边图标
        UIButton *leftIcon=[[UIButton alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
        [leftIcon setImage:[UIImage imageNamed:@"icon_AddDiZhi"] forState:UIControlStateNormal];
        [_addressButton addSubview:leftIcon];
        //文字
        UILabel *leftText=[[UILabel alloc] initWithFrame:CGRectMake(45, 15, 100, 30)];
        leftText.text=@"请选择联系地址";
        leftText.font=[UIFont boldSystemFontOfSize:11];
        leftText.textColor=RGB(51, 51, 51);
        [_addressButton addSubview:leftText];
        
        //右边图标
        UIButton *rightIcon=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 30, 30)];
        [rightIcon setImage:[UIImage imageNamed:@"icon_Drop-rightList"] forState:UIControlStateNormal];
        [rightIcon addTarget:self action:@selector(gotoSelectAddress) forControlEvents:UIControlEventTouchUpInside];
        
        [_addressButton addSubview:rightIcon];
        
        
        [_addressButton addTarget:self action:@selector(gotoSelectAddress) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHeader addSubview:_addressButton];
    }else{
        //收货人
        UILabel *consigneeLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 8, 100, 20)];
        
        NSString *consignee=[NSString stringWithFormat:@"%@%@",@"收件人：",_selectedAddress.consignee];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:consignee];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:RGB(51, 51, 51)
         
                              range:NSMakeRange(0, 4)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:RGB(128, 128, 128)
         
                              range:NSMakeRange(4, consignee.length-4)];
    
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont boldSystemFontOfSize:11]
         
                              range:NSMakeRange(0, 4)];
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:11]
         
                              range:NSMakeRange(4, consignee.length-4)];
        
        consigneeLabel.attributedText=AttributedStr;
        
        [_addressButton addSubview:consigneeLabel];
        
        //电话
        UILabel *mobileLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 8, 100, 20)];
        mobileLabel.text=_selectedAddress.mobile;
        mobileLabel.font=[UIFont systemFontOfSize:11];
        mobileLabel.textColor=RGB(128, 128, 128);
        [_addressButton addSubview:mobileLabel];
        
        //地址
        UILabel *addressLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH-40, 30)];
        addressLabel.numberOfLines=2;
        
        NSString *addressString=[NSString stringWithFormat:@"%@%@%@",@"收货地址：",_selectedAddress.province,_selectedAddress.address];
        
        NSMutableAttributedString *AttributedStr_address = [[NSMutableAttributedString alloc]initWithString:addressString];
        
        [AttributedStr_address addAttribute:NSForegroundColorAttributeName
         
                              value:RGB(51, 51, 51)
         
                              range:NSMakeRange(0, 5)];
        [AttributedStr_address addAttribute:NSForegroundColorAttributeName
         
                              value:RGB(128, 128, 128)
         
                              range:NSMakeRange(5, addressString.length-5)];
        
        [AttributedStr_address addAttribute:NSFontAttributeName
         
                              value:[UIFont boldSystemFontOfSize:11]
         
                              range:NSMakeRange(0,5)];
        [AttributedStr_address addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:11]
         
                              range:NSMakeRange(5, addressString.length-5)];
        
        addressLabel.attributedText=AttributedStr_address;
        
        [_addressButton addSubview:addressLabel];

        //右边图标
        UIButton *rightIcon=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 15, 30, 30)];
        [rightIcon setImage:[UIImage imageNamed:@"icon_Drop-rightList"] forState:UIControlStateNormal];
        [rightIcon addTarget:self action:@selector(gotoSelectAddress) forControlEvents:UIControlEventTouchUpInside];
        [_addressButton addSubview:rightIcon];
        
        [_addressButton addTarget:self action:@selector(gotoSelectAddress) forControlEvents:UIControlEventTouchUpInside];
        
        [_myHeader addSubview:_addressButton];
        
    }

}

-(void)callTelephone{
    NSString *phoneNum = @"400-892-8080";// 电话号码
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !_phoneCallWebView ) {
        
        _phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
    }
    
    [_phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

-(void)confirmOrder:(UIButton *)sender{
    NSLog(@"----pass-confirmOrder%@---",@"confirmOrder");
    if (_selectedAddress==nil) {
        ShowMessage(@"请选择收货地址！");
        return;
    }
//    if ([_selectedAddress.idcard_status integerValue]!=1) {
//        ShowMessage(@"必须上传真实有效身份证信息，才能进行购买！");
//        return;
//    }
    [_timer setFireDate:[NSDate distantPast]];//开启
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_addOrder withType:POSTURL withPam:@{@"ids":_ids,@"address_id":_selectedAddress.id} withUrlName:@"addOrder"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
-(void)commitWait{
    
    if (_step==0) {
        _btn_confirm.enabled=YES;
        _step=30;
        
        [_timer setFireDate:[NSDate distantFuture]];//暂停
        [_btn_confirm setTitle:@"" forState:UIControlStateNormal];
        [_btn_confirm setBackgroundImage:[UIImage imageNamed:@"commitOrder"]  forState:UIControlStateNormal];
        [_btn_confirm setBackgroundColor:CLEARCOLOR];
    }else{
        _btn_confirm.enabled=NO;
        _step--;
        _btn_confirm.titleLabel.text=[NSString stringWithFormat:@"重新提交(%d)秒",_step];
        _btn_confirm.titleLabel.font=[UIFont systemFontOfSize:13];
        _btn_confirm.titleLabel.textColor=[UIColor whiteColor];
        [_btn_confirm setBackgroundColor:RGB(255, 13, 94)];
        [_btn_confirm setBackgroundImage:nil  forState:UIControlStateNormal];

        [_btn_confirm setTitle:[NSString stringWithFormat:@"重新提交(%d)秒",_step] forState:UIControlStateDisabled];
        [_btn_confirm setTitle:[NSString stringWithFormat:@"重新提交(%d)秒",_step] forState:UIControlStateNormal];
        
    }
    
    
}
-(void)showAmountDetail{
    if (_hejiView !=nil) {
        [self removeHejiView];
        return;
    }
    _hejiView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-47-64)];
    _hejiView.backgroundColor=CLEARCOLOR;
    UIButton *halfButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-47)];
    halfButton.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    [halfButton addTarget:self action:@selector(removeHejiView) forControlEvents:UIControlEventTouchUpInside];
    
    [_hejiView addSubview:halfButton];
    UIView *buttom_view=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-47, SCREEN_WIDTH, SCREEN_HEIGHT/2-64)];
    buttom_view.backgroundColor=[UIColor whiteColor];
    
    //商品价格
    UILabel *productLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    productLabel.text=@"商品价格";
    productLabel.font=[UIFont boldSystemFontOfSize:11];
    productLabel.textColor=RGB(51, 51, 51);
    
    [buttom_view addSubview:productLabel];
    //横线
    UILabel *jianju1=[[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 0.5)];
    jianju1.backgroundColor=RGB(237, 237, 237);
    [buttom_view addSubview:jianju1];
    
    //官网运费
    UILabel *guanwangLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 20)];
    guanwangLabel.text=@"官网运费";
    guanwangLabel.font=[UIFont boldSystemFontOfSize:11];
    guanwangLabel.textColor=RGB(51, 51, 51);
    
    [buttom_view addSubview:guanwangLabel];
    //横线
    UILabel *jianju2=[[UILabel alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 0.5)];
    jianju2.backgroundColor=RGB(237, 237, 237);
    [buttom_view addSubview:jianju2];
    
    
    //国际运费
    UILabel *guojiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 20)];
    guojiLabel.text=@"国际运费";
    guojiLabel.font=[UIFont boldSystemFontOfSize:11];
    guojiLabel.textColor=RGB(51, 51, 51);
    
    [buttom_view addSubview:guojiLabel];
    //横线
    UILabel *jianju3=[[UILabel alloc] initWithFrame:CGRectMake(0, 125, SCREEN_WIDTH, 0.5)];
    jianju3.backgroundColor=RGB(237, 237, 237);
    [buttom_view addSubview:jianju3];
    
    //预收税费
    UILabel *shuifeiLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 130, 100, 20)];
    shuifeiLabel.text=@"预收运费";
    shuifeiLabel.font=[UIFont boldSystemFontOfSize:11];
    shuifeiLabel.textColor=RGB(51, 51, 51);
    
    [buttom_view addSubview:shuifeiLabel];
    
    
    [_hejiView addSubview:buttom_view];

    [self.view addSubview:_hejiView];
    [self MoveView:_hejiView To:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-47-64) During:0.5];
    


}
-(void)removeHejiView{
    [_hejiView removeFromSuperview];
    _hejiView=nil;
}
-(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time{
    
    // 动画开始
    
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}


#pragma mark - 去地址列表选择地址
-(void)gotoSelectAddress{
    AddressListController *detailViewController =[[AddressListController alloc] init];
    
    detailViewController.addressListDelegate=self;
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}
-(void)selectedAddress:(AddressModel *)addressModel{
    _selectedAddress=addressModel;
    [self loadAddressToXib];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableView delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //内层header
    ConfirmPackage *package= _confirmOrderModel.list[section];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    
//    //包裹
//    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
//    head.text=[NSString stringWithFormat:@"包裹%ld",(long)section+1];
//    head.font =[UIFont  boldSystemFontOfSize:11];//加粗字体
//    head.textColor=RGB(255, 13, 94);
//    [view addSubview:head];
    //选择icon
    UIImageView *head=[[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 20, 20)];
    head.image=[UIImage imageNamed:@"Address_btn_selected"];
   
    [view addSubview:head];
    
    //国家icon
    UIImageView *country=[[UIImageView alloc] initWithFrame:CGRectMake(70, 9, 20, 20)];
    [country setImageWithURL:[NSURL URLWithString:package.all_info.country_flag] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    [view addSubview:country];
    
    //商城名称
    UILabel *shopname=[[UILabel alloc] initWithFrame:CGRectMake(105, 0, 70, 38)];
    shopname.text=package.all_info.shop_name;
    shopname.font =[UIFont  systemFontOfSize:10];
    shopname.textColor=RGB(179, 179, 179);
    [view addSubview:shopname];
    
    //直邮转运
    UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 38)];
    ship.text=package.all_info.ship_name;
    ship.font =[UIFont  boldSystemFontOfSize:11];
    ship.textAlignment=NSTextAlignmentRight;
    ship.textColor=RGB(51, 51, 51);
    [view addSubview:ship];
    
    
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    ConfirmPackage *package= _confirmOrderModel.list[section];
    //内层footer
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    
    //运费
    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
    head.text=@"运费:";
    head.font=[UIFont boldSystemFontOfSize:11];
    head.textColor=RGB(51, 51, 51);
    [view addSubview:head];
    
    //运费金额
    
    UILabel *ship=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 70, 20)];
    ship.text=[NSString stringWithFormat:@"¥%.2f",[package.all_info.ship_type integerValue]==1?package.all_info.all_direct_ship_show:package.all_info.all_transport_logistic_ship_show];
    ship.textAlignment=NSTextAlignmentRight;
    ship.font =[UIFont  boldSystemFontOfSize:11];
    ship.textColor=RGB(255, 13, 94);
    [view addSubview:ship];
    
    //预付税费 transport_amount
    UILabel *transport=[[UILabel alloc] initWithFrame:CGRectMake(10, 28, SCREEN_WIDTH/2, 20)];
    transport.text=@"预估税费:";
    transport.textColor=RGB(51, 51, 51);
    transport.font=[UIFont boldSystemFontOfSize:11];
    [view addSubview:transport];
    
    //预付税费金额
    UILabel *transport_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 28, 70, 20)];
    transport_amout.text=[NSString stringWithFormat:@"¥%.2f",[package.all_info.ship_type integerValue]==1?package.all_info.all_direct_tax:package.all_info.all_transport_tax];
    transport_amout.textAlignment=NSTextAlignmentRight;
    transport_amout.font =[UIFont  boldSystemFontOfSize:11];
    transport_amout.textColor=RGB(255, 13, 94);
    [view addSubview:transport_amout];
    
    UILabel *hengxian=[[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 0.5)];
    hengxian.backgroundColor=RGB(237, 237, 237);
    [view addSubview:hengxian];
    
    //小计
    UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-240, 53, 170, 20)];
    //        subTotal.text=@"小计:";
    subTotal.text=[NSString stringWithFormat:@"（包含运费，税费）合计："];
    subTotal.textAlignment=NSTextAlignmentRight;
    subTotal.font=[UIFont systemFontOfSize:11];
    subTotal.textColor=RGB(128, 128, 128);
    [view addSubview:subTotal];
    
    //小计金额
    UILabel *subTotal_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 53, 70, 20)];
    subTotal_amout.text=[NSString stringWithFormat:@"¥%.2f",package.all_info.amount];
    subTotal_amout.textAlignment=NSTextAlignmentRight;
    subTotal_amout.font =[UIFont  boldSystemFontOfSize:11];
    subTotal_amout.textColor=RGB(255, 13, 94);
    [view addSubview:subTotal_amout];
    
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    UILabel *jianju_footer=[[UILabel alloc] initWithFrame:CGRectMake(0, 76.5, SCREEN_WIDTH, 9.5)];
    jianju_footer.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju_footer];
    
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 90;//本身距离加间距
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _confirmOrderModel.list.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ConfirmPackage *package= _confirmOrderModel.list[section];
    return package.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"packagecell"];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    ConfirmPackage *package= _confirmOrderModel.list[indexPath.section];
    ShoppingCartModel *cartModel=package.list[indexPath.row];
    cell.textLabel.text = cartModel.goods_detail.title;
    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
    cell.textLabel.textColor=RGB(51, 51, 51);
    cell.textLabel.numberOfLines=2;
    //如果有规格 展示规格 只展示2条
    if (cartModel.goods_attr.count>0) {
        for (int i=0; i<cartModel.goods_attr.count; i++) {
            if (i>1) {
                break;
            }
            GoodsAttrModel *attr =cartModel.goods_attr[i];
            if (i==0) {
                cell.option1=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
                
                cell.option1.text=[NSString stringWithFormat:@"%@: %@",attr.attr_name,attr.attr_val_name];
                cell.option1.font=[UIFont boldSystemFontOfSize:11];
                cell.option1.textColor=RGB(128, 128, 128);
                [cell.contentView addSubview:cell.option1];
            }else{
                
                cell.option2=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 20)];
                
                cell.option2.text=[NSString stringWithFormat:@"%@: %@",attr.attr_name,attr.attr_val_name];
                cell.option2.font=[UIFont boldSystemFontOfSize:11];
                cell.option2.textColor=RGB(128, 128, 128);
                [cell.contentView addSubview:cell.option2];
            }
            
        }
        
    }
    New_Goods *goods= cartModel.goods_detail;
    //商品价格
    UILabel *goodPrice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.origin.y+10, 70, 20)];
    goodPrice.text=[NSString stringWithFormat:@"¥%.2f",goods.price_cn];
    goodPrice.textAlignment=NSTextAlignmentRight;
    goodPrice.font =[UIFont  boldSystemFontOfSize:11];
    goodPrice.textColor=RGB(255, 13, 94);
    [cell.contentView addSubview:goodPrice];
    
    //商品数量
    UILabel *goodnum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.origin.y+60, 70, 20)];
    goodnum.text=[NSString stringWithFormat:@"x %d",cartModel.buy_num];
    goodnum.textAlignment=NSTextAlignmentRight;
    goodnum.font =[UIFont  boldSystemFontOfSize:11];
    goodnum.textColor=RGB(128, 128, 128);
    [cell.contentView addSubview:goodnum];
    
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_80] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfirmPackage *package= _confirmOrderModel.list[indexPath.section];
    ShoppingCartModel *cartModel=package.list[indexPath.row];
    
    [self gotoGoodsDetail:cartModel.goods_detail.id];
}

-(void)gotoGoodsDetail:(NSString *) goods_id{
    NSDictionary *parameters = @{@"id":goods_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 1;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"优惠券";
            break;
        default:
            return @"";
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    
    switch (index) {
        case 0:
        {
            _couponView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
            _couponView.backgroundColor=[UIColor whiteColor];
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 70, 100, 20)];
            label.textColor=RGB(128, 128, 128);
            label.text=@"暂无相关消息";
            label.font=[UIFont systemFontOfSize:11];
            [_couponView addSubview:label];
            return _couponView;
            break;
        }
            default:
            break;
            
    }
    
    return nil;
}


// Optional Methods

-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor whiteColor];
}


-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return RGB(128, 128, 128);
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return RGB(255, 13, 94);
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollViewDidScroll");
    CGPoint point=scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
    // 从中可以读取contentOffset属性以确定其滚动到的位置。
    
    // 注意：当ContentSize属性小于Frame时，将不会出发滚动
    
    CGRect rect= self.footerBar.frame;
    self.footerBar.frame=CGRectMake(rect.origin.x, SCREEN_HEIGHT-64-47+point.y, rect.size.width, rect.size.height);
    
    
}

@end
