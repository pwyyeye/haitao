//
//  HTShopStoreCarViewController.m
//  haitao
//
//  Created by SEM on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTShopStoreCarViewController.h"

#import "FCShoppingCell.h"
#import "WCAlertView.h"
#import "CarShopInfoModel.h"
#import "New_Goods.h"
#import "ChooseSizeViewController.h"
#import "ConfirmOrderController.h"
@interface HTShopStoreCarViewController ()<ChooseSizeDelegate>
{
    float _price;
    NSMutableArray *carShopList;
    NSMutableArray *delShopList;
    NSMutableArray *modifyList;
    UIButton*btnDD;
    UIButton *allCheckBtn;
    UILabel *price_count_label;//合计数值
    UILabel *heji_label;//合计
    UIButton *jiesuanBtn;//结算
    UIButton *shanchuBtn;//删除
    CarShopInfoModel *carShopInfoRow;
    NSIndexPath *indexRow;
    int shuaxinCount;
}

@end

@implementation HTShopStoreCarViewController


-(id)initWithTabbar:(BOOL)isTabbar
{
    self=[super init];
    if (self)
    {
        _isTabbar=isTabbar;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    carShopList =[[NSMutableArray alloc]init];
    delShopList=[[NSMutableArray alloc]init];
    modifyList=[[NSMutableArray alloc]init];
    _price=0.0;
    
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self getNavigationBar];
    //    if (_marrayAll.count<=0)
    //    {
    //        UIImageView *car=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-52)/2, view_bar.frame.size.height+60, 52, 48)];
    //        car.image=BundleImage(@"gwc@2x_03.png");
    //        [self.view addSubview:car];
    //        [car release];
    //        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200/2, car.frame.size.height+car.frame.origin.y+5, 200, 20)];
    //        label.text=@"购物车还是空的";
    //        label.font=[UIFont systemFontOfSize:16];
    //        label.textAlignment=1;
    //        label.textColor=hui2;
    //        [self.view addSubview:label];
    //
    //        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-200/2, label.frame.size.height+label.frame.origin.y+5, 200, 20)];
    //        label1.text=@"去选几件喜欢的商品吧";
    //        label1.font=[UIFont systemFontOfSize:11];
    //        label1.textAlignment=1;
    //        label1.textColor=hui5;
    //        [self.view addSubview:label1];
    //
    //        UIButton *btn=[UIButton buttonWithType:0];
    //        btn.frame=CGRectMake((self.view.frame.size.width-90)/2, label1.frame.size.height+label1.frame.origin.y+30, 90, 29);
    //        [btn setImage:BundleImage(@"gwc_gg.png") forState:0];
    //        [btn addTarget:self action:@selector(btnShopping:) forControlEvents:UIControlEventTouchUpInside];
    //        [self.view addSubview:btn];
    //
    //
    //    }else{
    
    //    }
    [self getCarInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [delShopList removeAllObjects];
    [self addViews];
    [self getToolBar];
    //获取购物车数据
}
#pragma mark获取购物车数据
-(void)getCarInfo{
    [carShopList removeAllObjects];
    [modifyList removeAllObjects];
    [delShopList removeAllObjects];
    NSString* url =[NSString stringWithFormat:@"%@&f=getCart&m=cart",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getCart"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSNumber *status=[dictemp objectForKey:@"status"];
    if([urlname isEqualToString:@"getCart"]){
        if(status.intValue==1){
            NSArray *dataArr=[dictemp objectForKey:@"data"];
            for (NSDictionary *dic1 in dataArr) {
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                
                NSArray *listArr=[dic1 objectForKey:@"list"];
                NSMutableArray *addList=[[NSMutableArray alloc]init];
                for (NSDictionary *listDic in listArr) {
                    CarShopInfoModel *carShopInfoModel= [CarShopInfoModel objectWithKeyValues:listDic] ;
                    carShopInfoModel.change_attr_price_id=carShopInfoModel.attr_price_id;
                    carShopInfoModel.change_buy_num=carShopInfoModel.buy_num;
                    carShopInfoModel.ischoose=false;
                    [addList addObject:carShopInfoModel];
                    NSString *listId=[carShopInfoModel.id mutableCopy];
                    NSString *buy_num=[carShopInfoModel.buy_num mutableCopy];
                    NSString *attr_price_id=[carShopInfoModel.attr_price_id mutableCopy];
                    NSMutableDictionary *modifDic=[[NSMutableDictionary alloc]init];
                    [modifDic setObject:listId forKey:@"id"];
                    [modifDic setObject:attr_price_id forKey:@"attr_price_id"];
                    [modifDic setObject:buy_num forKey:@"buy_num"];
                    [modifyList addObject:modifDic];
                }
                
                NSDictionary *allInfoDic=[dic1 objectForKey:@"all_info"];
                ShopInfoModel *shopInfoModel= [ShopInfoModel objectWithKeyValues:allInfoDic] ;
                [dicTemp setObject:shopInfoModel forKey:@"all_info"];
                [dicTemp setObject:addList forKey:@"list"];
                [carShopList addObject:dicTemp];
                
                
            }
            [_tableView reloadData];
        }else{
            ShowMessage(@"获取购物车数据失败!");
        }
    }
    if([urlname isEqualToString:@"getGoodsAttrValueById"]){
        if(status.intValue==1){
            NSDictionary *goods_attr=[dictemp objectForKey:@"data"];
            ChooseSizeViewController *chooseSizeViewController=[[ChooseSizeViewController alloc]init];
            chooseSizeViewController.goods_attr=goods_attr;
            chooseSizeViewController.goods=carShopInfoRow.goods_detail;
            chooseSizeViewController.delegate=self;
            chooseSizeViewController.ischange=true;
            chooseSizeViewController.numCount=carShopInfoRow.change_buy_num;
            AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
            [app.navigationController pushViewController:chooseSizeViewController animated:YES];
        }else{
            ShowMessage(@"获取商品规格失败!");
        }
    }
    if([urlname isEqualToString:@"delCart"]){
        shuaxinCount--;
        if(shuaxinCount==0){
            AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
            [app stopLoading];
            [self getCarInfo];
        }
        
    }
    if([urlname isEqualToString:@"modifyCart"]){
        shuaxinCount--;
        if(shuaxinCount==0){
            AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
            [app stopLoading];
            [self getCarInfo];
        }
        
    }
    
}
#pragma mark添加tableView
-(void)addViews
{
    
    if (_isTabbar==YES)
    {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, view_bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-view_bar.frame.size.height-50-49)style:UITableViewStylePlain];
    }else{
        
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, view_bar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-view_bar.frame.size.height-50)style:UITableViewStylePlain];
    }
    
    _tableView.userInteractionEnabled=YES;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    //    self.view.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    [self.view addSubview:_tableView];
}
#pragma mark添加导航栏
-(UIView*)getNavigationBar
{
    view_bar =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
        [view_bar addSubview:imageV];

        
    }else{
        view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44);
        UIImageView *imageV = [[UIImageView alloc]initWithImage:BundleImage(@"top.png")];
        [view_bar addSubview:imageV];
    
    }
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"购物车";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar addSubview:title_label];
    
    
    
    
    UIImageView*leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, (44-37)/2, 2,37)];
    leftImageView.image=BundleImage(@"navigation_bar_line.png");
    [view_bar addSubview:leftImageView];
    
    [self.view addSubview:view_bar];
    
 
    btnDD=[UIButton buttonWithType:0];
    btnDD.frame=CGRectMake(self.view.frame.size.width-60, view_bar.frame.size.height-44, 54, 44);
    [btnDD setTitleColor:[UIColor whiteColor] forState:0];
    [btnDD setTitle:@"编辑" forState:UIControlStateNormal];
    [btnDD setTitle:@"完成" forState:UIControlStateSelected];
    btnDD.titleLabel.textColor=[UIColor whiteColor];
    [btnDD addTarget:self action:@selector(editCell:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:btnDD];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"left_grey.png") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:btnBack];

    if (_isTabbar==YES)
    {
        
           btnBack.hidden=YES;
    }
    
    
    return view_bar;
}
#pragma mark编辑按钮
-(void)editCell:(UIButton*)sender
{
    [sender setSelected:!sender.isSelected];
    for (NSDictionary *dicTemp in carShopList) {
        ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];
        shopInfoModel.ischoose=false;
        NSArray *listContent=[dicTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            carShopInfoModel.ischoose=false;
        }
    }
    [self changePrice];
    if(sender.isSelected){
        [self changeToolBar:true];
        [_tableView reloadData];
    }else{
        [self editSave];
        [self changeToolBar:false];
        
//        [_tableView reloadData];
    }
}


