//
//  FilterGoodsList.h
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cat_indexModel.h"
@interface FilterGoodsModel : NSObject
@property(strong,nonatomic) NSArray *list;
@property(strong,nonatomic) Cat_indexModel *cat_index;
@end
