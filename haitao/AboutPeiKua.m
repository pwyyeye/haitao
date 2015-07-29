//
//  AboutPeiKua.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "AboutPeiKua.h"

@interface AboutPeiKua ()

@end

@implementation AboutPeiKua

- (void)viewDidLoad {
    [super viewDidLoad];
    //代码实现获得应用的Verison号：
    
//    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
   // 或
//    [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
 //   获得build号：
//    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
    self.title=@"关于配夸网";
    _version.text=[NSString stringWithFormat:@"版本号 V%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
