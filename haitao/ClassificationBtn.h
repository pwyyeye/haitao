//
//  ClassificationBtn.h
//  haitao
//
//  Created by SEM on 15/8/4.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UrlImageButton.h"
#import "MenuModel.h"
@interface ClassificationBtn : UrlImageButton
@property (retain, nonatomic) MenuModel *menuModel;
@property(nonatomic,assign)int row;//第几行
@property(nonatomic,assign)int column;//第几列
@end
