//
//  Goods_Ext.h
//  haitao
//
//  Created by SEM on 15/7/29.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goods_Ext : NSObject


/** id */
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *weight_ut;
@property (copy, nonatomic) NSString *sale_price_ut;
@property (assign, nonatomic) double weight;
@property (assign, nonatomic) double sale_price;
@property (assign, nonatomic) double direct_mail_ship;
@property (copy, nonatomic) NSString *direct_mail_ship_ut;
@property (assign, nonatomic) double direct_tax;
@property (copy, nonatomic) NSString *direct_tax_ut;
@property (assign, nonatomic) double transport_ship;
@property (copy, nonatomic) NSString *transport_ship_ut;
@property (assign, nonatomic) double transport_tax;
@property (copy, nonatomic) NSString *transport_tax_ut;
@property (assign, nonatomic) double last_price;
@property (copy, nonatomic) NSString *last_price_ut;
@property (copy, nonatomic) NSString *purchase_id;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *reason;
@property (copy, nonatomic) NSString *keywords;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *mt;
@property (copy, nonatomic) NSString *weight_g;
@end
