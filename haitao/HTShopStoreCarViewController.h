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
    
    UIView *view_toolBar;
    bool isload;
    bool isback;
}
@property(assign,nonatomic) BOOL isTabbar;;
@property(strong,nonatomic) UIView *empty_view;

-(id)initWithTabbar:(BOOL)isTabbar;



@end
