//
//  ConfirmOrderModel.h
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllInfo.h"
@interface ConfirmOrderModel : NSObject

@property(strong,nonatomic) AllInfo *all_info;  // 包裹汇总信息

@property(strong,nonatomic) NSArray *list;  //包裹列表

@end
