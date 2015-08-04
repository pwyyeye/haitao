//
//  CustomViewController.m
//  haitao
//
//  Created by SEM on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "CustomViewController.h"
#import "New_Goods.h"
#import "App_Home_Bigegg.h"
#import "EScrollerView.h"
#import "screenViewController.h"
#import "CFContentViewController.h"
#import "GoodImageButton.h"
#import "HTGoodDetailsViewController.h"
@interface CustomViewController ()<EScrollerViewDelegate>
{
    UITableView                 *_tableView;
    UrlImageView *imageV;
    UIView *view_bar1;
    UIButton*btnItem1; //上部五个按钮
    UIButton*btnItem2;
    UIButton*btnItem3;
    UIButton*btnItem4;
    UIButton*btnItem5;
    UIImageView*  tabBarArrow;//上部桔红线条
    NSDictionary *indexDic;
    NSMutableArray *bannerArr;
}

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    title=@"";
    bannerArr =[[NSMutableArray alloc]initWithCapacity:8];
    _tableView =[[UITableView alloc]initWithFrame:self.mainFrame style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    [self.view addSubview:_tableView];
    
    listArr=[[NSMutableArray alloc]init];
    
    [self getCatBanner];
}
-(void)getCatBanner{
    //NSDictionary *parameters = @{@"cat_id":self.menuModel.id};
    NSDictionary *parameters = @{@"cat_id":@"1"};
    NSString* url =[NSString stringWithFormat:@"%@&m=ad&f=getCatBanner",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getCatBanner"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}

-(void)getGoodsList{
    NSDictionary *parameters = @{@"f_cat":self.menuModel.id,@"need_cat_index":@1};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}

#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"getCatBanner"]){
        [bannerArr removeAllObjects];
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        
        for (NSDictionary *dic in dataArr) {
            App_Home_Bigegg *app_Home_Bigegg = [App_Home_Bigegg objectWithKeyValues:dic] ;
            [bannerArr addObject:app_Home_Bigegg];
        }
        [self getGoodsList];
    }
    
    if([urlname isEqualToString:@"getGoodsList"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSArray *goodsArr=[dataDic objectForKey:@"list"];
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        [self getGoodlistTwo:goodsModelArr];
        indexDic=[dataDic objectForKey:@"cat_index"];
        [_tableView reloadData];
    }
    if([urlname isEqualToString:@"getMenuGoodsList"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSArray *goodsArr=[dataDic objectForKey:@"list"];
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
        if(goodsModelArr.count<1){
            ShowMessage(@"无数据");
            return;
        }
        NSDictionary *menuIndexDic=[dataDic objectForKey:@"cat_index"];
        CFContentViewController *cfContentViewController=[[CFContentViewController alloc]init];
        cfContentViewController.menuIndexDic=menuIndexDic;
        cfContentViewController.dataList=goodsModelArr;
        cfContentViewController.topTitle=title;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:cfContentViewController animated:YES];
        
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
#pragma mark商品数据排2列
-(void)getGoodlistTwo:(NSArray *)arr{
    int nowCount=1;
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
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2){
        return listArr.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2){
        return 35;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==2){
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
            
        }
        NSMutableArray *bigArr=[[NSMutableArray alloc]init];
        for (App_Home_Bigegg *bigTemp in bannerArr) {
            NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
            [dicTemp setObject:bigTemp.img_url forKey:@"ititle"];
            [dicTemp setObject:bigTemp.content forKey:@"mainHeading"];
            [bigArr addObject:dicTemp];
        }
        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 160)
                                                              scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
        
        scroller.delegate=self;
        scroller.backgroundColor=[UIColor clearColor];
        [cell addSubview:scroller];
        return cell;
    }else if(indexPath.section==1){
        MenuModel *menuModel=self.menuModel;
        NSArray *menuModelarr=menuModel.child;
        static NSString *menu_cell = @"menu_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menu_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            
        }
        CGRect lastFram;
        for (int i =0; i<menuModelarr.count; i++)
        {
            MenuModel *menuTemp=menuModelarr[i];
            CFImageButton *btnNine=[[CFImageButton alloc]initWithFrame:CGRectMake((i%4)*75+12, floor(i/4)*75+10, 70, 70)];
            btnNine.menuModel=menuTemp;
            NSString *img=menuTemp.img;
            if([img isEqualToString:@""]){
                [btnNine setImage:[UIImage imageNamed:@"pic_02.png"] forState:0];
            }else{
                NSURL *imgUrl=[NSURL URLWithString:img];
                [btnNine setImageWithURL:imgUrl];
            }
            
            btnNine.backgroundColor=[UIColor clearColor];
            [btnNine addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btnNine];
            
            UrlImageView*image=[[UrlImageView alloc]initWithFrame:CGRectMake(2, 1, 70-5, 50)];
            [btnNine addSubview:image];
            [image setImage:[UIImage imageNamed:@"default_04.png"]];
            image.layer.borderWidth=1;
            image.layer.cornerRadius = 4;
            image.layer.borderColor = [[UIColor clearColor] CGColor];
            image.backgroundColor=[UIColor clearColor];
            
            UILabel *labelLine=[[UILabel alloc]initWithFrame:CGRectMake(2, 50+10, 70-4, 1)];
            labelLine.backgroundColor=[UIColor grayColor];
            [btnNine addSubview:labelLine];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 20, 15)];
            label.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
            label.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;  //文本对齐方式
            [label setBackgroundColor:[UIColor whiteColor]];
            
            //高度固定不折行，根据字的多少计算label的宽度
            NSString *str = menuTemp.name;
            CGSize size = [str sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, label.frame.size.height)];
            //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
            //根据计算结果重新设置UILabel的尺寸
            [label setFrame:CGRectMake((70-size.width)/2, 52, size.width+4, 15)];
            label.text = str;
            lastFram=btnNine.frame;
            
            [btnNine addSubview:label];
        }
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=lastFram.origin.y+lastFram.size.height+10;
        [cell setFrame:cellFrame];
        return cell;
        
    }
    
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
        
        GoodImageButton*btn=[[GoodImageButton alloc]initWithFrame:CGRectMake(2, 2, 140-4, 140-4)];
        btn.userInteractionEnabled=YES;
        btn.layer.borderWidth=1;//描边
        btn.layer.cornerRadius=4;//圆角
        btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
        btn.backgroundColor=[UIColor whiteColor];
        btn.goods=new_Goods;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 160;
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
#pragma mark 分类
-(void)btnFenlei:(CFImageButton *)sender
{
    MenuModel *menuModel=sender.menuModel;
    title=menuModel.name;
    [self getMenuGoodsList:menuModel.id];
    
    
}
#pragma mark 商品详细信息
-(void)goodContentTouch:(GoodImageButton *)sender{
    New_Goods *goods=sender.goods;
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"id":goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}
#pragma mark -获取分类下的商品信息
-(void)getMenuGoodsList:(NSString *)s_cat{
    NSDictionary *parameters = @{@"s_cat":s_cat,@"need_cat_index":@1};
    
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getMenuGoodsList"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
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
#pragma mark  通告栏
-(void)EScrollerViewDidClicked:(NSUInteger)index{
    NSLog(@"第几个广告%ld",index);
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
        NSArray *arr=@[@"内容",@"价格",@"配送",@"商城",@"品牌"];
        screenViewController.showArr=arr;
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