#pragma mark暂留
-(void)btnHome:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
}
#pragma mark后退
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
-(void)btnShopping:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
    
}
#pragma mark结算菜单栏
-(UIView *)getToolBar
{
    if (_isTabbar==YES)
    {
        view_toolBar =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49-49, self.view.frame.size.width, 49)];
        
    }else{
        
        view_toolBar =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
        
    }
    //菜单
    view_toolBar.backgroundColor=[UIColor whiteColor];
    view_toolBar.layer.borderColor=[UIColor colorWithRed:.9 green:.9  blue:.9  alpha:1.0].CGColor;
    view_toolBar.layer.borderWidth=1;
    [self.view addSubview:view_toolBar];
    //全选按钮
    //(8, 10, 40, 30);
    allCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allCheckBtn setFrame:CGRectMake(1.0, view_toolBar.frame.size.height/2-20, 40, 40)];
    [allCheckBtn setBackgroundImage:[UIImage imageNamed:@"ic_01_n_.png"] forState:UIControlStateNormal];
    [allCheckBtn setBackgroundImage:[UIImage imageNamed:@"ic_01_h_.png"] forState:UIControlStateSelected];
    [allCheckBtn addTarget:self action:@selector(checkButtonALL:event:) forControlEvents:UIControlEventTouchUpInside];
    [allCheckBtn setSelected:false];
    
    
    UILabel *all_label=[[UILabel alloc]initWithFrame:CGRectMake(allCheckBtn.frame.size.width+allCheckBtn.frame.origin.x, view_toolBar.frame.size.height/2-7.5, 40, 15)];
    all_label.text=@"全选";
    all_label.font=[UIFont boldSystemFontOfSize:12];
    all_label.backgroundColor=[UIColor clearColor];
    all_label.textColor =hui2;
    all_label.textAlignment=1;
    
    [view_toolBar addSubview:all_label];
    [view_toolBar addSubview:allCheckBtn];
    heji_label=[[UILabel alloc]initWithFrame:CGRectMake(all_label.frame.size.width+all_label.frame.origin.x+10, 15, 38, 20)];
    heji_label.text=@"合计:";
    heji_label.font=[UIFont boldSystemFontOfSize:16];
    heji_label.backgroundColor=[UIColor clearColor];
    heji_label.textColor =hongShe;
    heji_label.textAlignment=1;
    [view_toolBar addSubview:heji_label];
    
    price_count_label=[[UILabel alloc]initWithFrame:CGRectMake(heji_label.frame.size.width+heji_label.frame.origin.x, 15, 75, 20)];
    price_count_label.text=[NSString stringWithFormat:@"￥%.2f",_price];
    price_count_label.font=[UIFont boldSystemFontOfSize:16];
    price_count_label.backgroundColor=[UIColor clearColor];
    price_count_label.textColor =hongShe;
    price_count_label.textAlignment=0;
    [view_toolBar addSubview:price_count_label];
    
    jiesuanBtn=[UIButton buttonWithType:0];
    jiesuanBtn.frame=CGRectMake(view_toolBar.frame.size.width-95, 10, 85, 30);
    //    acountBtn1.layer.borderWidth=1;
    //    acountBtn1.layer.borderColor=hui8Cg;
    //    acountBtn1.layer.cornerRadius = 4;
    jiesuanBtn.titleLabel.font=[UIFont systemFontOfSize:10];
    [jiesuanBtn setImage:BundleImage(@"ic_02_n_.png") forState:0];
    [jiesuanBtn setTitleColor:[UIColor grayColor] forState:0];
    [jiesuanBtn addTarget:self action:@selector(accountBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view_toolBar addSubview:jiesuanBtn];
    
    //删除按钮
    shanchuBtn=[UIButton buttonWithType:0];
    shanchuBtn.frame=CGRectMake(view_toolBar.frame.size.width-115,7, 85, 30);
    [shanchuBtn setTitleColor:[UIColor blackColor] forState:0];
    [shanchuBtn setTitle:@"删除" forState:UIControlStateNormal];
    shanchuBtn.titleLabel.textColor=[UIColor whiteColor];
    [shanchuBtn addTarget:self action:@selector(shanchu:) forControlEvents:UIControlEventTouchUpInside];
    [shanchuBtn.layer setMasksToBounds:YES];
    [shanchuBtn.layer setCornerRadius:8.0]; //设置矩圆角半径
    [shanchuBtn.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.2, 0.2,0.2, 1 });
    [shanchuBtn.layer setBorderColor:colorref];
    
    shanchuBtn.hidden=true;
    [view_toolBar addSubview:shanchuBtn];
    
    return view_toolBar;
}
#pragma mark变化底部工具栏
-(void)changeToolBar:(BOOL)isflag{
    if(isflag){
        shanchuBtn.hidden=false;
//       [view_toolBar bringSubviewToFront:shanchuBtn];
        price_count_label.hidden=true;//合计数值
        heji_label.hidden=true;//合计
        jiesuanBtn.hidden=true;//结算
    }else{
        shanchuBtn.hidden=true;
        price_count_label.hidden=false;//合计数值
        heji_label.hidden=false;//合计
        jiesuanBtn.hidden=false;//结算
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dicTemp= [carShopList objectAtIndex:section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    return listContent.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return carShopList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dicTemp= [carShopList objectAtIndex:section];
    ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];

    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,35 )];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(1.0, 0.0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_01_n_.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_01_h_.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(checkButtonSection:event:) forControlEvents:UIControlEventTouchUpInside];
    [button setSelected:shopInfoModel.ischoose];
    button.tag=section;
    [view1 addSubview:button];
    
    //国籍
    
    UILabel *countryLabel=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.origin.x+button.frame.size.height+5,10 , 100, 20)];
    NSString *country_nameStr=shopInfoModel.country_name;
    countryLabel.font=[UIFont systemFontOfSize:12];
    countryLabel.backgroundColor=[UIColor clearColor];
    countryLabel.textColor =hui5;
    countryLabel.textAlignment=0;
    CGSize theStringSize = [country_nameStr sizeWithFont:[UIFont systemFontOfSize:12]
                               constrainedToSize:countryLabel.frame.size
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    //Adjust the size of the UILable
    countryLabel.frame = CGRectMake(countryLabel.frame.origin.x,
                                countryLabel.frame.origin.y,
                                theStringSize.width,countryLabel.frame.size.height);
    countryLabel.text = country_nameStr;
     [view1 addSubview:countryLabel];
    //商城
    UILabel *shopNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(countryLabel.frame.origin.x+countryLabel.frame.size.width+10, countryLabel.frame.origin.y, 200, 20)];
    shopNameLabel.text=shopInfoModel.shop_name;
    shopNameLabel.font=[UIFont systemFontOfSize:12];
    shopNameLabel.backgroundColor=[UIColor clearColor];
    shopNameLabel.textColor =hui5;
    shopNameLabel.textAlignment=0;
    [view1 addSubview:shopNameLabel];
       return view1;

}
- (FCShoppingCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cate_cell";
    
    FCShoppingCell*   cell =nil;
    
    if (cell == nil) {
        
        cell = [[FCShoppingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.editingAccessoryType=UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selected=NO;
        
    }
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexPath.section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    CarShopInfoModel *carShopInfoModel= [listContent objectAtIndex:indexPath.row] ;
    //左侧按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0.0, 20.0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_01_n_.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"ic_01_h_.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    [button setSelected:carShopInfoModel.ischoose];
    [cell addSubview:button];
        //图片
    
    UrlImageView *imgView=[[UrlImageView alloc]initWithFrame:CGRectMake(40, 3, 60,90)];
    
    //        if ([[[[_marrayAll objectAtIndex:indexPath.row]productList]objectAtIndex:0] icon]==nil)
    //        {
    New_Goods *newGoods=carShopInfoModel.goods_detail;
    NSArray *goods_attrList=carShopInfoModel.goods_attr;
    if(newGoods.img_80){
        [imgView setImageWithURL:[NSURL URLWithString:newGoods.img_80]];
    }else{
        imgView.image=[UIImage imageNamed:@"df_01_.png"];
    }
    [cell addSubview:imgView];
    
    
    
    //商品正常显示页面
    if(!btnDD.isSelected){
        cell.showView=[[UIView alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width, 3, SCREEN_WIDTH-imgView.frame.origin.x-imgView.frame.size.width, 90)];
        
        [cell addSubview:cell.showView];
        
        //title
        UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(0,15, cell.showView.frame.size.width-55, 30)];
        title.backgroundColor=[UIColor clearColor];
        title.textAlignment=0;
        title.numberOfLines=2;
        title.text=newGoods.title;
        title.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title.font=[UIFont systemFontOfSize:12];
        [cell.showView addSubview:title];
        //颜色尺寸参数
        
        CGRect lastFrame;
        for (int i=0; i<goods_attrList.count; i++) {
            NSDictionary *carShopDic=goods_attrList[i];
            UILabel*labelColor=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*(cell.showView.frame.size.width-2-55)/2+2, title.frame.origin.y+title.frame.size.height+20, (cell.showView.frame.size.width-2-55)/2, 20)];
            labelColor.textAlignment=0;
            labelColor.font=[UIFont systemFontOfSize:10];
            labelColor.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
            NSString *attr_name=[carShopDic objectForKey:@"attr_name"];
            NSString *attr_val_name=[carShopDic objectForKey:@"attr_val_name"];
            labelColor.text=[NSString stringWithFormat:@"%@:%@",attr_name,attr_val_name];
            
            labelColor.backgroundColor=[UIColor clearColor];
            lastFrame=labelColor.frame;
            [cell.showView  addSubview:labelColor];
        }
        //价格
        UILabel*labelPrice=[[UILabel alloc]initWithFrame:CGRectMake((cell.showView.frame.size.width-55), cell.showView.frame.size.height/2-10, 55, 20)];
        labelPrice.textAlignment=0;
        labelPrice.font=[UIFont systemFontOfSize:10];
        labelPrice.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        NSString *priceTemp=[NSString stringWithFormat:@"%.f",newGoods.price_cn];
        labelPrice.text=[NSString stringWithFormat:@"￥%@",priceTemp];
        
        labelPrice.backgroundColor=[UIColor clearColor];
        [cell.showView  addSubview:labelPrice];
        //商品数量
        UILabel*labelCount=[[UILabel alloc]initWithFrame:CGRectMake((cell.showView.frame.size.width-55), title.frame.origin.y+title.frame.size.height+20, 55, 20)];
        labelCount.textAlignment=0;
        labelCount.font=[UIFont systemFontOfSize:10];
        labelCount.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        NSString *buy_num=carShopInfoModel.buy_num;
        labelCount.text=[NSString stringWithFormat:@"×%@",buy_num];
        
        labelCount.backgroundColor=[UIColor clearColor];
        [cell.showView  addSubview:labelCount];

    }else{
        cell.editView=[[UIView alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width, 0, SCREEN_WIDTH-imgView.frame.origin.x-imgView.frame.size.width, 90)];
        
        [cell addSubview:cell.editView];
        //减按钮
        UIButton *btnCut=[UIButton buttonWithType:0];
        btnCut.frame=CGRectMake(0, cell.editView.frame.size.height/2-35/2, 35, 35);
        btnCut.tag=indexPath.row;
        [btnCut setImage:BundleImage(@"bt_01_.png") forState:0];
        [btnCut addTarget:self action:@selector(btnCut:event:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.editView addSubview:btnCut];
        
        UILabel*  numTextField=[[UILabel alloc]initWithFrame:CGRectMake(btnCut.frame.size.width+btnCut.frame.origin.x+1, btnCut.frame.origin.y+3,29,28)];
        numTextField.textAlignment=1;
        numTextField.font=[UIFont systemFontOfSize:14];
        numTextField.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        NSString *buy_num=carShopInfoModel.change_buy_num;
        numTextField.text=buy_num;
        numTextField.tag=101;
        numTextField.backgroundColor=[UIColor clearColor];
        [cell.editView addSubview:numTextField];
        
        
        //加
        UIButton *btnAdd=[UIButton buttonWithType:0];
        btnAdd.frame=CGRectMake(numTextField.frame.origin.x+numTextField.frame.size.width+3,btnCut.frame.origin.y+3, 30, 28);
        [btnAdd setBackgroundImage:BundleImage(@"bt_02_.png") forState:0];
        [btnAdd addTarget:self action:@selector(btnAdd:event:) forControlEvents:UIControlEventTouchUpInside];
        if (btnAdd.highlighted) {
            [btnAdd setBackgroundImage:BundleImage(@"number_up_click.png") forState:0];
        }
        [cell.editView addSubview:btnAdd];
        //属性按钮
        if(goods_attrList){
            NSMutableString *ssAddStr=[[NSMutableString alloc]init];
            
            for (int i=0; i<goods_attrList.count; i++) {
                NSDictionary *carShopDic=goods_attrList[i];
                NSString *attr_name=[carShopDic objectForKey:@"attr_name"];
                NSString *attr_val_name=[carShopDic objectForKey:@"attr_val_name"];
                NSString *attStemp= [NSString stringWithFormat:@"%@:%@",attr_name,attr_val_name];
                [ssAddStr appendString:attStemp];
                if(i!=goods_attrList.count-1){
                    [ssAddStr appendString:@"\n"];
                }
            }
            UIButton *shopTypeBtn=[UIButton buttonWithType:0];
            shopTypeBtn.frame=CGRectMake(btnAdd.frame.origin.x+btnAdd.frame.size.width+5,cell.editView.frame.size.height/2-44/2, cell.editView.frame.size.width-(btnAdd.frame.origin.x+btnAdd.frame.size.width+5)-10, 44);
            [shopTypeBtn setTitleColor:[UIColor blackColor] forState:0];
            shopTypeBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            shopTypeBtn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
            [shopTypeBtn setTitle: ssAddStr forState: UIControlStateNormal];
            //        shopTypeBtn.titleLabel.textColor=[UIColor whiteColor];- (void)checkButtonTapped:(UIButton *)sender event:(id)event
            [shopTypeBtn addTarget:self action:@selector(changeAttrId:event:) forControlEvents:UIControlEventTouchUpInside];
            [shopTypeBtn.layer setMasksToBounds:YES];
            [shopTypeBtn.layer setCornerRadius:8.0]; //设置矩圆角半径
            [shopTypeBtn.layer setBorderWidth:1.0];   //边框宽度
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.2, 0.2,0.2, 1 });
            [shopTypeBtn.layer setBorderColor:colorref];//边框颜色
            [cell.editView addSubview:shopTypeBtn];
        }
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return 96;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark 结算按钮
-(void)accountBtn:(id)sender
{
    NSMutableArray *jiesuanCarArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dicTemp in carShopList) {
        NSArray *listContent=[dicTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            if(carShopInfoModel.ischoose){
                [jiesuanCarArr addObject:carShopInfoModel];
            }
        }
        
    }

    if ([jiesuanCarArr count]<=0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选中任何商品！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    else {
        NSMutableString *ss=[[NSMutableString alloc]init];
        for (int i=0; i<jiesuanCarArr.count; i++) {
            CarShopInfoModel *carShopInfoModel=jiesuanCarArr[i];
            NSString *sid=carShopInfoModel.id;
            [ss appendString:sid];
            if(i!=jiesuanCarArr.count-1){
                [ss appendString:@","];
            }
        }
        
        ConfirmOrderController *detailViewController =[[ConfirmOrderController alloc] initWithNibName:@"ConfirmOrderController" bundle:nil];
        detailViewController.ids=ss;
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
    }
    
}

