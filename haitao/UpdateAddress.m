//
//  UpdateAddress.m
//  haitao
//
//  Created by pwy on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UpdateAddress.h"
#import "UpdateAddressForEdit.h"

@interface UpdateAddress ()

@end

@implementation UpdateAddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_addressModel!=nil) {
        _id=_addressModel.id;
        _consignee.text=_addressModel.consignee;
        _mobile.text=_addressModel.mobile;
        _idcard.text=_addressModel.idcard;
        _province.text=_addressModel.province;
        _address.text=_addressModel.address;
        _zipcode.text=_addressModel.zipcode;
    }
    //不可编辑
    _province.enabled=NO;
    _consignee.enabled=NO;
    _mobile.enabled=NO;
    _address.enabled=NO;
    _idcard.enabled=NO;
    _zipcode.enabled=NO;
    
    self.title=@"编辑收货人地址";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(gotoEdit)];
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

- (IBAction)setToDefault:(id)sender {
    NSLog(@"----pass-setToDefault%@---",@"test");
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSDictionary *parameters = @{@"id":_id};
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_setDefaultAddress withType:POSTURL withPam:parameters withUrlName:@"setDefaultAddress"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}

- (IBAction)deleteAddress:(id)sender {
    NSLog(@"----pass-deleteAddress  %@---",@"test");
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    
    NSDictionary *parameters = @{@"id":_id};
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_delAddress withType:POSTURL withPam:parameters withUrlName:@"deleteAddress"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"setDefaultAddress"]) {
            ShowMessage(@"设置成功！");
        }else if ([urlname isEqualToString:@"deleteAddress"]){
            ShowMessage(@"删除成功！");
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }


}

-(void)gotoEdit{
    UpdateAddressForEdit *detailViewController=[[UpdateAddressForEdit alloc] initWithNibName:@"UpdateAddressForEdit" bundle:nil];
    detailViewController.addressModel=self.addressModel;
    detailViewController.updateAddress=self;
    // Push the view controller.
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil  action:nil]];
    [self.navigationController pushViewController:detailViewController animated:YES];

}
@end
