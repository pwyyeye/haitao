//
//  New_Goods.h
//  haitao
//
//  Created by SEM on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface New_Goods : NSObject
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *sub_title;
@property (copy, nonatomic) NSString *goods_link;
@property (copy, nonatomic) NSString *goods_sn;
@property (assign, nonatomic) double price;
@property (copy, nonatomic) NSString *price_ut;
@property (copy, nonatomic) NSString *p_cat;
@property (copy, nonatomic) NSString *cat_id;
@property (copy, nonatomic) NSString *brand_id;
@property (copy, nonatomic) NSString *shop_id;
@property (copy, nonatomic) NSString *ship_type;
@property (copy, nonatomic) NSString *discount;
@property (copy, nonatomic) NSString *fav_num;
@property (copy, nonatomic) NSString *is_open;
@property (copy, nonatomic) NSString *order_num;
@property (copy, nonatomic) NSString *open_time;
@property (copy, nonatomic) NSString *promotion_start_time;
@property (copy, nonatomic) NSString *promotion_end_time;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *is_hot;
@property (copy, nonatomic) NSString *is_good;
@property (copy, nonatomic) NSString *is_command;
@property (copy, nonatomic) NSString *is_free_ship;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *mt;
@property (copy, nonatomic) NSString *img_450;
@property (copy, nonatomic) NSString *img_260;
@property (copy, nonatomic) NSString *img_190;
@property (copy, nonatomic) NSString *img_80;
@property (copy, nonatomic) NSString *country_flag_url;
@property (copy, nonatomic) NSString *country_name;
@property (copy, nonatomic) NSString *shop_name;
@property(strong,nonatomic) NSString *shop_logo_app;
@property (copy, nonatomic) NSString *ship_name;
@property (copy, nonatomic) NSString *cat_name;
@property (assign, nonatomic) double price_cn;
@property (copy, nonatomic) NSString *price_ut_flag;
@property (copy, nonatomic) NSString *brand_name;
@property(strong,nonatomic) NSString *brand_logo;
@property(strong,nonatomic) NSString *brand_logo_app;
@property(strong,nonatomic) NSString *fav_id;
@end
