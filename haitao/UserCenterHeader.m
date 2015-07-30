//
//  UserCenterHeader.m
//  haitao
//
//  Created by pwy on 15/7/24.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UserCenterHeader.h"
#import "UserDetailController.h"
#import "Setting.h"
@implementation UserCenterHeader

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"UserCenterHeader" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionReusableView类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UserCenterHeader class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
- (IBAction)gotoUserDetail:(id)sender {
    
    UIViewController *detailViewController=[[UserDetailController alloc] init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    app.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [app.navigationController pushViewController:detailViewController animated:YES];
    
}

- (IBAction)gotoSetting:(id)sender {
    Setting *detailViewController=[[Setting alloc] init];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    app.navigationController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [app.navigationController pushViewController:detailViewController animated:YES];
}
@end