#pragma mark数量减

//两个按钮 是同时对一个textfiled操作，所以把tag设为同样的。
//最小为1//- (void)checkButtonTapped:(UIButton *)sender event:(id)event
-(void)btnCut:(UIButton *)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexPath.section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    
    CarShopInfoModel *carShopInfoModel= [listContent objectAtIndex:indexPath.row] ;
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:indexPath];
    UILabel*field=(UILabel* )[cell viewWithTag:101];
    if ([field.text intValue]>1) {
        field.text=[NSString stringWithFormat:@"%d",[field.text intValue]-1];
    }
    carShopInfoModel.change_buy_num=field.text;
}

#pragma mark数量加
-(void)btnAdd:(UIButton *)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexPath.section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    
    CarShopInfoModel *carShopInfoModel= [listContent objectAtIndex:indexPath.row] ;
    UITableViewCell *cell=[_tableView cellForRowAtIndexPath:indexPath];
    UILabel*field=(UILabel* )[cell viewWithTag:101];
    
    if(field.text.intValue<10000)
    {
        field.text=[NSString stringWithFormat:@"%d",[field.text intValue]+1];
    }else if(field.text.intValue==10000)
    {
        ShowMessage(@"当前为库存最大值");
    }
    carShopInfoModel.change_buy_num=field.text;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark 选择按钮事件row
