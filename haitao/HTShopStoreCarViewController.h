//
//  HTShopStoreCarViewController.h
//  haitao
//
//  Created by SEM on 15/8/2.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LTKViewController.h"
#import "ShopInfoModel.h"
@interface HTShopStoreCarViewController : LTKViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,HTTPControllerProtocol>
{
    UITableView                     *_tableView;
    
    
    UILabel *amoutLabel;
    
    UIView *view_bar;
    BOOL _isTabbar;
    UIView *view_toolBar;
}
-(id)initWithTabbar:(BOOL)isTabbar;


@end
