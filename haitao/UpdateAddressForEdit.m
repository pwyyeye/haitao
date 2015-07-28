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
    
    NSMutableURLRequest *mulRequest;
    if (_uploadStatus_zhengmian==1&&_uploadStatus_fanmian==1) {
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_01" fileName:@"idcard_01.png" mimeType:@"image/png"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_02" fileName:@"idcard_02.png" mimeType:@"image/png"];
            
            
                } error:nil];
    }else if (_uploadStatus_zhengmian==1) {//正面上传了
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyAddress parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_01" fileName:@"idcard_01.png" mimeType:@"image/png"];
            
            
        } error:nil];
        
    }else if (_uploadStatus_fanmian==1){//反面上传了
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyAddress parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_02" fileName:@"idcard_02.png" mimeType:@"image/png"];
            
            
        } error:nil];
    
    }else{
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyAddress parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        } error:nil];
    
    }
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyAddress withType:POSTURL withPam:parameters withUrlName:@"modifyAddress"];
    httpController.delegate = self;
    [httpController onFileForPostJson:mulRequest];
    
    
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
-(void)pickupImage:(UITapGestureRecognizer *) gr{
//    if (gr.state==UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
    if([gr.view isEqual:_idcard_zhengmian]){
        
        _targetIdex=0;
    }else if([gr.view isEqual:_idcard_fanmian]){
        _targetIdex=1;
    }
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        
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
                case 1:
                    //取消
                    return;
                    break;
                case 0:
                    //相册
                    sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    
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
        _idcard_zhengmian.image=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.5)];
        _uploadStatus_zhengmian=1;
    }else if(_targetIdex==1){
        _idcard_fanmian.image=[[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.5)];
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
