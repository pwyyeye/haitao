//
//  LTKSeachResultViewController.m
//  LvTongKa
//
//  Created by 123 on 13-8-27.
//  Copyright (c) 2013年 呵呵. All rights reserved.
//

#import "LTKSeachResultViewController.h"
#import "TitleBtn.h"
#import "CFContentViewController.h"
#import "New_Goods.h"
#import "CFContentForDicKeyViewController.h"

@interface LTKSeachResultViewController ()



@end

@implementation LTKSeachResultViewController
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    return  NO;
}
-(void)dealloc
{
    
}
-(id)initSeachKeyWords:(NSString*)keyWords addSeachString:(NSString *)string
{
    self = [super init];
    if (self) {
        _keyWords=[[NSString alloc]initWithString:keyWords];
        _seachString=[[NSString alloc]initWithString:string];
        
    }
    return self;
}
#pragma mark return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *searchTex=serchText.text;
    [serchText resignFirstResponder];
    
    if(searchTex.length>0)
    {
        [self saveHisData:searchTex];
        NSDictionary *parameters = @{@"keyword":searchTex,@"need_cat_index":@1};

        CFContentForDicKeyViewController *contentForDicKeyViewController=[[CFContentForDicKeyViewController alloc]init];
        contentForDicKeyViewController.keyDic=parameters;
        contentForDicKeyViewController.title=searchTex;
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.navigationController pushViewController:contentForDicKeyViewController animated:YES];
    }
    
    return YES;
}
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    view_bar =[[UIView alloc]init];
    view_bar .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
    view_bar.backgroundColor=RGB(255, 13, 94);
        
//    view_bar.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview: view_bar];
    serchText = [[UITextField alloc] initWithFrame:CGRectMake(20, 20+7,view_bar.width-10-90 , 30)];
    serchText.textAlignment=NSTextAlignmentCenter;
    serchText.backgroundColor=[UIColor whiteColor];
    serchText.layer.borderWidth=0.5;//描边
    serchText.layer.cornerRadius=4;//圆角
    serchText.layer.borderColor=[UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.0].CGColor;
    serchText.returnKeyType=UIReturnKeySearch;
    serchText.delegate=self;
    [view_bar addSubview:serchText];
    [serchText becomeFirstResponder];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(serchText.left+serchText.width+10, serchText.top, 60, 30);
    [btnBack setTitle:@"取消" forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar addSubview:btnBack];
    /*
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, (view_bar.frame.size.height-40)/2+20, 320, 40)];
    self.searchBar.placeholder = @"搜索你喜欢的宝贝";
    self.searchBar.delegate = self;
    self.searchBar.barStyle=UIBarStyleDefault;
    
    self.searchBar.tintColor=[UIColor colorWithRed:1.0 green:.4 blue:.5 alpha:1.0];
    self.searchBar.barTintColor=[UIColor colorWithRed:1.0 green:.4 blue:.5 alpha:1.0];
    [self.searchBar sizeToFit];
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    
    
    [view_bar addSubview:self.searchBar];
    [self.searchBar becomeFirstResponder];
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
    [self.searchDisplayController.searchResultsTableView setHidden:YES];
     */
//    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar.frame.size.height-44, self.view.frame.size.width-130, 44)];
//    title_label.text=@"快寻";
//    title_label.font=[UIFont boldSystemFontOfSize:20];
//    title_label.backgroundColor=[UIColor clearColor];
//    title_label.textColor =[UIColor whiteColor];
//    title_label.textAlignment=1;
//    [view_bar addSubview:title_label];
//    
//    UIButton*btnBack=[UIButton buttonWithType:0];
//    btnBack.frame=CGRectMake(0, view_bar.frame.size.height-34, 47, 34);
//    [btnBack setImage:BundleImage(@"btn_back") forState:0];
//    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
//    [view_bar addSubview:btnBack];
    
    
//    UIButton*btnTJ=[UIButton buttonWithType:0];
//    btnTJ.frame=CGRectMake(view_bar.frame.size.width-55, view_bar.frame.size.height-40, 47, 34);
//    
//    [btnTJ setTitle:@"完成" forState:0];
//    [btnTJ addTarget:self action:@selector(btnTJ:) forControlEvents:UIControlEventTouchUpInside];
//    [view_bar addSubview:btnTJ];
    
    
    
    
    return view_bar;
}
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    }
-(void)viewDidDisappear:(BOOL)animated
{
    
}




- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.view.frame.size.width/2;
    return (tabIndex * tabItemWidth);
}

//返回
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:false];
    [self.searchBar resignFirstResponder];
