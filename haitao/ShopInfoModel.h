//
//  ShopInfoModel.h
//  haitao
//
//  Created by SEM on 15/8/3.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInfoModel : NSObject
@property (copy, nonatomic) NSString *all_price;
@property (copy, nonatomic) NSString *country_name;
@property (copy, nonatomic) NSString *ship_name;
@property (copy, nonatomic) NSString *shop_name;
@property (assign, nonatomic) BOOL ischoose;
@property (copy, nonatomic) NSString *country_flag_url;
@end
