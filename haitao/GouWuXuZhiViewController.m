//
//  GouWuXuZhiViewController.m
//  haitao
//
//  Created by SEM on 15/8/16.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "GouWuXuZhiViewController.h"

@interface GouWuXuZhiViewController ()

@end

@implementation GouWuXuZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNavigationBar];
    listArr=[[NSMutableArray alloc]init];
    [self getList];
        // Do any additional setup after loading the view from its nib.
}
-(void)getList{
    NSDictionary *dic1=@{@"title":@"用户下单：",@"content":@"您可以在我们平台上方便快捷的把全球各地的商品收入自己的购物车并一键购买，由于国外商品过海关时需要提供收货人的身份证证件信息，所以在您确认订单时，请务必上传收货人本人的身份证照片。"};
    
    NSDictionary *dic2=@{@"title":@"订单包裹：",@"content":@"由于商品可能来源于不同的商城、或同一商城来源的商品采用不同的运输方式，为了给您提供一键购买的便利，我们会把同一来源并且是同一种运输方式的商品打包为一个包裹；也就是说您一个订单里可以产生1个以上的包裹，物流信息和税费信息将与包裹绑定，请您查看信息的时候以包裹为单位进行查看。如有疑问请查看帮助详情或咨询客服。"};
   NSDictionary *dic3=@{@"title":@"修改订单：",@"content":@"一旦下单以后您的订单将不可修改，如您下单以后想要取消订单您可查看个人订单中心中的订单状态，一旦订单进入已发货状态，您将不可取消订单，如遇问题请联系客服。"};
    NSDictionary *dic4=@{@"title":@"平台代购：",@"content":@"您下单以后配夸网将会在24小时以内帮您完成下单，如遇到商城缺货的情况将会及时给您发送站内信并更新您的订单信息；请您在下单后两天内注意查看您的订单情况。"};
    NSDictionary *dic5=@{@"title":@"国外官网发货：",@"content":@"配夸网所有商品均由国外在线商城直接发货，所以商品本身存在尺码、颜色等色差问题，请您在下单时慎重选择，谨慎下单。"};
    NSDictionary *dic6=@{@"title":@"国际运输：",@"content":@"配夸网的物流均有相应资质的第三方物流公司负责，本身并不提供物流服务。如商品因第三方物流出现损坏或贬损，配夸网将协助与物流供应商联系，并积极解决问题。"};
    NSDictionary *dic7=@{@"title":@"国内清关：",@"content":@"直邮商品有国外商城直接主动报关交税，海关会在清检之后放行；转运商品如果被抽检到包裹并且价值不符合免税标准即会产生关税，海关会通知您缴纳税款并且自行提货。如果海关放行则是正常配送，您无税到手。"};
    NSDictionary *dic8=@{@"title":@"收货时间：",@"content":@"如果您海淘的商品来源于日本一般3-5个工作日到手，如果您海淘的商品来源于其它地区一般10-17个工作日。"};
    NSDictionary *dic9=@{@"title":@"退换货：",@"content":@"配夸网上的所有商品均来自国外第三方商城，暂不支持非质量原因的退换货，如果商品有质量问题，我们会联系官方协商处理，具体情况您可以咨询客服。部分商城一旦下单不允许取消订单以及退货，具体可以联系客服进行咨询。"};
    [listArr addObjectsFromArray:@[dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9]];
    [self.tableView reloadData];
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"QBPeoplePickerControllerCell";
    UITableViewCell *cell = nil;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] ;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor whiteColor];
        UILabel *lal1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 320-20, 25)];
        [lal1 setTag:1];
        lal1.textAlignment=NSTextAlignmentLeft;
        lal1.font=[UIFont boldSystemFontOfSize:12];
        lal1.backgroundColor=[UIColor clearColor];
        lal1.textColor= RGB(128, 128, 128);
        lal1.numberOfLines = 0;  //必须定义这个属性，否则UILabel不会换行
        lal1.lineBreakMode=UILineBreakModeWordWrap;
        [cell.contentView addSubview:lal1];
        
    }

    NSDictionary *valueTemp=listArr[indexPath.row];
    UILabel *lal = (UILabel*)[cell viewWithTag:1];
    NSString *title=[valueTemp objectForKey:@"title"];
    NSString *countentStr=[valueTemp objectForKey:@"content"];
    NSString *allStr=[NSString stringWithFormat:@"%@%@",title,countentStr];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,title.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,title.length)];
    //高度固定不折行，根据字的多少计算label的宽度
    
    CGSize size = [allStr sizeWithFont:lal.font
                              constrainedToSize:CGSizeMake(lal.width, MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
    //        NSLog(@"size.width=%f, size.height=%f", size.width, size.height);
    //根据计算结果重新设置UILabel的尺寸
    lal.height=size.height+20;
    lal.attributedText=str;
    CGRect cellFrame = [cell frame];
    cellFrame.origin=CGPointMake(0, 0);
    cellFrame.size.width=SCREEN_WIDTH;
    cellFrame.size.height=lal.size.height+20;
    
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


-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    UIView *view_bar1 =[[UIView alloc]init];
    view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
    view_bar1.backgroundColor=RGB(255, 13, 94);
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake((320-130)/2, view_bar1.frame.size.height-44, 130, 44)];
    title_label.text=@"购物须知";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=NSTextAlignmentCenter;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"btn_back") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    
    
    
    
    
    
    return view_bar1;
}


#pragma mark退出
-(void)btnBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
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
