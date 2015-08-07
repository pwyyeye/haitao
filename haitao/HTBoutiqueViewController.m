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
    NSArray *topMenuArr;
    NSMutableArray *dataList;
}

@end

@implementation HTBoutiqueViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    bannerArr =[[NSMutableArray alloc]initWithCapacity:8];
    dataList=[[NSMutableArray alloc]initWithCapacity:3];
    listArr=[[NSMutableArray alloc]init];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,naviView.frame.size.width,SCREEN_HEIGHT-50} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];
    _refresh=[[DJRefresh alloc] initWithScrollView:_tableView delegate:self];
    _refresh.topEnabled=YES;
    [self.view addSubview:_tableView];

    [self getCatBanner];//获取精品推荐
    // Do any additional setup after loading the view.
}
#pragma mark 获取精品推荐
-(void)getCatBanner{
    //NSDictionary *parameters = @{@"cat_id":self.menuModel.id};
    NSDictionary *parameters = @{@"id":@"2"};
    NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getSubjectInfo",requestUrl]
    ;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getSubjectInfo"];
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
        NSArray *goodArr=[spdic objectForKey:@"goods"];
        [self getGoodlist:goodArr];
    }
    if([urlname isEqualToString:@"getGoodsList"]){
        NSDictionary *dataDic=[dictemp objectForKey:@"data"];
        NSArray *goodsArr=[dataDic objectForKey:@"list"];
        NSMutableArray *goodsModelArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dic in goodsArr) {
            New_Goods *goodsModel = [New_Goods objectWithKeyValues:dic] ;
            [goodsModelArr addObject:goodsModel];
        }
