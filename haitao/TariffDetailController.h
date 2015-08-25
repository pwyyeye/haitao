//
//  TariffDetailController.h
//  haitao
//
//  Created by pwy on 15/8/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderTax.h"
#import "PackageDetail.h"
#import "ASMediaFocusManager.h"

@interface TariffDetailController : UIViewController<HTTPControllerProtocol,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASMediasFocusDelegate>

@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UIView *tableView;

@property(strong,nonatomic) OrderTax *orderTax;

@property(strong,nonatomic) PackageDetail *packageDetail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *taxImageView;

@property(strong,nonatomic) ASMediaFocusManager *mediaFocusManager;

@end
