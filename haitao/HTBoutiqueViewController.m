//
//  HTBoutiqueViewController.m
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "HTBoutiqueViewController.h"
#import "New_Goods.h"
#import "App_Home_Bigegg.h"
#import "EScrollerView.h"
#import "CFContentViewController.h"
#import "GoodImageButton.h"
#import "HTGoodDetailsViewController.h"
#import "SpecialModel.h"
#import "SpecialContentViewController.h"
@interface HTBoutiqueViewController ()
<EScrollerViewDelegate>
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
    NSMutableArray *topMenuArr;
    NSMutableArray *dataList;
}

@end

@implementation HTBoutiqueViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    topMenuArr=[[NSMutableArray alloc]initWithCapacity:4];
    bannerArr =[[NSMutableArray alloc]initWithCapacity:4];
    dataList=[[NSMutableArray alloc]initWithCapacity:4];
    listArr=[[NSMutableArray alloc]init];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height,naviView.frame.size.width,SCREEN_HEIGHT-50-(naviView.frame.size.height+1)} style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];

    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    [self.view addSubview:_tableView];

    [self getCatBanner];//获取精品推荐
    // Do any additional setup after loading the view.
}
#pragma mark 获取精品推荐
-(void)getCatBanner{
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectTagsList",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:GETURL withUrlName:@"getSubjectTagsList"];
    httpController.delegate = self;
    [httpController onSearch];

    
    
}

