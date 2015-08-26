//
//  UpdateAddressForEdit.m
//  haitao
//
//  Created by pwy on 15/7/27.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UpdateAddressForEdit.h"

@interface UpdateAddressForEdit ()

@end

@implementation UpdateAddressForEdit

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
    self.title=@"编辑收货人地址";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAddress)];
    
    _picker=[[AreaPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 200)];
    
    //手势
    UITapGestureRecognizer *click=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickupImage:)];
    click.delegate=self;
    //单指单击
    click.numberOfTouchesRequired = 1; //手指数
    click.numberOfTapsRequired = 1; //tap次数
    
    UITapGestureRecognizer *click2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickupImage:)];
    click2.delegate=self;
    //单指单击
    click2.numberOfTouchesRequired = 1; //手指数
    click2.numberOfTapsRequired = 1; //tap次数
    
    //默认是关闭的 需要开 否则手势无法使用
    _idcard_zhengmian.userInteractionEnabled=YES;
    _idcard_fanmian.userInteractionEnabled=YES;
    
    [_idcard_zhengmian addGestureRecognizer:click];
    [_idcard_fanmian addGestureRecognizer:click2];
    
    //填充左边
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    
    _consignee.leftView = paddingView;
    
    _consignee.leftViewMode = UITextFieldViewModeAlways;