- (void)checkButtonTapped:(UIButton *)sender event:(id)event
{
    sender.selected=!sender.selected;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexPath.section];
    ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    
    CarShopInfoModel *carShopInfoModel= [listContent objectAtIndex:indexPath.row] ;
    carShopInfoModel.ischoose=!carShopInfoModel.ischoose;
    BOOL allsectionChoose=true;
    BOOL allChoose=true;
    for (CarShopInfoModel *carShopInfoModel in listContent) {
        if(!carShopInfoModel.ischoose){
            allsectionChoose=false;
            break;
        }
    }
    if(allsectionChoose){
        shopInfoModel.ischoose=true;
        
    }else{
        shopInfoModel.ischoose=false;
    }
    
    //判断是否全选
    for (NSDictionary *dicAllTemp in carShopList) {
        
        NSArray *listAllContent=[dicAllTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModelTemp in listAllContent) {
            if(!carShopInfoModelTemp.ischoose){
                allChoose=false;
                break;

            }
        }
    }
    if(allChoose){
        [allCheckBtn setSelected:true];
    }else{
        [allCheckBtn setSelected:false];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self changePrice];
}
#pragma mark 选择按钮事件section
- (void)checkButtonSection:(UIButton *)sender event:(id)event
{
    
    NSDictionary *dicTemp= [carShopList objectAtIndex:sender.tag];
    ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];
    shopInfoModel.ischoose=!shopInfoModel.ischoose;
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    
    if(shopInfoModel.ischoose){
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            carShopInfoModel.ischoose=true;
        }
    }else{
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            carShopInfoModel.ischoose=false;
        }
    }
    //判断是否全选
    BOOL allChoose=true;
    for (NSDictionary *dicAllTemp in carShopList) {
        
        NSArray *listAllContent=[dicAllTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModelTemp in listAllContent) {
            if(!carShopInfoModelTemp.ischoose){
                allChoose=false;
                break;
                
            }
        }
    }
    if(allChoose){
        [allCheckBtn setSelected:true];
    }else{
        [allCheckBtn setSelected:false];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sender.tag];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self changePrice];
}

