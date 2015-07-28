//
//  AddAddressStep2.m
//  haitao
//
//  Created by pwy on 15/7/21.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "AddAddressStep2.h"

@interface AddAddressStep2 ()

@end

@implementation AddAddressStep2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"新增收货人地址";
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
   
    if ([MyUtil isEmptyString:_id]) {
        return;
    }
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app startLoading];
    NSDictionary *parameters = @{@"id":_id};
    
    NSMutableURLRequest *mulRequest;
    if (_uploadStatus_zhengmian==1&&_uploadStatus_fanmian==1) {
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_01" fileName:@"idcard_01.png" mimeType:@"image/png"];
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_02" fileName:@"idcard_02.png" mimeType:@"image/png"];
            
            
        } error:nil];
    }else if (_uploadStatus_zhengmian==1) {//正面上传了
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_zhengmian.image) name:@"idcard_01" fileName:@"idcard_01.png" mimeType:@"image/png"];
            
            
        } error:nil];
        
    }else if (_uploadStatus_fanmian==1){//反面上传了
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImagePNGRepresentation(_idcard_fanmian.image) name:@"idcard_02" fileName:@"idcard_02.png" mimeType:@"image/png"];
            
            
        } error:nil];
        
    }else{
        mulRequest=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestUrl_modifyIdCard parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            ShowMessage(@"上传成功！");
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
    
        NSLog(@"----pass-modify address upolad idcard%@---",@"test");
    }
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
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}



- (IBAction)save:(id)sender {
    [self saveAddress];
}
@end
