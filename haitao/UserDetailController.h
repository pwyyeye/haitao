//
//  UserDetailController.h
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface UserDetailController : UITableViewController<HTTPControllerProtocol,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property(strong,nonatomic) UITableViewCell *selectcedCell;

@end