#pragma mark全选
- (void)checkButtonALL:(UIButton *)sender event:(id)event
{
    [sender setSelected:!sender.selected];
    if(sender.selected){
        for (NSDictionary *dicTemp in carShopList) {
            
            ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];
            shopInfoModel.ischoose=true;
            NSArray *listContent=[dicTemp objectForKey:@"list"];
            for (CarShopInfoModel *carShopInfoModel in listContent) {
                carShopInfoModel.ischoose=true;
            }
        }
        
    }else{
        for (NSDictionary *dicTemp in carShopList) {
            ShopInfoModel *shopInfoModel=[dicTemp objectForKey:@"all_info"];
            shopInfoModel.ischoose=false;
            NSArray *listContent=[dicTemp objectForKey:@"list"];
            for (CarShopInfoModel *carShopInfoModel in listContent) {
                carShopInfoModel.ischoose=false;
            }
        }
    }
    [_tableView reloadData];
    [self changePrice];
}
#pragma mark 计算金额
-(void)changePrice{
    _price=0;
    for (NSDictionary *dicTemp in carShopList) {
        NSArray *listContent=[dicTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            if(carShopInfoModel.ischoose){
                New_Goods *goods_detailTemp=carShopInfoModel.goods_detail;
                _price+=goods_detailTemp.price_cn;
            }
        }
        
    }
    price_count_label.text=[NSString stringWithFormat:@"￥%.2f",_price];

}
#pragma mark删除按钮
-(void)shanchu:(UIButton *)sender{
    NSMutableArray *delCarArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dicTemp in carShopList) {
        NSArray *listContent=[dicTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            if(carShopInfoModel.ischoose){
                [delCarArr addObject:carShopInfoModel];
            }
        }
        
    }
    shuaxinCount=0;
    if(delCarArr.count>0){
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app startLoading];
        shuaxinCount=(int)delCarArr.count;
        for (CarShopInfoModel *carShopInfoModel in delCarArr) {
            NSDictionary *parameters = @{@"id":carShopInfoModel.id};
            NSString* url =[NSString stringWithFormat:@"%@&f=delCart&m=cart",requestUrl]
            ;
            
            HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"delCart"];
            httpController.delegate = self;
            [httpController onSearchForPostJson];
        }
    }
}
#pragma mark查看修改的东西
-(void)editSave{
    NSMutableArray *modifyCarArr=[[NSMutableArray alloc]init];
    for (NSDictionary *dicTemp in carShopList) {
        NSArray *listContent=[dicTemp objectForKey:@"list"];
        for (CarShopInfoModel *carShopInfoModel in listContent) {
            NSString *change_attr_price_id=carShopInfoModel.change_attr_price_id;
            NSString *change_buy_num=carShopInfoModel.change_buy_num;
            NSString *attr_price_id=carShopInfoModel.attr_price_id;
            NSString *buy_num=carShopInfoModel.buy_num;
            BOOL isModidy=false;
            if(![change_attr_price_id isEqualToString:attr_price_id]||![change_buy_num isEqualToString:buy_num]){
                isModidy=true;
            }
            if(isModidy){
                [modifyCarArr addObject:carShopInfoModel];
            }
        }
        
    }
    shuaxinCount=0;
    if(modifyCarArr.count>0){
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app startLoading];
        shuaxinCount=(int)modifyCarArr.count;
        for (CarShopInfoModel *carShopInfoModel in modifyCarArr) {
            NSDictionary *parameters = @{@"id":carShopInfoModel.id,@"buy_num":carShopInfoModel.change_buy_num,@"attr_price_id":carShopInfoModel.change_attr_price_id};
            NSString* url =[NSString stringWithFormat:@"%@&f=modifyCart&m=cart",requestUrl]
            ;
            
            HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"modifyCart"];
            httpController.delegate = self;
            [httpController onSearchForPostJson];
        }
    }else{
        [_tableView reloadData];
    }

}

