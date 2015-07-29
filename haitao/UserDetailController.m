//
//  UserDetailController.m
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "UserDetailController.h"

@interface UserDetailController ()

@end

@implementation UserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //是否显示navigationBar
    [self.navigationController setNavigationBarHidden:NO];
    //navigationBar 背景色
    self.navigationController.navigationBar.barTintColor=RGB(255, 13, 94);
    //若为yesnavigationBar背景 会有50％的透明
    self.navigationController.navigationBar.translucent = NO;
    
    //返回值
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:item];
    
    //返回的颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //navigationBar的标题
    //self.navigationItem.title=@"登录";
    self.title=@"个人信息";
    
    //设置标题颜色
    
    UIColor * color = [UIColor whiteColor];
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置电池状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent] ;
    
    
    self.tableView.backgroundColor=RGB(237, 237, 237);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//无分割线
    
    self.tableView.tableFooterView=[[UIView alloc]init];//去掉多余的分割线

}
-(void)gotoBack
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
//    UIView *view = [UIView new];
//    
//    view.backgroundColor = [UIColor clearColor];
//    
//    [tableView setTableFooterView:view];
//    [tableView setTableHeaderView:view];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%d",section);
//    if (section==0) {
//        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine ;
//    }else{
//        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    }
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==0) {
        return 80;
    }
    return 50;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, indexPath.item==0?25:10, 60, 30)];
    label.font=[UIFont systemFontOfSize:13.0];
    
    label.tag=200+indexPath.item;
    
    if (indexPath.item==0) {
        label.text=@"修改头像";
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.image=[UIImage imageNamed:@"default_04.png"];
        
        if (![MyUtil isEmptyString:[USER_DEFAULT objectForKey:@"avatar_img"]]) {
            NSURL *url=[NSURL URLWithString:[USER_DEFAULT objectForKey:@"avatar_img"]];
            [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_04.png"]];
        }
//        CALayer *layerShadow=[[CALayer alloc]init];
//        layerShadow.frame=CGRectMake(120,cell.frame.size.height+5,cell.frame.size.width,1);
//        layerShadow.borderColor=[RGB(237, 223, 223) CGColor];
//        layerShadow.borderWidth=1;
//        [cell.layer addSublayer:layerShadow];
        
        cell.tag=100+indexPath.item;
        
    }else{
        cell.textLabel.text=[USER_DEFAULT objectForKey:@"user_nick"];
        label.text=@"修改昵称";
    }
    [cell.contentView addSubview:label];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item==0) {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        
        actionSheet.tag=255;
        
        [actionSheet showInView:self.view];
        
        
        
        _selectcedCell=[tableView viewWithTag:100+indexPath.item];
        _selectedLabel=[_selectcedCell viewWithTag:200+indexPath.item];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改昵称"
                               
                                                        message:@""
                               
                                                       delegate:self
                               
                                              cancelButtonTitle:@"取消"
                               
                                              otherButtonTitles:@"确定",nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField * text1 = [alert textFieldAtIndex:0];
        
        text1.text=[USER_DEFAULT objectForKey:@"user_nick"];
        text1.keyboardType = UIKeyboardTypeDefault;
        
        [alert show];
    }
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    UITextField *tf=[alertView textFieldAtIndex:0];
    
    if ([MyUtil isEmptyString:tf.text] || [tf.text isEqualToString:[USER_DEFAULT objectForKey:@"user_nick"]]) {
        return;
    }
    
    NSLog(@"----pass-pass%@---",tf.text);
    _modifyNick=tf.text;
    
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyUserNick withType:POSTURL withPam:@{@"user_nick":tf.text} withUrlName:@"modifyNick"];
    httpController.delegate = self;
    
    [httpController onSearchForPostJson];


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    // UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];//原始图
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(120, 120));  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, 120, 120)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _selectcedCell.imageView.image=scaledImage ;


    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_modifyUserAvatar withType:POSTURL withPam:nil withUrlName:@"modifyAvata"];
    httpController.delegate = self;
    
    [httpController onFileForPostJson:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(scaledImage) name:@"avatar_img" fileName:@"avatar_img.png" mimeType:@"image/png"];
    } error:nil];


}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];

}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    
    NSLog(@"----pass-userdetail%@---",dictemp);
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        
        if ([urlname isEqualToString:@"modifyAvata"]) {
            //更新上个页面值
            ShowMessage(@"修改成功！");
            [USER_DEFAULT setObject:[dictemp objectForKey:@"data"] forKey:@"avatar_img"];
        }else if([urlname isEqualToString:@"modifyNick"]){
            ShowMessage(@"修改成功！");
            _selectedLabel.text=_modifyNick;
            [USER_DEFAULT setObject:_modifyNick  forKey:@"user_nick"];

            
        
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noticeToReload" object:nil];
//        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark - UIActionSheetDelegate
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
@end
