//
//  UpdateAddress.m
//  haitao
//
//  Created by pwy on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UpdateAddress.h"

@interface UpdateAddress ()

@end

@implementation UpdateAddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_addressModel!=nil) {
        _consignee.text=_addressModel.consignee;
        _mobile.text=_addressModel.mobile;
        _idcard.text=_addressModel.idcard;
        _province.text=_addressModel.province;
        _address.text=_addressModel.address;
        _zipcode.text=_addressModel.zipcode;
    }
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
