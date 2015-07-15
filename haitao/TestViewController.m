//
//  TestViewController.m
//  haitao
//
//  Created by SEM on 15/7/15.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "TestViewController.h"
#import "Test1ViewController.h"
@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)Btt:(id)sender {
    Test1ViewController *testViewController=[[Test1ViewController alloc]initWithNibName:@"Test1ViewController" bundle:nil];
    [self.navigationController pushViewController:testViewController animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeTabType"object:nil];
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
