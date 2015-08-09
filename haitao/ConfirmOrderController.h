//
//  ConfirmOrderController.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClick.h"
#import "ConfirmOrderModel.h"
#import "AllInfo.h"
#import "SubAllInfo.h"
#import "ConfirmPackage.h"
#import "ShoppingCartModel.h"
#import "AddressModel.h"
#import "AddressListController.h"

@interface ConfirmOrderController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate,CollapseClickDelegate,UIScrollViewDelegate,AddressListDelegate>

@property (weak, nonatomic) IBOutlet UIView *myHeader;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *myFooter;

@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property(strong,nonatomic) ConfirmOrderModel *confirmOrderModel;
//优惠券view
@property(strong,nonatomic) UIView *couponView;

//下来伸缩
@property(strong,nonatomic) CollapseClick *coll;

//底部安妮
@property(strong,nonatomic) UIView *footerBar;

@property(strong,nonatomic) NSString *ids;

@property(strong,nonatomic) AddressModel *selectedAddress;

@property(strong,nonatomic) UIButton *addressButton;

@property(strong,nonatomic) UIWebView *phoneCallWebView;

//合计弹出视图
@property(strong,nonatomic) UIView *hejiView;

//防止重复提交订单计时器
@property(strong,nonatomic) NSTimer *timer;

@property(assign,nonatomic) int step;

@property(strong,nonatomic) UIButton *btn_confirm;

@end