//    [self dismissViewControllerAnimated:false completion:^{
//        
//    }];
}
#pragma mark 获取历史搜索数据
-(void)loadHisData{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisSerchArr = [[NSMutableArray alloc]initWithCapacity:20];
        
    }

}
#pragma mark 保存历史数据
-(void)saveHisData:(NSString *)strKey{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisRoute= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    }else{
        hisRoute = [[NSMutableArray alloc]initWithCapacity:8];
        
    }
    bool ishis=false;
    for (NSString *arrtemp in hisRoute) {
        
        if([arrtemp isEqualToString:strKey]){
            ishis=true;
            break;
        }
    }
    if(!ishis){
        if(hisRoute.count==8){
            [hisRoute removeObjectAtIndex:hisRoute.count-1];
        }
        [hisRoute insertObject:strKey atIndex:0];
        [NSKeyedArchiver archiveRootObject:hisRoute toFile:filename];
    }

}
-(void)delHisData:(UIButton *)sendid{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"hisSerchData.plist"];
    if([fileManager fileExistsAtPath:filename]){
        hisSerchArr= [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
        [hisSerchArr removeAllObjects];
        [NSKeyedArchiver archiveRootObject:hisRoute toFile:filename];
    }
    hisView.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    [self getNavigationBar];
    hisSerchArr=[[NSMutableArray alloc]init];
    _isFirstView=YES;

    appDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    page=1;
    _marrayAll =[[NSMutableArray alloc]init];
    [self loadHisData];
 
    //    imageViewToolBar=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.searchBar.frame.size.height+self.searchBar.frame.origin.y, self.view.frame.size.width,35 )];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, view_bar.height+view_bar.top+20, 80, 15)];
    label.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
    label.numberOfLines = 1;  //必须定义这个属性，否则UILabel不会换行
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label setBackgroundColor:[UIColor whiteColor]];
    NSString *str = @"热门标题";
    
    label.text = str;
    [self.view addSubview:label];
    TitleBtn *editBtn ;
    for (int i =0; i<8; i++)
    {
    
        editBtn =[[TitleBtn alloc]initWithFrame:CGRectMake((i%4)*75+12, floor(i/4)*35+10+label.frame.size.height+label.frame.origin.y, 70, 30)];
        [editBtn setTitle:@"moon" forState:UIControlStateNormal];
        editBtn.backgroundColor=[UIColor blackColor];
        [editBtn addTarget:self action:@selector(goSerch:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.backgroundColor=[UIColor whiteColor];
        [editBtn setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
        editBtn.layer.borderWidth=1;//描边
        editBtn.layer.cornerRadius=4;//圆角
        editBtn.layer.borderColor=RGB(179, 179, 179).CGColor;
        [self.view addSubview:editBtn];
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, editBtn.frame.size.height+editBtn.frame.origin.y+20, 80, 15)];
    label1.font = [UIFont boldSystemFontOfSize:10.0f];  //UILabel的字体大小
    label1.numberOfLines = 1;  //必须定义这个属性，否则UILabel不会换行
    label1.textColor = [UIColor grayColor];
    label1.textAlignment = NSTextAlignmentLeft;  //文本对齐方式
    [label1 setBackgroundColor:[UIColor whiteColor]];
    NSString *str1 = @"历史记录";
    
    label1.text = str1;
    [self.view addSubview:label1];
    CGRect lastFrame ;
    hisView=[[UIView alloc]initWithFrame:CGRectMake(0, 10+label1.frame.size.height+label1.frame.origin.y, self.view.width, 80)];
    [self.view addSubview:hisView];
    lastFrame=hisView.frame;
    if(hisSerchArr.count>0){
        for (int i =0; i<hisSerchArr.count; i++)
        {
            
            editBtn =[[TitleBtn alloc]initWithFrame:CGRectMake((i%4)*75+12, floor(i/4)*35+10, 70, 30)];
            [editBtn setTitle:hisSerchArr[i] forState:UIControlStateNormal];
            editBtn.backgroundColor=[UIColor whiteColor];
            [editBtn setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            [editBtn addTarget:self action:@selector(goSerch:) forControlEvents:UIControlEventTouchUpInside];
            editBtn.layer.borderWidth=1;//描边
            editBtn.layer.cornerRadius=4;//圆角
            editBtn.layer.borderColor=RGB(179, 179, 179).CGColor;
            [hisView addSubview:editBtn];
        }
        
    }
    UIButton *qingchuBtn =[[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2-200/2, lastFrame.origin.y+lastFrame.size.height, 200, 50)];
    [qingchuBtn setTitle:@"清楚历史记录" forState:UIControlStateNormal];
    [qingchuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    qingchuBtn.backgroundColor=[UIColor clearColor];
    [qingchuBtn addTarget:self action:@selector(delHisData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qingchuBtn];
    
}
-(void)goSerch:(TitleBtn *)id{
    NSString *searchTex=id.titleLabel.text;
    [serchText resignFirstResponder];
    if(searchTex.length>0)
    {
        NSDictionary *parameters = @{@"keyword":searchTex,@"need_cat_index":@1};
        
        CFContentForDicKeyViewController *contentForDicKeyViewController=[[CFContentForDicKeyViewController alloc]init];
        contentForDicKeyViewController.keyDic=parameters;
        contentForDicKeyViewController.title=searchTex;
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.navigationController pushViewController:contentForDicKeyViewController animated:YES];
    }

}
-(void)goSerchTwo:(TitleBtn *)id{
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    seachBarView.frame=CGRectZero;
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"dqe" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:0];
            
            NSLog(@"%@",btn.layer);
        }
    }

}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{

    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{


}
#pragma mark 取消按钮
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
}
#pragma mark 搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTex=searchBar.text;
    if(searchTex.length>0)
    {
        NSDictionary *parameters = @{@"keyword":searchTex};
        
        NSString* url =[NSString stringWithFormat:@"%@&m=goods&f=getGoodsList",requestUrl]
        ;
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"getMenuGoodsList"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }
    [searchBar resignFirstResponder];
}

