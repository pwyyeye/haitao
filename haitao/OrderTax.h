//
//  OrderTax.h
//  haitao
//
//  Created by pwy on 15/8/22.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PackageDetail.h"
@interface OrderTax : NSObject
/**
 "id": "4",
 "user_id": "1",
 "order_id": "72",
 "package_id": "84",
 "pay_amount": "100.00",
 "img": "http://www.peikua.com/static/upload/pic/6/b/20150821174529023947370.jpg",
 "status": "1",
 "user_delete": "0",
 "ct": "1440150316",
 "mt": "1440150329",
 "pay_id": "tax4",
 "package_info"
 
 */
@property(strong,nonatomic) NSString *id;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *pay_amount;
@property(strong,nonatomic) NSString *img;
@property(strong,nonatomic) NSString *status;
@property(strong,nonatomic) NSString *user_delete;
@property(strong,nonatomic) NSString *ct;
@property(strong,nonatomic) NSString *mt;
@property(strong,nonatomic) NSString *pay_id;
@property(strong,nonatomic) PackageDetail *package_info;
@end
