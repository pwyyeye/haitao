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
#import "MenuHrizontal.h"
@interface ManitViewController : UITabBarController<HTTPControllerProtocol,MenuHrizontalDelegate>
{
    ZRScrollableTabBar *tabBar;
    CGRect mainFrame;
    UIView *navTopView;
     MenuHrizontal *mMenuHriZontal;
}

@end
