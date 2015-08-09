//
//  ProductModel.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Goods_Ext.h"
#import "New_Goods.h"
//商品购物车列表单比模型
@interface ShoppingCartModel : NSObject
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *goods_id;
@property (strong, nonatomic) NSString *attr_price_id;
@property (assign, nonatomic) int buy_num;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *ct;
@property (strong, nonatomic) NSString *mt;
@property (strong, nonatomic) New_Goods *goods_detail;
@property (strong, nonatomic) NSArray *goods_attr;
@property(strong,nonatomic) Goods_Ext *goods_ext;
@end
