//
//  AllInfo.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//包裹汇总信息model
@interface AllInfo : NSObject
/**
 "all_goods_price": 284.9,//订单商品总价（不含运费 税费）
 "all_amount": 759.63,//（支付总金额）
 "all_package": 1,//（包裹数量）
 "all_num": 2,//（产品数量）
 "all_direct_tax": 0,//（直邮税费 计算入总金额）
 "all_transport": 0,//（预估税费 不计入总金额）
 "all_ship": 474.73//（物流费用）
 */
@property(assign,nonatomic) double all_goods_price;

@property(assign,nonatomic) double all_ship;

@property(assign,nonatomic) double all_transport;

@property(assign,nonatomic) double all_direct_tax;

@property(assign,nonatomic) double all_amount;

@property(assign,nonatomic) int all_num;

@property(assign,nonatomic) int all_package;

@end
