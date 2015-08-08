//
//  PackageDetailController.h
//  haitao
//
//  Created by pwy on 15/8/4.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetail.h"
#import "CollapseClick.h"
@interface PackageDetailController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate,CollapseClickDelegate,UIScrollViewDelegate>

@property(strong,nonatomic) NSString *package_id;

@property(strong,nonatomic) NSArray *result_array;

@property(strong,nonatomic) PackageDetail *packageModel;

@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@property (weak, nonatomic) IBOutlet UILabel *shipAmount;

@property (weak, nonatomic) IBOutlet UILabel *payAmount;

@property (weak, nonatomic) IBOutlet UILabel *taxAmount;

@property (weak, nonatomic) IBOutlet UILabel *consignee;

@property (weak, nonatomic) IBOutlet UILabel *mobile;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//整个底部view
@property (weak, nonatomic) IBOutlet UIView *footView;
//控制整个view宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
//控制tableView高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
//控制整个view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
//下来伸缩
@property(strong,nonatomic) CollapseClick *coll;
//运费详情view
@property(strong,nonatomic) UIView *shipDetailView;

//税费详情view
@property(strong,nonatomic) UIView *taxDetailView;

//订单截图view
@property(strong,nonatomic) UIView *orderImageView;

@property(strong,nonatomic) UIView *footerBar;

@property (weak, nonatomic) IBOutlet UIScrollView *myScollView;

@property (weak, nonatomic) IBOutlet UIView *myView;

@property(strong,nonatomic) UIWebView *phoneCallWebView;
@end
