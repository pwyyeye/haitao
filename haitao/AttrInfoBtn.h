//
//  AttrInfoBtn.h
//  haitao
//
//  Created by SEM on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UrlImageButton.h"
#import "SizeModel.h"
@interface AttrInfoBtn : UrlImageButton
@property (retain, nonatomic) SizeModel *sizeModel;
@property (assign, nonatomic) BOOL isflag;//是否选中
@end
