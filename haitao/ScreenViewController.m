//
//  ScreenViewController.m
//  haitao
//
//  Created by SEM on 15/7/26.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define NUMBERS @"0123456789."
#import "ScreenViewController.h"
#import "IndexModel.h"
#import "ShangChengBtn.h"
#import "LetterBrandDockTavleView.h"
#import "LBRightTableView.h"
#import "LBDockCell.h"
#import "Header.h"
@interface ScreenViewController ()<LetterBrandDockDelegate,LBRightTableViewDelegate>
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
    UITextField *fromPriceText;//价格
    UITextField *toPriceText;
    UIButton*zhiyouBtn;
    UIButton*zhuanyunBtn;
    NSMutableArray *showArr;
    NSMutableArray *keysortArr;
    NSMutableArray *brandArr;
    LBRightTableView *rightTableView ;
}

@end

@implementation ScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keysortArr=[[NSMutableArray alloc]init];
    brandArr=[[NSMutableArray alloc]init];
    if(!self.indexDic){
        self.indexDic=[[NSDictionary alloc]init];
    }
    showArr=[[NSMutableArray alloc]init];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _tableView =[[UITableView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height} style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorColor=[UIColor clearColor];

    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_tableView];
    [self getShaiXuanData];
    // Do any additional setup after loading the view.
}
#pragma mark 组装数据
-(void)getShaiXuanData
{
    NSArray *TitleArr=@[@"ship_row",@"shop_row",@"cat_row",@"brand_row"];
    NSDictionary *piPeidic=@{@"ship_row":@"配送",@"shop_row":@"商城",@"cat_row":@"分类",@"brand_row":@"品牌"};
    NSDictionary *dic=@{@"title":@"价格/元",@"name":@"price"};
    [showArr addObject:dic];
    for (NSString *keyStr in TitleArr) {
        NSArray *arrTemp=[self.indexDic objectForKey:keyStr];
        if(arrTemp){
            if(arrTemp.count>0){
                NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]init];
                NSString *titleStr=[piPeidic objectForKey:keyStr];
                [dicTemp setObject:titleStr forKey:@"title"];
                [dicTemp setObject:keyStr forKey:@"name"];
                NSMutableArray *arrTemp2=[[NSMutableArray alloc]init];
                for (NSDictionary *dic1 in arrTemp) {
                    IndexModel *indexModel=[IndexModel objectWithKeyValues:dic1];
                    if(indexModel.name){
                        [arrTemp2 addObject:indexModel];
                    }
                    
                }
                if([keyStr isEqualToString:@"brand_row"]){
                    for (int i =0; i<arrTemp2.count; i++)
                    {
                        IndexModel *indexModel=arrTemp2[i];
                        if(!indexModel.name){
                            break;
                        }
                        NSMutableString *ms=[[NSMutableString alloc]initWithString:indexModel.name];
                        if(CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)){
                            
                        }
                        if(CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)){
                            NSArray *arraytemp = [ms componentsSeparatedByString:@" "];
                            NSMutableString *sstemp=arraytemp[0];
                            
                            indexModel.letter=[[sstemp substringToIndex:1] uppercaseString];
                        }
                        NSString *letter=indexModel.letter;
                        BOOL ishave=false;
                        for (NSString *sstr in keysortArr) {
                            if([sstr isEqualToString:letter]){
                                ishave=true;
                                break;
                            }
                        }
                        if (ishave==false) {
                            [keysortArr addObject:letter];
                        }
                    }
                    [keysortArr sortUsingSelector:@selector(compare:)];
                    [keysortArr insertObject:@"默认" atIndex:0];
                }
                [dicTemp setObject:arrTemp2 forKey:@"child"];
                [showArr addObject:dicTemp];
            }
        }
    }
    [_tableView reloadData];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return 1;
        //    return spcList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return showArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSDictionary *showdic=showArr[section];
    
    NSString *titel=[showdic objectForKey:@"title"] ;
    
    UIView * uiview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 35)] ;
    uiview.backgroundColor=[UIColor whiteColor];
    UILabel *_label=[[UILabel alloc]initWithFrame:CGRectMake(2, 2, 140, 30)];
    _label.text=titel;
    _label.font=[UIFont boldSystemFontOfSize:20];
    _label.backgroundColor=[UIColor clearColor];
    _label.textColor =[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    _label.numberOfLines=2;
    _label.textAlignment=0;
    [uiview addSubview:_label];
    return uiview;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *showdic=showArr[indexPath.section];
    
    NSString *titel=[showdic objectForKey:@"title"] ;

    // NSArray *arr=@[@"内容",@"价格",@"配送",@"商城",@"品牌"];
    if([titel isEqualToString:@"内容"]){
        static NSString *contet_cell = @"content_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contet_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        }
        
        return cell;
    }else if([titel isEqualToString:@"价格/元"]){
        static NSString *price_cell = @"price_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:price_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.backgroundColor=[UIColor whiteColor];
        }
        fromPriceText =[[UITextField alloc]initWithFrame:CGRectMake(30, 2, 100, 40)];
        [fromPriceText setBorderStyle:UITextBorderStyleRoundedRect];
        fromPriceText.delegate=self;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(135, 21, 20, 3)];
        imageView.backgroundColor=[UIColor blackColor];
        toPriceText=[[UITextField alloc]initWithFrame:CGRectMake(160, 2, 100, 40)];
        [toPriceText setBorderStyle:UITextBorderStyleRoundedRect];
        toPriceText.delegate=self;
        [cell addSubview:fromPriceText];
        [cell addSubview:imageView];
        [cell addSubview:toPriceText];
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=44;
        [cell setFrame:cellFrame];
        return cell;
    
    }else if([titel isEqualToString:@"配送"]){
        static NSString *sent_cell = @"sent_cell";
        //    //[dicTemp setObject:titleStr forKey:@"title"];
        //    [dicTemp setObject:keyStr forKey:@"name"];
        //    [dicTemp setObject:arrTemp forKey:@"child"];
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sent_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        zhiyouBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        zhiyouBtn.frame=CGRectMake(30, 2, 100, 30);
        [zhiyouBtn setTitle:@"直邮" forState:UIControlStateNormal];
        [zhiyouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zhiyouBtn setBackgroundColor:[UIColor grayColor]];
        
        zhuanyunBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        zhuanyunBtn.frame=CGRectMake(160, 2, 100, 30);
        [zhuanyunBtn setTitle:@"转运" forState:UIControlStateNormal];
        [zhuanyunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zhuanyunBtn setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:zhiyouBtn];
        [cell addSubview:zhuanyunBtn];
        
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=34;
        [cell setFrame:cellFrame];
        return cell;
        
    }else if([titel isEqualToString:@"商城"]){
        static NSString *shop_cell = @"shop_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shop_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        NSArray *shangchengArr=[showdic objectForKey:@"child"];
        CGRect lastFrame;
        for (int i =0; i<shangchengArr.count; i++)
        {
            IndexModel *indexModel=shangchengArr[i];
            ShangChengBtn *btn=[[ShangChengBtn alloc]initWithFrame:CGRectMake((i%3)*95+12, floor(i/3)*35+5, 90, 30)];
            // 使用颜色创建UIImage//未选中颜色
            btn.indexModel=indexModel;
            CGSize imageSize = CGSizeMake(btn.frame.size.width, btn.frame.size.height);
            UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
            [RGB(237, 237, 237) set];
            UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
            UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [btn setBackgroundImage:normalImg forState:0];
            [btn setTitle:indexModel.name forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            [btn setBackgroundImage:[UIImage imageNamed:@"filter_btn_bottombar_peisong_selected_"] forState:1];
            [btn setTitle:indexModel.name forState:1];
            [btn setTitleColor:[UIColor whiteColor] forState:1];
            
            [btn addTarget:self action:@selector(chooseShangcheng:event:) forControlEvents:UIControlEventTouchUpInside];

            [cell addSubview:btn];
            lastFrame=btn.frame;
            
        }

        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=lastFrame.origin.y+lastFrame.size.height+5;
        [cell setFrame:cellFrame];
        return cell;
        
    }else if([titel isEqualToString:@"分类"]){
        static NSString *cat_cell = @"cat_row";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cat_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        NSArray *fenleiArr=[showdic objectForKey:@"child"];
        CGRect lastFram;
        for (int i =0; i<fenleiArr.count; i++)
        {
            IndexModel *indexModel=fenleiArr[i];
            ShangChengBtn *btnNine=[[ShangChengBtn alloc]initWithFrame:CGRectMake((i%4)*75+12, floor(i/4)*75+10, 70, 70)];
            btnNine.indexModel=indexModel;
//            NSString *img=menuTemp.img;
//            if([img isEqualToString:@""]){
//                [btnNine setImage:[UIImage imageNamed:@"pic_02.png"] forState:0];
//            }else{
//                NSURL *imgUrl=[NSURL URLWithString:img];
//                [btnNine setImageWithURL:imgUrl];
//            }
            [btnNine setImage:[UIImage imageNamed:@"pic_02.png"] forState:0];
            btnNine.backgroundColor=[UIColor clearColor];
            [btnNine addTarget:self action:@selector(btnFenlei:event:) forControlEvents:UIControlEventTouchUpInside];
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
            NSString *str = indexModel.name;
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
    else if([titel isEqualToString:@"品牌"]){
        static NSString *brand_cell = @"brand_cell";
        
        UITableViewCell *cell =nil;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:brand_cell] ;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
            cell.backgroundColor=[UIColor whiteColor];
        }
        NSArray *fenleiArr=[showdic objectForKey:@"child"];
        if(brandArr.count<1){
            
            for (int i=0; i<keysortArr.count; i++) {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
                NSString *dockName=keysortArr[i];
                [dic setObject:dockName forKey:@"dockName"];
                if(i==0){
                    
                    [dic setObject:fenleiArr forKey:@"right"];
                    [brandArr addObject:dic];
                    continue;
                }
                NSMutableArray *sortAddArr=[[NSMutableArray alloc]init];
                for (IndexModel *inModel in fenleiArr) {
                    if([inModel.letter isEqualToString:dockName]){
                        [sortAddArr addObject:inModel];
                    }
                    
                }
                [dic setObject:sortAddArr forKey:@"right"];
                [brandArr addObject:dic];
            }
           
        }
        
//        CGRect lastFram;
        
        LetterBrandDockTavleView *dockTavleView =[[LetterBrandDockTavleView alloc]initWithFrame:(CGRect){0,0,50,300}];
        dockTavleView.rowHeight=50;
        dockTavleView.dockDelegate=self;
        dockTavleView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
        [dockTavleView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [cell addSubview:dockTavleView];
        
        rightTableView =[[LBRightTableView alloc]initWithFrame:(CGRect){50,0,kWindowWidth-50,300}];
        rightTableView.rowHeight=90;
        rightTableView.rightDelegate=self;
        rightTableView.backgroundColor=UIColorRGBA(238, 238, 238, 1);
        [rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [cell addSubview:rightTableView];
        //        [keysortArr addObject:@"默认"];
        dockTavleView.dockArray=brandArr;
        NSMutableDictionary *dic1 =brandArr[0];
        rightTableView.rightArray=[dic1 objectForKey:@"right"];
        CGRect cellFrame = [cell frame];
        cellFrame.origin=CGPointMake(0, 0);
        cellFrame.size.width=self.view.frame.size.width;
        cellFrame.size.height=300;
        [cell setFrame:cellFrame];
        return cell;
        
    }
    UITableViewCell *cell =nil;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nil"] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame] ;
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.88 green:0.94 blue:0.99 alpha:1.0];
        cell.backgroundColor=[UIColor whiteColor];
    }
    return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *showdic=showArr[indexPath.section];
    
    NSString *titel=[showdic objectForKey:@"title"] ;
    if([titel isEqualToString:@"内容"]){
        return 20;
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

#pragma mark 代理
-(void)dockClickindexPathRow:(NSMutableArray *)array index:(NSIndexPath *)index indeXPath:(NSIndexPath *)indexPath
{
//    [_rightTableView setContentOffset:_rightTableView.contentOffset animated:NO];
//    _offsArray[index.row] =NSStringFromCGPoint(_rightTableView.contentOffset);
//    _rightTableView.rightArray=array;
//    [_rightTableView reloadData];
//    CGPoint point=CGPointFromString([_offsArray objectAtIndex:indexPath.row]);
//    [_rightTableView setContentOffset:point];
    //    NSLog(@"%@",row);
}

#pragma mark 选取商城
-(void)chooseShangcheng:(UIButton *)sender event:(id)event{

}
#pragma mark 选取分类
-(void)btnFenlei:(UIButton *)sender event:(id)event{
    
}
#pragma mark 获取导航栏
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
    title_label.text=@"筛选";
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSCharacterSet*cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"请输入数字"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        
        [alert show];
        return NO;
        
    }
    return YES;
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
