//
//  App_Home_Bigegg.h
//  haitao
//
//  Created by SEM on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface App_Home_Bigegg : NSObject
/** id */
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *ad_location_id;
@property (copy, nonatomic) NSString *start_time;
@property (copy, nonatomic) NSString *end_time;
@property (copy, nonatomic) NSString *sortby;
@property (assign, nonatomic) int ad_type;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *subject_id;
@property (copy, nonatomic) NSString *cat_id;
@property (copy, nonatomic) NSString *brand_id;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *img;
@property (copy, nonatomic) NSString *linkhref;
@property (copy, nonatomic) NSString *target;
@property (copy, nonatomic) NSString *is_open;
@property (copy, nonatomic) NSString *pv;
@property (copy, nonatomic) NSString *cl;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *mt;
@property (copy, nonatomic) NSString *img_url;
@property (copy, nonatomic) NSString *img_detail;
@property (copy, nonatomic) NSString *ad_cat_id;
@property (assign, nonatomic) int last_time;
@property (assign, nonatomic) double price;
@property (assign, nonatomic) double mk_price;
@property (assign, nonatomic) double price_cn;
@end
