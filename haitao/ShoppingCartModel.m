//
//  ProductModel.m
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ShoppingCartModel.h"

@implementation ShoppingCartModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"goods_attr" : @"GoodsAttrModel",
             };
}

@end
