//
//  PackageDetailController.h
//  haitao
//
//  Created by pwy on 15/8/4.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetail.h"
@interface PackageDetailController : UIViewController<HTTPControllerProtocol, UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSString *package_id;

@property(strong,nonatomic) NSArray *result_array;

@property(strong,nonatomic) PackageDetail *packageModel;

@property (weak, nonatomic) IBOutlet UILabel *orderStatus;

@property (weak, nonatomic) IBOutlet UILabel *shipAmount;

@property (weak, nonatomic) IBOutlet UILabel *payAmount;

@property (weak, nonatomic) IBOutlet UILabel *taxAmount;

@property (weak, nonatomic) IBOutlet UILabel *consignee;

@property (weak, nonatomic) IBOutlet UILabel *mobile;

@property (weak, nonatomic) IBOutlet UILabel *packAmount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@end