#pragma mark 改变颜色尺寸等参数
- (void)changeAttrId:(UIButton *)sender event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint: currentTouchPosition];
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexPath.section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];

    carShopInfoRow= [listContent objectAtIndex:indexPath.row] ;
    indexRow=indexPath;
    [self getGoodsAttrValueById];
}
#pragma mark查找规格
-(void)getGoodsAttrValueById{
    New_Goods *goodsTemp=carShopInfoRow.goods_detail;
    NSDictionary *parameters = @{@"id":goodsTemp.id};
    NSString* url =[NSString stringWithFormat:@"%@&f=getGoodsAttrValueById&m=goods",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsAttrValueById"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
#pragma mark改变尺寸代理
- (void)addShopCarFinsh:(NSDictionary *)dic{
    NSDictionary *dicTemp= [carShopList objectAtIndex:indexRow.section];
    NSArray *listContent=[dicTemp objectForKey:@"list"];
    
    CarShopInfoModel *carShopInfoModel= [listContent objectAtIndex:indexRow.row] ;
    carShopInfoModel.change_buy_num=[dic objectForKey:@"buy_num"];
    carShopInfoModel.change_attr_price_id=[dic objectForKey:@"attr_price_id"];
    carShopInfoModel.goods_attr=[dic objectForKey:@"goods_attr"];
    [_tableView reloadRowsAtIndexPaths:@[indexRow] withRowAnimation:UITableViewRowAnimationNone];
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
