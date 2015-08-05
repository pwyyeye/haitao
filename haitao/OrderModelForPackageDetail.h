//
//  OrderModelForPackageDetail.h
//  haitao
//
//  Created by pwy on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModelForPackageDetail : NSObject
@property(strong,nonatomic) NSString *id;

@property(strong,nonatomic) NSString *user_id;

@property(strong,nonatomic) NSString *order_status;

@property(strong,nonatomic) NSString *pay_status;

@property(strong,nonatomic) NSString *consignee;

@property(strong,nonatomic) NSString *idcard;

@property(strong,nonatomic) NSString *mobile;

@property(strong,nonatomic) NSString *idcard_status;

@property(strong,nonatomic) NSString *province;

@property(strong,nonatomic) NSString *address;

@property(strong,nonatomic) NSString *zipcode;

@property(strong,nonatomic) NSString *is_default;

@property(assign,nonatomic) double goods_amount;

@property(assign,nonatomic) double shipping_amount;

@property(assign,nonatomic) double order_amount;

@property(assign,nonatomic) double pay_amount;

@property(assign,nonatomic) double direct_amount;

@property(assign,nonatomic) double transport_amount;

@property(strong,nonatomic) NSString *note;

@property(strong,nonatomic) NSString *user_delete;

@property(strong,nonatomic) NSString *ct;

@property(strong,nonatomic) NSString *mt;

@property(assign,nonatomic) int buy_num;
@end
