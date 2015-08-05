//
//  OrderModel_PerPackage.h
//  haitao
//
//  Created by pwy on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order_package.h"
#import "OrderModelForPackageDetail.h"
@interface PackageDetail : NSObject


@property(strong,nonatomic) Order_package *package;
@property(strong,nonatomic) OrderModelForPackageDetail *order;

@end
