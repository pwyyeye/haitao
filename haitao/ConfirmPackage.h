//
//  ConfirmPackage.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubAllInfo.h"
//包裹
@interface ConfirmPackage : NSObject
@property(strong,nonatomic) SubAllInfo *all_info;//单个包裹汇总信息
@property(strong,nonatomic) NSArray *list;//包裹购物车列表
@end
