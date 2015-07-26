//
//  UserCenterHeader.h
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *user_img;

@property (weak, nonatomic) IBOutlet UILabel *user_name;

- (IBAction)gotoUserDetail:(id)sender;

@end
