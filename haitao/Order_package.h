//
//  Order_package.h
//  haitao
//
//  Created by pwy on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order_package : NSObject
@property(strong,nonatomic) NSString *id;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *shop_id;
@property(strong,nonatomic) NSString *ship_type;
@property(strong,nonatomic) NSString *logistic_id;
@property(strong,nonatomic) NSString *logistic_name;
@property(strong,nonatomic) NSString *package_status;
@property(strong,nonatomic) NSString *shop_name;
@property(strong,nonatomic) NSString *ship_name;
@property(strong,nonatomic) NSString *country_flag_url;
@property(strong,nonatomic) NSString *logistic_number;
@property(strong,nonatomic) NSString *all_transport_free_logistic;


@property(assign,nonatomic) double goods_amount;

@property(assign,nonatomic) double shipping_amount;

@property(assign,nonatomic) double direct_amount;

@property(assign,nonatomic) double transport_amount;

@property(assign,nonatomic) double package_amount;

@property(strong,nonatomic) NSString *ct;

@property(strong,nonatomic) NSString *mt;

@property(assign,nonatomic) int buy_num;

@property(strong,nonatomic) NSArray *goods;

@property(strong,nonatomic) NSArray *logistic_info;

@property(assign,nonatomic) int No;



@end