//        [self getGoodlistTwo:goodsModelArr];
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
//        cfContentViewController.topTitle=title;
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
#pragma mark获取商品数据
-(void)getGoodlist:(NSArray *)arr{
    int nowCount=1;
    [listArr removeAllObjects];
    [dataList removeAllObjects];
    [bannerArr removeAllObjects];
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
    
    App_Home_Bigegg *bigTemp=[[App_Home_Bigegg alloc]init];
    bigTemp.img_url=@"FeaturedPages_img_banner_6";

    [bannerArr addObject:bigTemp];
    
    
    NSDictionary *dic1=@{@"img":@"jingpintuijian_icon_topbar_xsfm_",@"title":@"孝敬父母"};
    NSDictionary *dic2=@{@"img":@"jingpintuijian_icon_topbar_dsxn_",@"title":@"都市型男"};
    NSDictionary *dic3=@{@"img":@"jingpintuijian_icon_topbar_cxz_",@"title":@"尝鲜者"};
    NSDictionary *dic4=@{@"img":@"jingpintuijian_icon_topbar_scmp_",@"title":@"奢侈名牌"};
    topMenuArr=@[dic1,dic2,dic3,dic4];
    
    [dataList addObject:topMenuArr];
    [dataList addObject:bannerArr];
    [dataList addObject:listArr];
    [_tableView reloadData];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2){
        NSArray *arr=dataList[section];
        return arr.count;
    }
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sec:%ld row:%ld",indexPath.section,indexPath.row);
    if(indexPath.section==0){
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
        for (int i =0; i<topMenuArr.count; i++)
        {
            NSDictionary *menuTemp=topMenuArr[i];
            NSString *imgname=[menuTemp objectForKey:@"img"];
            NSString *menutitle=[menuTemp objectForKey:@"title"];
            CFImageButton *btnNine=[[CFImageButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
            //            [btnNine setImage:[UIImage imageNamed:topMenuArr[i]] forState:0];
            
            btnNine.backgroundColor=[UIColor clearColor];
            [btnNine addTarget:self action:@selector(btnFenlei:) forControlEvents:UIControlEventTouchUpInside];
            btnNine.tag=i;
            [cell addSubview:btnNine];
            
            UrlImageView*image=[[UrlImageView alloc]initWithFrame:CGRectMake(btnNine.frame.size.width*0.3125, btnNine.frame.size.height*0.2125, btnNine.frame.size.width*0.375, btnNine.frame.size.width*0.375)];
            [btnNine addSubview:image];
            
            [image setImage:[UIImage imageNamed:imgname]];
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
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=lastFram.origin.y+lastFram.size.height;
        [cell setFrame:cellFrame];
        return cell;
        
    }else if (indexPath.section==1){
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
        /*
        EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, 320, 160)
                                                              scrolArray:[NSArray arrayWithArray:bigArr] needTitile:YES];
        
        scroller.delegate=self;
        scroller.backgroundColor=[UIColor clearColor];
        [cell addSubview:scroller];
         */
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
    else if(indexPath.section==2){
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
            GoodImageButton *gbBtn=[[GoodImageButton alloc]initWithFrame:CGRectMake((i%2)*((SCREEN_WIDTH-20)/2-5+10)+10, floor(i/2)*200+10, (SCREEN_WIDTH-20)/2-5, 200)];
            gbBtn.userInteractionEnabled=YES;
            gbBtn.backgroundColor=[UIColor whiteColor];
//            imageV.userInteractionEnabled=YES;
            //            btn.layer.shadowOffset = CGSizeMake(1,1);
            //            btn.layer.shadowOpacity = 0.2f;
            //            btn.layer.shadowRadius = 3.0;
            gbBtn.layer.borderWidth=1;//描边
            gbBtn.layer.cornerRadius=4;//圆角
            gbBtn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            gbBtn.goods=new_Goods;
            gbBtn.backgroundColor=[UIColor whiteColor];
            [gbBtn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:gbBtn];
            
            UrlImageView*btn=[[UrlImageView alloc]initWithFrame:CGRectMake(0, 0, gbBtn.frame.size.width, gbBtn.frame.size.width)];
//            btn.userInteractionEnabled=YES;
//            btn.layer.borderWidth=1;//描边
//            btn.layer.cornerRadius=4;//圆角
//            btn.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
            btn.backgroundColor=RGBA(237, 237, 237, 1);
            
            NSString *urlStr=new_Goods.img_260;
            if((urlStr==nil)||[urlStr isEqualToString:@""]){
               btn.image=BundleImage(@"df_04_.png");

            }else{
                NSURL *imgUrl=[NSURL URLWithString:urlStr];
                [btn setImageWithURL:imgUrl];
            }
            
//            [btn addTarget:self action:@selector(goodContentTouch:) forControlEvents:UIControlEventTouchUpInside];
            //            [imageV addSubview:btn];
            //商店名
            [gbBtn addSubview:btn];
            UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.width, btn.frame.size.height+btn.frame.origin.y+5, 10)];
            _label.text=new_Goods.shop_name;
            _label.font=[UIFont boldSystemFontOfSize:10];
            _label.backgroundColor=[UIColor clearColor];
            _label.textColor =hexColor(@"#b3b3b3");
            _label.numberOfLines=1;
            _label.textAlignment=NSTextAlignmentCenter;
            
            [gbBtn addSubview:_label];
            //商品名
            UILabel *_label1=[[UILabel alloc]initWithFrame:CGRectMake(0, _label.frame.size.height+_label.frame.origin.y+1, btn.frame.size.width, 30)];
            _label1.text=new_Goods.title;
            _label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:11];
            _label1.backgroundColor=[UIColor clearColor];
            _label1.textColor =hexColor(@"#333333");
            _label1.lineBreakMode = UILineBreakModeWordWrap;
            _label1.numberOfLines=2;
            _label1.textAlignment=NSTextAlignmentCenter;
            
            [gbBtn addSubview:_label1];
            
            
            
            
            UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(0, _label1.frame.size.height+_label1.frame.origin.y+1 ,btn.frame.size.width, 20)];
            title_label.text=[NSString stringWithFormat:@"%.1f",new_Goods.price];
            
            title_label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];;
            title_label.backgroundColor=[UIColor clearColor];
            title_label.textColor =hexColor(@"#ff0d5e");
            title_label.textAlignment=NSTextAlignmentCenter;
            lastFrame=title_label.frame;
            //
            [gbBtn addSubview:title_label];
            gbBtn.height=title_label.frame.size.height+title_label.frame.origin.y+5;
            lastFrame =gbBtn.frame;
//            UILabel *title_label1=[[UILabel alloc]initWithFrame:CGRectMake((i%2)*153+13+title_label.frame.size.width, floor(i/2)*200+140+10+_label.frame.size.height, 65, 20)];
//            title_label1.text=@"199.70";
//            title_label1.font=[UIFont systemFontOfSize:10];
//            title_label1.backgroundColor=[UIColor clearColor];
//            title_label1.textColor =[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:1.0];
//            title_label1.textAlignment=0;
//            
//            [cell addSubview:title_label1];
//            
//            //高度固定不折行，根据字的多少计算label的宽度
//            NSString *str = title_label1.text;
//            CGSize size = [str sizeWithFont:title_label.font constrainedToSize:CGSizeMake(MAXFLOAT, title_label.frame.size.height)];
//            //                     NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
//            //根据计算结果重新设置UILabel的尺寸
//            
//            
//            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, title_label1.frame.size.height/2, size.width, 1)];
//            line.image=BundleImage(@"line_01_.png");
//            [title_label1 addSubview:line];
            
        }
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=SCREEN_WIDTH;
        cellFrame.size.height=lastFrame.size.height+10;
        [cell setFrame:cellFrame];
        
        
        
        return cell;
    }
    
    static NSString *non_cell = @"non_cell";
    
    UITableViewCell *cell =nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:non_cell] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
        
    }

    return  cell;
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
    
    [self getCatBanner];
    
}
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
        UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageV1.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV1];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageV1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageV1.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageV1];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
