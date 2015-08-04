//
//  AddAddressViewController.m
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "AddAddressStep1.h"
#import "AddAddressStep2.h"
#import "AddressModel.h"
@interface AddAddressStep1 ()

@end

@implementation AddAddressStep1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editAddress)];
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editAddress)];
   
    self.title=@"添加收货地址";
    _picker = [[AreaPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 200)];
    
    //填充左边 文字边距
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    
    _consignee.leftView = paddingView;
    
    _consignee.leftViewMode = UITextFieldViewModeAlways;
    
    _province.enabled=NO;
    

}
//当键盘出现或改变时调用
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    if (yOffset<0) {
        yOffset+=30;
    }else{
        yOffset-=30;
    }
    CGRect inputFieldRect = self.view.frame;
    
    inputFieldRect.origin.y += yOffset;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = inputFieldRect;
    }];
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

-(void)editAddress{
    NSLog(@"----pass editAddress%@---",@"test");
}


- (IBAction)textFieldBeginEdit:(id)sender {
    //
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (IBAction)textFieldEndEdit:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)gotoStep2:(id)sender {
    
    // Pass the selected object to the new view controller.
    if ([MyUtil isEmptyString:_consignee.text]) {
        ShowMessage(@"请填写收件人！");
        return;
    }
    if (![MyUtil isValidateTelephone:_mobile.text]) {
        ShowMessage(@"请输入正确的手机号码！");
        return;
    }
    if ([MyUtil isEmptyString:_idcard.text]) {
        ShowMessage(@"请填写身份证号码！");
        return;
    }
    if ([MyUtil isEmptyString:_province.text]) {
        ShowMessage(@"请选择省市区！");
        return;
    }
    if ([MyUtil isEmptyString:_address.text]) {
        ShowMessage(@"请输入详细地址！");
        return;
    }
    if ([MyUtil isEmptyString:_zipcode.text]) {
        ShowMessage(@"请输入邮编！");
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSDictionary *parameters = @{@"consignee":_consignee.text,@"mobile":_mobile.text,@"idcard":_idcard.text,@"province":_province.text,@"address":_address.text,@"zipcode":_zipcode.text,@"is_default":@"1",@"idcard_1":@"",@"idcard_2":@""};
    if (_isFirstAddress==NO) {
        parameters = @{@"consignee":_consignee.text,@"mobile":_mobile.text,@"idcard":_idcard.text,@"province":_province.text,@"address":_address.text,@"zipcode":_zipcode.text,@"idcard_1":@"",@"idcard_2":@""};
    }
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_addAddress withType:POSTURL withPam:parameters withUrlName:@"addAddress"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        AddAddressStep2 *detailViewController =[[AddAddressStep2 alloc] initWithNibName:@"AddAddressStep2" bundle:nil];
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSDictionary *dic=[dictemp objectForKey:@"data"];
        
        AddressModel *model=[AddressModel objectWithKeyValues:dic];
        if (model.id==nil) {
            return;
        }
        detailViewController.id=model.id;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        //通知刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        
        
    
        
    }

}

- (IBAction)areaPick:(id)sender {
    
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSLog(@"----pass-ok%@---",@"test");
        NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
        NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
        
        NSString *provinceStr = [_picker.provinces objectAtIndex: provinceIndex];
        NSString *cityStr = [_picker.city objectAtIndex: cityIndex];
        NSString *districtStr = [_picker.district objectAtIndex:districtIndex];
        
        if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
            cityStr = @"";
            districtStr = @"";
        }
        else if ([cityStr isEqualToString: districtStr]) {
            districtStr = @"";
        }
        
        NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", provinceStr, cityStr, districtStr];
        _province.font=[UIFont systemFontOfSize:12.0];
        _province.text=showMsg;
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:_picker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];

}

- (IBAction)didEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark- Picker Data Source Methods
// returns the number of 'columns' to display.

@end
