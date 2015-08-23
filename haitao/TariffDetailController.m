//
//  TariffDetailController.m
//  haitao
//
//  Created by pwy on 15/8/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "TariffDetailController.h"
#import "Order_goods.h"
#import "Order_goodsAttr.h"
#import "New_Goods.h"
#import "Goods_Ext.h"
#import "OrderListCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface TariffDetailController ()

@end

@implementation TariffDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"关税缴纳";
    // Do any additional setup after loading the view from its nib.
    [_taxImageView setImageWithURL:[NSURL URLWithString:_orderTax.img] placeholderImage:nil];
    
    //控制缩放
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    // Tells which views need to be focusable. You can put your image views in an array and give it to the focus manager.
    [self.mediaFocusManager installOnView:_taxImageView];
    
    //是否点击释放
    self.mediaFocusManager.isDefocusingWithTap=YES;
    //动画时间
    self.mediaFocusManager.animationDuration=0.5;
    //
    self.mediaFocusManager.gestureDisabledDuringZooming=NO;
    
    self.mediaFocusManager.defocusOnVerticalSwipe=YES;
    
    self.mediaFocusManager.zoomEnabled=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    self.tableViewHeight.constant=80+80*_orderTax.package_info.package_info.goods.count;

    //自身高度＝tableview的y坐标＋tableView的高度＋coll的高度*个数＋coll展开view的最大高度
    
    self.viewHeight.constant=self.tableView.frame.origin.y+self.tableViewHeight.constant+200;
    
    
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

    _packageDetail=_orderTax.package_info;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    
    //包裹
    UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 38)];
    head.text=[NSString stringWithFormat:@"包裹商品"];
    head.font =[UIFont  boldSystemFontOfSize:13];//加粗字体
    head.textColor=RGB(51, 51, 51);
    [view addSubview:head];
    

    //订单编号
    UILabel *orderNo=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 0, 140, 38)];
    orderNo.text=[NSString stringWithFormat:@"订单编号：%@",_packageDetail.order.id];
    orderNo.font =[UIFont  boldSystemFontOfSize:11];
    orderNo.textColor=RGB(179, 179, 179);
    orderNo.textAlignment=NSTextAlignmentRight;
    [view addSubview:orderNo];
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    _packageDetail=_orderTax.package_info;
    
    Order_package *package=_packageDetail.package_info;
    //内层footer
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
   
    
    //小计
    UILabel *subTotal=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/2, 20)];
    //        subTotal.text=@"小计:";
    subTotal.text=[NSString stringWithFormat:@"共%d件商品",package.buy_num];
    subTotal.font=[UIFont boldSystemFontOfSize:11];
    subTotal.textColor=RGB(128, 128, 128);
    [view addSubview:subTotal];
    
    //小计金额
    UILabel *subTotal_amout=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-150, 5, 140, 20)];
    NSString *totalText=[NSString stringWithFormat:@"应缴税额：¥%.2f",[_orderTax.pay_amount floatValue]];
    subTotal_amout.textAlignment=NSTextAlignmentRight;
    subTotal_amout.font =[UIFont  boldSystemFontOfSize:11];
    //    subTotal_amout.textColor=RGB(255, 13, 94);
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:totalText];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:RGB(255, 13, 94)
     
                          range:NSMakeRange(5, totalText.length-5)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:RGB(128, 128, 128)
     
                          range:NSMakeRange(0, 5)];
    
    subTotal_amout.attributedText=AttributedStr;
    
    [view addSubview:subTotal_amout];
    
    UILabel *jianju=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    jianju.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju];
    
    UILabel *jianju_footer=[[UILabel alloc] initWithFrame:CGRectMake(0, 29.5, SCREEN_WIDTH, 12.5)];
    jianju_footer.backgroundColor=RGB(237, 237, 237);
    [view addSubview:jianju_footer];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 38;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 42;//本身距离加间距
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _orderTax.package_info.package_info.goods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderListCell *  cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"packagecell"];
    //    }
    _packageDetail=_orderTax.package_info;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;//cell选中时的颜色
    
    Order_goods *goods=[_packageDetail.package_info.goods objectAtIndex:indexPath.row];
    cell.textLabel.text = goods.goods_name;
    cell.textLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:11];
    cell.textLabel.textColor=RGB(51, 51, 51);
    cell.textLabel.numberOfLines=1;
    //如果有规格 展示规格 只展示2条
    if (goods.goods_attr.count>0) {
        for (int i=0; i<goods.goods_attr.count; i++) {
            if (i>1) {
                break;
            }
            Order_goodsAttr *attr =goods.goods_attr[i];
            
            //                UILabel *head=[[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x+70,i==0?cell.frame.origin.y+30:cell.frame.origin.y+50, 150, 20)];
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
    
    //商品价格
    UILabel *goodPrice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, cell.frame.origin.y+10, 70, 20)];
    goodPrice.text=[NSString stringWithFormat:@"¥%.2f",goods.goods_price];
    goodPrice.textAlignment=NSTextAlignmentRight;
    goodPrice.font =[UIFont  boldSystemFontOfSize:11];
    goodPrice.textColor=RGB(255, 13, 94);
    [cell.contentView addSubview:goodPrice];
    
    //商品价格
    UILabel *goodnum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 55, 70, 20)];
    goodnum.text=[NSString stringWithFormat:@"x %d",goods.buy_num];
    goodnum.textAlignment=NSTextAlignmentRight;
    goodnum.font =[UIFont  boldSystemFontOfSize:11];
    goodnum.textColor=RGB(128, 128, 128);
    [cell.contentView addSubview:goodnum];
    
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:goods.img_url] placeholderImage:[UIImage imageNamed:@"default_04.png"]];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
}

#pragma mark - ASMediaFocusDelegate
// Returns the view controller in which the focus controller is going to be added. This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager{
    
    return self.parentViewController;
}
// Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).
- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view{
    return [NSURL URLWithString:_orderTax.img];
    
}
// Returns the title for this media view. Return nil if you don't want any title to appear.
- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view{
    return nil;
}




@end
