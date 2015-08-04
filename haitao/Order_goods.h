//
//  Order_goods.h
//  haitao
//
//  Created by pwy on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order_goods : NSObject
@property(strong,nonatomic) NSString *id;
@property(strong,nonatomic) NSString *user_id;
@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *package_id;
@property(strong,nonatomic) NSString *goods_id;
@property(strong,nonatomic) NSString *attr_price_id;
@property(strong,nonatomic) NSString *goods_name;
@property(assign,nonatomic) double goods_price;
@property(strong,nonatomic) NSString *goods_img;
@property(assign,nonatomic) int buy_num;
@property(assign,nonatomic) double all_price;
@property(strong,nonatomic) NSString *is_comment;
@property(strong,nonatomic) NSString *ct;
@property(strong,nonatomic) NSString *mt;
@property(strong,nonatomic) NSString *img_url;

@property(strong,nonatomic) NSArray *goods_attr;
@end
