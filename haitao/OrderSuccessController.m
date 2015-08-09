//
//  OrderSuccessController.m
//  haitao
//
//  Created by pwy on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "OrderSuccessController.h"
#import "OrderListController.h"
@interface OrderSuccessController ()

@end

@implementation OrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"支付成功";
    _orderNo.text=_orderNoString;
    _payAmount.text=_payAmountString;
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

- (IBAction)gotoOrder:(id)sender {
    UIViewController *detailViewController;
   
    detailViewController  = [[OrderListController alloc] init];
        
    AppDelegate *delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
    delegate.navigationController.navigationItem.backBarButtonItem=item;
    [delegate.navigationController pushViewController:detailViewController animated:YES];

}
- (IBAction)gotoSearch:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
}

- (IBAction)gotoHome:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backHome" object:nil];
}
@end