//获取数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
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
        cfContentViewController.topTitle=_searchBar.text;
        AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [delegate.navigationController pushViewController:cfContentViewController animated:YES];
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.searchBar resignFirstResponder];
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isFirstView==YES) {
        return 18;
    }else{
        return 7;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
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
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
    }
    
    if (_isFirstView==YES)
    {
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
        line.image=BundleImage(@"line_01_.png");
        [cell addSubview:line];
        
        UIImageView *imageP=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-44, (40-70)/2, 44, 70)];
        imageP.image=BundleImage(@"bt_04_J.png");
        [cell addSubview:imageP];
        
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(5, 5);
        cellFrame.size.width=320;
        cellFrame.size.height=40;
        [cell setFrame:cellFrame];
        
        return cell;
    }else {
        
        UIImageView *imageP=[[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-44, (90-70)/2, 44, 70)];
        imageP.image=BundleImage(@"bt_04_J.png");
        [cell addSubview:imageP];
        
        
        UrlImageView *headImg=[[UrlImageView alloc]initWithFrame:CGRectMake(90/2-60/2, 15, 60, 60)];
        headImg.image=BundleImage(@"df_03_.png");
        [cell addSubview:headImg];
        headImg.backgroundColor=[UIColor clearColor];
        
        UrlImageView *headImg1=[[UrlImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        headImg1.image=BundleImage(@"bg_01_.png");
        [headImg addSubview:headImg1];
        headImg1.backgroundColor=[UIColor clearColor];
        
        UrlImageView*imgView=[[UrlImageView alloc]initWithFrame:CGRectMake(20, 10, 56,56)];
        
        //        if ([[[[_marrayAll objectAtIndex:indexPath.row]productList]objectAtIndex:0] icon]==nil)
        //        {
        
        //        }else
        //        {
        //            [imgView setImageWithURL:[NSURL URLWithString:_url]];
        //
        //        }
        
        //        [cell addSubview:imgView];
        
        //title店铺名
        UILabel*title=[[UILabel alloc]initWithFrame:CGRectMake(imgView.frame.size.width+imgView.frame.origin.y+20, 25, 100, 20)];
        title.backgroundColor=[UIColor clearColor];
        title.textAlignment=0;
        title.text=@"魅典幻镜";
        title.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title.font=[UIFont systemFontOfSize:14];
        [cell addSubview:title];
        
        //店铺介绍
        UILabel*title1=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+5, 60, 20)];
        title1.textAlignment=0;
        title1.tag=1000+indexPath.row;
        title1.font=[UIFont systemFontOfSize:12];
        title1.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title1.text=@"店铺介绍：";
        title1.backgroundColor=[UIColor clearColor];
        [cell addSubview:title1];
        
        //店铺介绍详情
        UILabel*title2=[[UILabel alloc]initWithFrame:CGRectMake(title1.frame.origin.x+title1.frame.size.width, title1.frame.origin.y, 140, 20)];
        title2.textAlignment=0;
        title2.tag=1000+indexPath.row;
        title2.font=[UIFont systemFontOfSize:12];
        title2.textColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0];
        title2.text=@"欧美 混搭 居家 传媒 中性 居家 传媒 中性";
        title2.numberOfLines=0;
        title2.backgroundColor=[UIColor clearColor];
        [cell addSubview:title2];
        
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(5, 5);
        cellFrame.size.width=320;
        cellFrame.size.height=90;
        [cell setFrame:cellFrame];
        
        
        //        line@2x
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 89, 320, 1)];
        line.image=BundleImage(@"line_01_.png");
        line.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        [cell addSubview:line];
        
        
        //cell高度
        
        return cell;
        
        
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (_isFirstView==YES) {

    }else{
        
        
    }
    //    LTKDetailCommercialViewController*VC=[[LTKDetailCommercialViewController alloc]initShopInFoID:[[_marrayAll objectAtIndex:indexPath.row]id]addCollectionIsCollection:NO];
    //    [self.navigationController pushViewController:VC animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
