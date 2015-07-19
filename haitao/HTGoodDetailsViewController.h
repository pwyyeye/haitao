//
//  HTGoodDetailsViewController.h
//  haitao
//
//  Created by SEM on 15/7/18.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"

@interface HTGoodDetailsViewController : LTKViewController
{
    UIScrollView *_scrollView;
    UIImageView*  tabBarArrow;//上部桔红线条
    UIButton*BtnItem1; //上部三个按钮
    UIButton*BtnItem2;
    UIButton*BtnItem3;
    
    UrlImageButton *_bigView2;
    UrlImageButton *_bigImg;
    
    UrlImageButton *btnNine;
}

@end
