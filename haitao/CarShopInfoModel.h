//
//  CarShopInfoModel.h
//  haitao
//
//  Created by SEM on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "New_Goods.h"
#import "GoodsAttrModel.h"
@interface CarShopInfoModel : NSObject

@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *user_id;
@property (copy, nonatomic) NSString *goods_id;
@property (copy, nonatomic) NSString *attr_price_id;
@property (copy, nonatomic) NSString *buy_num;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *ct;
@property (copy, nonatomic) NSString *mt;
@property (retain, nonatomic) New_Goods *goods_detail;
@property (retain, nonatomic) NSArray *goods_attr;
@property (copy, nonatomic) NSString *change_attr_price_id;
@property (copy, nonatomic) NSString *change_buy_num;
@property (assign, nonatomic) BOOL ischoose;
@end
