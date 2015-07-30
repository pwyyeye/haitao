//
//  ServiceTerms.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "ServiceTerms.h"

@interface ServiceTerms ()

@end

@implementation ServiceTerms

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"配夸服务条款";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWith.constant=SCREEN_WIDTH;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
