//
//  ManitViewController.h
//  haitao
//
//  Created by SEM on 15/7/15.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRScrollableTabBar.h"
#import "HaiTaoBase.h"
@interface ManitViewController : UITabBarController<HTTPControllerProtocol>
{
    ZRScrollableTabBar *tabBar;
    CGRect mainFrame;
}

@end