//    _province.enabled=NO;
    _province.delegate=self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    [self areaPick:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWith.constant=SCREEN_WIDTH;
    self.viewHeight.constant=SCREEN_HEIGHT+100;

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)saveAddress{
NSLog(@"----pass-saveAddress %@---",@"test");
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
    if (![MyUtil validateIdentityCard:_idcard.text]) {
        ShowMessage(@"请填写有效身份证号码！");
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
    NSDictionary *parameters = @{@"id":_addressModel.id,@"consignee":_consignee.text,@"mobile":_mobile.text,@"idcard":_idcard.text,@"province":_province.text,@"address":_address.text,@"zipcode":_zipcode.text,@"is_default":_addressModel.is_default};
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyAddress withType:POSTURL withPam:parameters withUrlName:@"modifyAddress"];
    httpController.delegate = self;
    
    if (_uploadStatus_zhengmian==1&&_uploadStatus_fanmian==1) {
        
        [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_1" fileName:@"idcard_1.png" mimeType:@"image/png"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_2" fileName:@"idcard_2.png" mimeType:@"image/png"];
        } error:nil];
        
        
    }else if (_uploadStatus_zhengmian==1) {//正面上传了
        [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_1" fileName:@"idcard_1.png" mimeType:@"image/png"];
        } error:nil];
        
    }else if (_uploadStatus_fanmian==1){//反面上传了
        [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_2" fileName:@"idcard_2.png" mimeType:@"image/png"];
        } error:nil];
    
    }else{
        [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } error:nil];
    
    }
    
    
    
}
-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"modifyAddress"]) {
            //更新上个页面值
            _updateAddress.consignee.text=_consignee.text;
            _updateAddress.idcard.text=_idcard.text;
            _updateAddress.province.text=_province.text;
            _updateAddress.address.text=_address.text;
            _updateAddress.zipcode.text=_zipcode.text;
            _updateAddress.mobile.text=_mobile.text;
            ShowMessage(@"修改成功！");
            
        }else if ([urlname isEqualToString:@"deleteAddress"]){
            ShowMessage(@"删除成功！");
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (IBAction)areaPick:(id)sender {
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0){
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
    }else{
        
        [self showAreaPicker];
    }
    
    
}
-(void)showAreaPicker{
    if (_pickerView !=nil) {
        [self removeAreaPickerView];
        return;
    }
    _pickerView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-47-64)];
    _pickerView.backgroundColor=CLEARCOLOR;
    UIButton *halfButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2-47)];
    
    [halfButton addTarget:self action:@selector(removeAreaPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    [_pickerView addSubview:halfButton];
    UIView *buttom_view=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2-47, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    buttom_view.backgroundColor=[UIColor whiteColor];
    
    [buttom_view addSubview:_picker];
    
    [_pickerView addSubview:buttom_view];
    
    [self.view addSubview:_pickerView];
    
    
    UIButton *button_sure=[[UIButton alloc] initWithFrame:CGRectMake(0, _picker.frame.origin.y+_picker.frame.size.height+5, SCREEN_WIDTH, 30)];
    button_sure.backgroundColor=[UIColor whiteColor];
    [button_sure setTitle:@"确定" forState:UIControlStateNormal];
    [button_sure addTarget:self action:@selector(pickAreaText) forControlEvents:UIControlEventTouchUpInside];
    [button_sure setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    buttom_view.backgroundColor=[UIColor colorWithWhite:1 alpha:1];
    [buttom_view addSubview:button_sure];
    
    UIButton *button_cancel=[[UIButton alloc] initWithFrame:CGRectMake(0, button_sure.frame.origin.y+button_sure.frame.size.height+5, SCREEN_WIDTH, 30)];
    [button_cancel setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    
    button_cancel.backgroundColor=[UIColor whiteColor];
    [button_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [button_cancel addTarget:self action:@selector(removeAreaPickerView) forControlEvents:UIControlEventTouchUpInside];
    [buttom_view addSubview:button_cancel];
    _picker.backgroundColor=[UIColor whiteColor];
    _picker.frame=CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
    
    halfButton.backgroundColor=[UIColor colorWithWhite:0 alpha:0.2];
    
    
    [self MoveView:_pickerView To:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-47-64) During:0.5];
    
}
-(void)removeAreaPickerView{
    [_pickerView removeFromSuperview];
    _pickerView=nil;
}
-(void)pickAreaText{
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
    [self removeAreaPickerView];
    
}
-(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time{
    
    // 动画开始
    
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}

- (IBAction)DidEndOnExit:(id)sender {
}
-(void)pickupImage:(UITapGestureRecognizer *) gr{
//    if (gr.state==UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
    if([gr.view isEqual:_idcard_zhengmian]){
        
        _targetIdex=0;
    }else if([gr.view isEqual:_idcard_fanmian]){
        _targetIdex=1;
    }
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        
        actionSheet.tag=255;
        
        [actionSheet showInView:self.view];
        
        
//    }
//    if (gr.state==UIGestureRecognizerStateChanged) {
//        NSLog(@"UIGestureRecognizerStateChanged");
//    }
//    if (gr.state==UIGestureRecognizerStateEnded) {
//        NSLog(@"UIGestureRecognizerStateEnded");
//    }
}

//actionsheet的delegate事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==255) {
        NSInteger sourceType=0;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    //拍照
                    sourceType=UIImagePickerControllerSourceTypeCamera;

                    break;
                case 1:
                    //相册
                    sourceType=UIImagePickerControllerSourceTypePhotoLibrary;

                    break;
                case 2:
                    //取消
                    return;
                    break;
                default:
                    break;

            }
        }else{
            if (buttonIndex==1) {
                return;
            }else{
                sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
        
        imagePicker.delegate=self;
        
        imagePicker.allowsEditing=YES;
        
        imagePicker.sourceType=sourceType;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
        
    }
    
}
//imagepicker 的delegate事件
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    if(_targetIdex==0){//正面
        //压缩0.5倍以后
        _idcard_zhengmian.image=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
        _uploadStatus_zhengmian=1;
    }else if(_targetIdex==1){
        _idcard_fanmian.image=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
        _uploadStatus_fanmian=1;
    }
    
    
//    //以下afnetworking upload方法－－－－－－－－－begin
//    
//    NSURLSessionConfiguration *config=[NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:config];
//    
//    
//    NSData *imageDate=UIImageJPEGRepresentation(image, 0.5);
//    
//    NSLog(@"----------------length=%d",imageDate.length)
//    
//    NSMutableURLRequest *mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:imageDate name:@"file" fileName:@"temp.png" mimeType:@"image/png"];
//        
//        
//    } error:nil];
//    
//    NSDictionary *dic =[mulRequest allHTTPHeaderFields];
//    
//    NSLog(@"dic=================%@",dic);
//    
//    NSData *data= [mulRequest HTTPBody];
//    
//    NSLog(@"-----%@",data);
//    
//    
//    NSProgress * progress=nil;
//    NSURLSessionUploadTask *uploadTask=[manager uploadTaskWithStreamedRequest:mulRequest progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"%@",error);
//        }else{
//            
//            NSLog(@"%@",@"success!");
//            
//            //获取本地缓冲图片
//            NSString *fullPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"temp.png"];
//            UIImage *tempImage=[[UIImage alloc] initWithContentsOfFile:fullPath];
//            
//            _idcard_zhengmian.image=tempImage;
//        }
//    }];
//    
//    
//    
//    [uploadTask resume];
//    //
//    //以下afnetworking upload方法－－－－－－－－－end
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
