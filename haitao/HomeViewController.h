//
//  HomeViewController.h
//  haitao
//
//  Created by SEM on 15/7/17.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "HaiTaoBase.h"
@interface HomeViewController : LTKViewController<UIScrollViewDelegate>
{
    UIScrollView              *_scrollView;
}
@property(nonatomic,retain)NSMutableArray *_scrol_marray;//滚动图片数组
@end