#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//        NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
//    NSString *status=[dictemp objectForKey:@"status"];
   
    if([urlname isEqualToString:@"getSubjectTagsList"]){
         [topMenuArr removeAllObjects];
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        

        for (NSDictionary *dic in dataArr) {
            SpecialModel *specialModel = [SpecialModel objectWithKeyValues:dic] ;
            [topMenuArr addObject:specialModel];
        }
        [self drawTop];
       
    }
    if([urlname isEqualToString:@"getTagSubjectGoods"]){
        [listArr removeAllObjects];
        NSArray *dataArr=[dictemp objectForKey:@"data"];
        
        //
        [listArr addObjectsFromArray:[SpecialModel objectArrayWithKeyValuesArray:dataArr]];
        
        for (SpecialModel *speciaTemp in listArr) {
            NSArray *newArr=[New_Goods objectArrayWithKeyValuesArray:speciaTemp.goods_list];
            speciaTemp.goods_list_page=[self getGoodlist:newArr];
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
#pragma mark获取顶部菜单
-(void)drawTop{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    topView.backgroundColor=[UIColor whiteColor];
    CGRect lastFram;
    for (int i =0; i<topMenuArr.count; i++)
    {
        if(i==4){
            break;
        }
        SpecialModel *menuTemp=topMenuArr[i];
//        NSString *imgname=[menuTemp objectForKey:@"img"];
        NSString *menutitle=menuTemp.name;
        SpeciaButton *btnNine=[[SpeciaButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
        //            [btnNine setImage:[UIImage imageNamed:topMenuArr[i]] forState:0];
        
        btnNine.backgroundColor=[UIColor clearColor];
        [btnNine addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
        btnNine.specialModel=menuTemp;
        [topView addSubview:btnNine];
        
        UrlImageView *image=[[UrlImageView alloc]initWithFrame:CGRectMake(btnNine.frame.size.width*0.3125, btnNine.frame.size.height*0.2125, btnNine.frame.size.width*0.375, btnNine.frame.size.width*0.375)];
        [btnNine addSubview:image];
        
        [image setImageWithURL:[NSURL URLWithString:menuTemp.img] placeholderImage:[UIImage imageNamed:@"default_04"]];
        [image setContentMode:UIViewContentModeScaleAspectFill];
        image.layer.borderWidth=1;
        image.layer.cornerRadius = 4;
        image.layer.borderColor = [[UIColor clearColor] CGColor];
        image.backgroundColor=[UIColor clearColor];
        
        //            UILabel *labelLine=[[UILabel alloc]initWithFrame:CGRectMake(2, 50+10, 70-4, 1)];
        //            labelLine.backgroundColor=[UIColor grayColor];
        //            [btnNine addSubview:labelLine];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.size.height+image.frame.origin.y+btnNine.frame.size.height/10, btnNine.frame.size.width, 10)];
        label.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
        label.numberOfLines = 1;  //必须定义这个属性，否则UILabel不会换行
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;  //文本对齐方式
        [label setBackgroundColor:[UIColor whiteColor]];
        label.text=menutitle;
        lastFram=btnNine.frame;
        [btnNine addSubview:label];
    }
    
    topView.height=lastFram.origin.y+lastFram.size.height;
    _tableView.tableHeaderView=topView;
    //获取第一组数据
    SpecialModel *menuTemp=topMenuArr[0];
    //请求获取标签及其下专题
    [self getTagSubjectGoods:menuTemp.id];
//    [self getTagSubjectGoods:@"1"];
    
}
#pragma mark请求获取标签及其下专题
-(void)getTagSubjectGoods:(NSString *)tag_id{
    NSDictionary *parameters = @{@"tag_id":tag_id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getTagSubjectGoods",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getTagSubjectGoods"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];

}
#pragma mark获取商品数据
-(NSArray *)getGoodlist:(NSArray *)arr{
    int nowCount=1;
//    [listArr removeAllObjects];
//    [dataList removeAllObjects];
//    [bannerArr removeAllObjects];
    NSMutableArray *newPageArr=[[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray *pageArr=[[NSMutableArray alloc]initWithCapacity:2];
    for (int i=0; i<arr.count; i++) {
        New_Goods *new_Goods= arr[i];
        
        if(nowCount%2==0){
            [pageArr addObject:new_Goods];
            [newPageArr addObject:pageArr];
            pageArr=[[NSMutableArray alloc]initWithCapacity:2];
        }else{
            [pageArr addObject:new_Goods];
            if(i==arr.count-1){
                [newPageArr addObject:pageArr];
            }
        }
        nowCount++;
    }
    return newPageArr;
//    App_Home_Bigegg *bigTemp=[[App_Home_Bigegg alloc]init];
//    bigTemp.img_url=@"FeaturedPages_img_banner_6";
//
//    [bannerArr addObject:bigTemp];
//    
//    
//    NSDictionary *dic1=@{@"img":@"jingpintuijian_icon_topbar_xsfm_",@"title":@"孝敬父母"};
//    NSDictionary *dic2=@{@"img":@"jingpintuijian_icon_topbar_dsxn_",@"title":@"都市型男"};
//    NSDictionary *dic3=@{@"img":@"jingpintuijian_icon_topbar_cxz_",@"title":@"尝鲜者"};
//    NSDictionary *dic4=@{@"img":@"jingpintuijian_icon_topbar_scmp_",@"title":@"奢侈名牌"};
//    topMenuArr=@[dic1,dic2,dic3,dic4];
//    
//    [dataList addObject:topMenuArr];
//    [dataList addObject:bannerArr];
//    [dataList addObject:listArr];
//    [_tableView reloadData];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SpecialModel *specialModel=listArr[section];
        return specialModel.goods_list_page.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sec:%ld row:%ld",indexPath.section,indexPath.row);
    /*
    else if (indexPath.section==1){
        static NSString *contet_cell = @"contet_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contet_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            
        }
        NSString *ss;
        NSMutableArray *bigArr=[[NSMutableArray alloc]init];
        for (App_Home_Bigegg *bigTemp in bannerArr) {
            NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
            [dicTemp setObject:bigTemp.img_url forKey:@"ititle"];
            ss=bigTemp.img_url ;
            if(bigTemp.content){
                [dicTemp setObject:bigTemp.content forKey:@"mainHeading"];
            }else{
                [dicTemp setObject:@"" forKey:@"mainHeading"];
            }
            
            [bigArr addObject:dicTemp];
        }
     
     
     
        UIImageView *imge=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        imge.image =[UIImage imageNamed:ss];
        [cell addSubview:imge];
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=imge.frame.origin.y+imge.frame.size.height+5;
        [cell setFrame:cellFrame];
        
        return cell;
    }
*/

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
        SpecialModel *specialData=listArr[indexPath.section];
        NSArray *arrTemp=specialData.goods_list_page[indexPath.row];
        for (int i =0; i<arrTemp.count; i++)
        {
            New_Goods *new_Goods=arrTemp[i];
            GoodImageButton *gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((SCREEN_WIDTH-20)/2-5+10)+10, floor(i/2)*190+10, (SCREEN_WIDTH-20)/2-5, 180)];
            gbBtn.userInteractionEnabled=YES;
            gbBtn.backgroundColor=[UIColor whiteColor];
            //            imageV.userInteractionEnabled=YES;
            //            btn.layer.shadowOffset = CGSizeMake(1,1);
            //            btn.layer.shadowOpacity = 0.2f;
            //            btn.layer.shadowRadius = 3.0;
            gbBtn.layer.borderWidth=0.5;//描边
            gbBtn.layer.cornerRadius=4;//圆角
            gbBtn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            gbBtn.goods=new_Goods;
            gbBtn.backgroundColor=[UIColor whiteColor];
            [gbBtn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:gbBtn];
            
            UrlImageView*btn1=[[UrlImageView alloc]initWithFrame:CGRectMake((gbBtn.width/3/2), 10, gbBtn.frame.size.width*2/3, gbBtn.frame.size.width*2/3)];
            [btn1 setContentMode:UIViewContentModeScaleAspectFill];
            //            btn.userInteractionEnabled=YES;
            //            btn.layer.borderWidth=1;//描边
            //            btn.layer.cornerRadius=4;//圆角
            //            btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            btn1.backgroundColor=RGBA(237, 237, 237, 1);
            
            NSString *urlStr=new_Goods.img_260;
            if((urlStr==nil)||[urlStr isEqualToString:@""]){
                btn1.image=BundleImage(@"df_04_.png");
                
            }else{
                NSURL *imgUrl=[NSURL URLWithString:urlStr];
                [btn1 setImageWithURL:imgUrl];
            }
            
            //            [btn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
            //            [imageV addSubview:btn];
            //商店名
            [gbBtn addSubview:btn1];
            UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(0, btn1.frame.size.width+btn1.top+10, gbBtn.width, 10)];
            _label.text=new_Goods.shop_name;
            _label.font=[UIFont boldSystemFontOfSize:10];
            _label.backgroundColor=[UIColor clearColor];
            _label.textColor =hexColor(@"#b3b3b3");
            _label.numberOfLines=1;
            _label.textAlignment=NSTextAlignmentCenter;
            
            [gbBtn addSubview:_label];
            //商品名
            UILabel *_label1=[[UILabel alloc]initWithFrame:CGRectMake(10, _label.frame.size.height+_label.frame.origin.y+1, gbBtn.frame.size.width-10-10, 30)];
            _label1.text=new_Goods.title;
            _label1.font=[UIFont boldSystemFontOfSize:11];
            _label1.backgroundColor=[UIColor clearColor];
            _label1.textColor =hexColor(@"#333333");
            _label1.lineBreakMode = UILineBreakModeWordWrap;
            _label1.numberOfLines=2;
            _label1.textAlignment=NSTextAlignmentCenter;
            
            [gbBtn addSubview:_label1];
            
            
            
            
            UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(0, _label1.frame.size.height+_label1.frame.origin.y+1 ,gbBtn.frame.size.width, 20)];
            title_label.text=[NSString stringWithFormat:@"￥%.2f",new_Goods.price_cn];
            
            title_label.font=[UIFont boldSystemFontOfSize:14];
            title_label.backgroundColor=[UIColor clearColor];
            title_label.textColor =hexColor(@"#ff0d5e");
            title_label.textAlignment=NSTextAlignmentCenter;
            
            //
            [gbBtn addSubview:title_label];
            lastFrame =gbBtn.frame;
        }
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lastFrame.size.height+10;
        [cell setFrame:cellFrame];
        
        
        
        return cell;
    }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if(indexPath.row==1){
//        return 160;
//    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
    NSLog(@"长度:%f",cell.frame.size.height);
//    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 140;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
     SpeciaButton *imge=[[SpeciaButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    
    [imge addTarget:self action:@selector(queryzhuanti:) forControlEvents:UIControlEventTouchUpInside];
    //[imge setContentMode:UIViewContentModeScaleAspectFill];
    SpecialModel *spc=listArr[section];
    imge.specialModel=spc;
    NSString *urlStr=spc.img;
    if((urlStr==nil)||[urlStr isEqualToString:@""]){
        [imge setImage:BundleImage(@"df_04_.png") forState:UIControlStateNormal];
        
    }else{
        NSURL *imgUrl=[NSURL URLWithString:urlStr];
        
        [imge setImageWithURL:imgUrl];
    }
    [view addSubview:imge];
    return view;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:false];
    
    //    TMThirdClassViewController *goods=[[TMThirdClassViewController alloc]init];
    //
    //    [delegate.navigationController pushViewController:goods animated:YES];
}
#pragma mark 专题查询
-(void)queryzhuanti:(SpeciaButton *)sender{
    [self getSpecialContentData:sender.specialModel.id];
}
#pragma mark  获取专题详细信息
-(void)getSpecialContentData:(NSString *)sid{
    
    NSDictionary *parameters = @{@"id":sid};
    sidTemp=sid;
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectInfo",requestUrl]
    ;
//    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    [app startLoading];
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getSubjectInfo"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
    
}
#pragma mark 分类
-(void)btnFenlei:(SpeciaButton *)sender
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnFenleiDo:) object:nil];
    [self performSelector:@selector(btnFenleiDo:) withObject:sender afterDelay:0.2f];
//    [self getCatBanner];
    
}
-(void)btnFenleiDo:(SpeciaButton *)sender
{
    NSString *sid=sender.specialModel.id;
    
    [self getTagSubjectGoods:sid];
}
-(void)goodContentTouch:(GoodImageButton *)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(goodContentTouchDo:) object:sender];
    [self performSelector:@selector(goodContentTouchDo:) withObject:sender afterDelay:0.2f];
    
    
}
-(void)goodContentTouchDo:(GoodImageButton *)sender{
    New_Goods *goods=sender.goods;
    //    NSDictionary *parameters = @{@"id":@"626"};
    NSDictionary *parameters = @{@"id":goods.id};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsDetail",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getGoodsDetail"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);

        view_bar1.backgroundColor=RGB(255, 13, 94);

        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        
        view_bar1.backgroundColor=RGB(255, 13, 94);
        
    }
//    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"精品推荐";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    
    
    //    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    ////        title_label.text=@"商品详情";
    //    title_label.font=[UIFont boldSystemFontOfSize:20];
    //    title_label.backgroundColor=[UIColor clearColor];
    //    title_label.textColor =[UIColor whiteColor];
    //    title_label.textAlignment=1;
    //    [view_bar1 addSubview:title_label];
    
    
    
    
    
    return view_bar1;
}
#pragma mark - 下拉刷新页面
-(void)reloadAll{
    
    
    [self getCatBanner];
}
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * USEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addDataWithDirection:direction];
    });
    
    
    
}
- (void)addDataWithDirection:(DJRefreshDirection)direction{
    
    if (direction==DJRefreshDirectionTop) {
        [self reloadAll];
    }
    
    
    [_refresh finishRefreshingDirection:direction animation:YES];
    
    
    
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
