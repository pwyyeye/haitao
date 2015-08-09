//
//  SubAllInfo.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubAllInfo : NSObject
/**
 //转运
 "all_transport_weight": 3400,//（包裹总量）
 "all_transport_tax": 0,//（预估税费）
 "all_price_ut": "JPY",
 "all_price": 284.9,//（产品价格）
 "all_num": 2,
 "country_name": "日本",
 "country_flag": "http://www.peikua.com/static/upload/pic/a/1/20150720181924960222625.png",
 "ship_name": "转运",
 "ship_type": "2",
 "shop_name": "日本亚马逊",
 "shop_id": "2",
 "logistic_name": "转运日本",
 "logistic_id": "8",
 "all_transport_ship_show": 0,
 "all_transport_logistic_ship_show": 474.73, //（转运的物流费用）
 "amount": 759.63//（含产品金额及运费
 
 //直邮
 "all_direct_ship": 40.01,//直邮运费（其他货币 该参数不用）
 "all_direct_tax": "261.29",//直邮税费
 "all_direct_tax_ut": "USD",
 "all_direct_ship_ut": "USD",
 "all_price_ut": "USD",
 "all_price": 1616.78,//单个包裹产品价格（不含运费）
 "all_num": 7,//包裹数量
 "country_name": "美国",
 "country_flag": "http://www.peikua.com/static/upload/pic/e/c/20150720181233202546173.png",
 "ship_name": "直邮",
 "ship_type": "1",
 "shop_name": "美国亚马逊",
 "shop_id": "1",
 "logistic_name": "直邮",
 "logistic_id": 0,
 "all_direct_ship_show": "174.63",//运费价格 人民币
 "amount": 2052.7//含运费的总价格
 */

//直邮
@property(assign,nonatomic) double all_direct_ship;
@property(assign,nonatomic) double all_direct_tax;
@property(assign,nonatomic) double all_direct_ship_show;
@property(strong,nonatomic) NSString *all_direct_tax_ut;
@property(strong,nonatomic) NSString *all_direct_ship_ut;

//转运
@property(assign,nonatomic) double all_transport_tax;
@property(assign,nonatomic) double all_transport_logistic_ship_show;
@property(assign,nonatomic) double all_transport_weight;
@property(strong,nonatomic) NSString *all_transport_ship_show;

//共同参数
@property(assign,nonatomic) int all_num;
@property(assign,nonatomic) double amount;
@property(assign,nonatomic) double all_price;


@property(strong,nonatomic) NSString *all_price_ut;
@property(strong,nonatomic) NSString *country_name;
@property(strong,nonatomic) NSString *country_flag;

@property(strong,nonatomic) NSString *ship_name;
@property(strong,nonatomic) NSString *ship_type;
@property(strong,nonatomic) NSString *shop_id;
@property(strong,nonatomic) NSString *shop_name;

@property(strong,nonatomic) NSString *logistic_id;
@property(strong,nonatomic) NSString *logistic_name;






@end
