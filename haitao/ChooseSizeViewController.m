//
//  ChooseSizeViewController.m
//  haitao
//
//  Created by SEM on 15/7/30.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//
#define kWindowHeight                       ([[UIScreen mainScreen] bounds].size.height)
#import "ChooseSizeViewController.h"
#import "AttrInfoBtn.h"
#import "SizeModel.h"
#import "GoodsAttrModel.h"
@interface ChooseSizeViewController ()<UITextFieldDelegate>
{
    UIScrollView              *_scrollView;
    UrlImageView *imageV;
    UIView *view_bar1;
    UIButton*btnItem1; //上部五个按钮
    UIButton*btnItem2;
    UIButton*btnItem3;
    UIButton*btnItem4;
    UIButton*btnItem5;
    UIImageView*  tabBarArrow;//上部桔红线条
    UITextField *fromPriceText;//价格
    UITextField *toPriceText;
    UIButton*zhiyouBtn;
    UIButton*zhuanyunBtn;
    UILabel *title_money;//价格
    NSArray *priceArr;
    NSDictionary *chooseDic;
    NSArray *attr_info;
    NSMutableArray *btnArr;
    NSMutableDictionary *attrDic;
    CGRect fFrame;
    UIButton*btnCall;//加入购物车
    UITextField*  numTextField;//数量
    NSMutableDictionary *parameters;
    NSMutableArray *chooseArr;
}
@end

@implementation ChooseSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getToolBar];
    chooseArr=[[NSMutableArray alloc]init];
    parameters = [[NSMutableDictionary alloc]init];
    btnArr =[[NSMutableArray alloc]init];
    attrDic=[[NSMutableDictionary alloc]init];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _scrollView =[[UIScrollView alloc]initWithFrame:(CGRect){0,naviView.frame.size.height+1,self.view.frame.size.width,kWindowHeight-naviView.frame.size.height-49}];
    fFrame=_scrollView.frame;
    priceArr=[self.goods_attr objectForKey:@"price_cn"];
    attr_info=[self.goods_attr objectForKey:@"attr_info"];
//    [_scrollView setBackgroundColor:[UIColor grayColor]];
    //    _tableView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:_scrollView];
    [self initView];
    // Do any additional setup after loading the view.
}
#pragma mark - 初始化页面
-(void)initView{
    UrlImageButton *urlImageView=[[UrlImageButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    urlImageView.enabled=false;
    NSURL *url =[NSURL URLWithString:self.goods.img_260];
    [urlImageView setImageWithURL:url];
    urlImageView.backgroundColor=[UIColor clearColor];
    [_scrollView addSubview:urlImageView];
    //商品信息
    UIView  *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, urlImageView.frame.size.height+urlImageView.frame.origin.y, self.view.frame.size.width,45)];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width*2/3-5, 15)];
    title_label.text=self.goods.title;
    title_label.font=[UIFont boldSystemFontOfSize:15];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1.0];
    title_label.textAlignment=NSTextAlignmentCenter;
    title_label.numberOfLines = 0;
    CGRect txtFrame = title_label.frame;
    
     title_label.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
     txtFrame.size.height =[title_label.text boundingRectWithSize:
     CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
     attributes:[NSDictionary dictionaryWithObjectsAndKeys:title_label.font,NSFontAttributeName, nil] context:nil].size.height);
    title_label.frame = txtFrame;
    

    [nameView insertSubview:title_label atIndex:0];
    
    
    
    title_money=[[UILabel alloc]initWithFrame:CGRectMake(title_label.frame.origin.x+title_label.frame.size.width+5, 5, 100, 25)];
    NSString *ss=[NSString stringWithFormat:@"%.f",self.goods.price_cn];
    chooseDic=@{@"price":ss};
    title_money.text=[NSString stringWithFormat:@"%@%@",@"￥",ss];
    title_money.textColor=[UIColor whiteColor];
    title_money.font=[UIFont systemFontOfSize:12];
    title_money.backgroundColor=[UIColor redColor];
//    title_money.textColor =hongShe;
    title_money.textAlignment=1;
    [nameView insertSubview:title_money atIndex:0];
    
    [_scrollView addSubview:nameView];
    //温馨提示
    //邮费重量
    UIView *yunfeiView=[[UIView alloc]initWithFrame:CGRectMake(0, nameView.frame.size.height+nameView.frame.origin.y, self.view.frame.size.width, 30)];
    yunfeiView.backgroundColor=hui2;
    UILabel *yunfeititle=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 20)];
    yunfeititle.text=@"温馨提示:商品尺寸参数均来自国外,仅供参考。";
    yunfeititle.font=[UIFont systemFontOfSize:12];
    yunfeititle.backgroundColor=[UIColor clearColor];
    yunfeititle.textColor =[UIColor blackColor];
    yunfeititle.textAlignment=1;
    [yunfeiView addSubview:yunfeititle];
    [_scrollView addSubview:yunfeiView];
    //颜色尺寸
    CGRect lastFrame=CGRectMake(0, yunfeiView.frame.size.height+yunfeiView.frame.origin.y+10, self.view.frame.size.width, 20);
    if(attr_info==nil){
        btnCall.enabled=true;
    }
    for (int i=0; i<attr_info.count; i++){
        NSDictionary *dic=attr_info[i];
        NSString *name =[dic objectForKey:@"name"];
        NSString *attr_id =[dic objectForKey:@"id"];
        NSArray *childArr=[dic objectForKey:@"child"];
        UILabel *ys_label=[[UILabel alloc]initWithFrame:lastFrame];
        ys_label.text=name;
        ys_label.font=[UIFont systemFontOfSize:18];
        ys_label.textColor =hui2;
        ys_label.backgroundColor=[UIColor clearColor];
        ys_label.textAlignment=1;
        [_scrollView addSubview:ys_label];
        NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
        NSString *ssTemp=@"";
        for (int j=0; j<childArr.count; j++)
        {
            NSDictionary *childDic=childArr[j];
            SizeModel *sizeModel=[SizeModel objectWithKeyValues:childDic];
            sizeModel.attr_name=name;
            sizeModel.attr_id=attr_id;
            AttrInfoBtn *aiBtn=[[AttrInfoBtn alloc]initWithFrame:CGRectMake((j%4)*(320-15)/4+10, floor(j/4)*(320)/10+5+ys_label.frame.size.height+ys_label.frame.origin.y+5, (320-30-15)/4, (320-30-15)/10)];
            sizeModel.isflag=false;
            aiBtn.sizeModel=sizeModel;
            aiBtn.backgroundColor=[UIColor whiteColor];
            aiBtn.layer.borderWidth=1;
            aiBtn.layer.cornerRadius = 4;
            aiBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            aiBtn.layer.borderColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0].CGColor;
            aiBtn.tag=i+1000;
            [aiBtn setTitle:sizeModel.name forState:0];
            [aiBtn setTitleColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0] forState:0];
            [aiBtn addTarget:self action:@selector(btnNine:) forControlEvents:UIControlEventTouchUpInside];
            lastFrame=CGRectMake(0, aiBtn.frame.size.height+aiBtn.frame.origin.y+10, self.view.frame.size.width, 20);
            [_scrollView addSubview:aiBtn];
            [btnArr addObject:aiBtn];
            [arrTemp addObject:aiBtn];
            ssTemp=[NSString stringWithFormat:@"%ld",aiBtn.tag];
        }
        [attrDic setValue:arrTemp forKey:ssTemp];
    }
    
    UILabel *sl_label=[[UILabel alloc]initWithFrame:CGRectMake(0, lastFrame.size.height+lastFrame.origin.y, self.view.frame.size.width, 20)];
    sl_label.text=@"数量";
    sl_label.font=[UIFont systemFontOfSize:18];
    sl_label.textColor =hui2;
    sl_label.backgroundColor=[UIColor clearColor];
    sl_label.textAlignment=1;
    
    [_scrollView addSubview:sl_label];
    //按钮
    //减
    UIButton *btnCut=[UIButton buttonWithType:0];
    btnCut.frame=CGRectMake(10, sl_label.frame.size.height+sl_label.frame.origin.y, 35, 35);
    btnCut.tag=-99;
    [btnCut setImage:BundleImage(@"bt_01_.png") forState:0];
    [btnCut addTarget:self action:@selector(btnCut:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:btnCut];
    
    numTextField=[[UITextField alloc]initWithFrame:CGRectMake(btnCut.frame.size.width+btnCut.frame.origin.x+1, btnCut.frame.origin.y+3,59,28)];
    numTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    numTextField.textAlignment=1;
    numTextField.delegate=self;
    numTextField.returnKeyType=UIReturnKeyDone;
    numTextField.text=self.numCount;
    numTextField.textColor=[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
    numTextField.tag=-100;
    numTextField.keyboardType=UIKeyboardTypeDefault;
    numTextField.userInteractionEnabled=YES;
    //        numTextField.background=BundleImage(@"number_frame.png");
    numTextField.layer.borderColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0].CGColor;
    numTextField.layer.borderWidth=1;
    numTextField.backgroundColor=[UIColor whiteColor];
    [numTextField addTarget:self action:@selector(textFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [numTextField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_scrollView addSubview:numTextField];
    
    
    //加
    UIButton *btnAdd=[UIButton buttonWithType:0];
    btnAdd.frame=CGRectMake(numTextField.frame.origin.x+numTextField.frame.size.width+3,btnCut.frame.origin.y+3, 30, 28);
    [btnAdd setBackgroundImage:BundleImage(@"bt_02_.png") forState:0];
    [btnAdd addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
    if (btnAdd.highlighted) {
        [btnAdd setBackgroundImage:BundleImage(@"number_up_click.png") forState:0];
    }
    btnAdd.tag=-101;
    [_scrollView addSubview:btnAdd];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, btnAdd.frame.size.height+btnAdd.frame.origin.y+10)];
   
}
#pragma mark 减
-(void)btnCut:(id)sender
{
    UITextField*field=(UITextField* )[_scrollView viewWithTag:-100 ];
    if ([field.text intValue]>1) {
        field.text=[NSString stringWithFormat:@"%d",[field.text intValue]-1];
    }
    NSString *nowPri=[chooseDic objectForKey:@"price"];
    title_money.text=[NSString stringWithFormat:@"%@%@",@"￥",nowPri];
    
}

#pragma mark 加
-(void)btnAdd:(id)sender
{
    
    UITextField*field=(UITextField* )[_scrollView viewWithTag:-100];
    field.text=[NSString stringWithFormat:@"%d",[field.text intValue]+1];
    NSString *nowPri=[chooseDic objectForKey:@"price"];
    title_money.text=[NSString stringWithFormat:@"%@%@",@"￥",nowPri];
}
#pragma mark - 尺寸颜色等按钮事件
-(void)btnNine:(id)sender
{
    
    AttrInfoBtn *button=(AttrInfoBtn*)sender;
    SizeModel *sizeMode= button.sizeModel;
    sizeMode.isflag=!sizeMode.isflag;
    NSString *ssTemp=[NSString stringWithFormat:@"%ld",button.tag];
    NSArray *arrTemp=[attrDic objectForKey:ssTemp];
    NSString *sid=sizeMode.id;
    if(sizeMode.isflag){
        for (int i=0; i<arrTemp.count; i++) {
            AttrInfoBtn *buttonTemp=(AttrInfoBtn*)arrTemp[i];
            SizeModel *sizeModeTemp= buttonTemp.sizeModel;
            NSString *sidTemp=sizeModeTemp.id;
            if(![sid isEqualToString:sidTemp]){
                sizeModeTemp.isflag=false;
            }
            
        }

    }
    for (int i=0; i<arrTemp.count; i++) {
        AttrInfoBtn *buttonTemp=(AttrInfoBtn*)arrTemp[i];
        SizeModel *sizeModeTemp= buttonTemp.sizeModel;
        if(sizeModeTemp.isflag){
            [buttonTemp setTitleColor:[UIColor whiteColor] forState:0];
            buttonTemp.backgroundColor=hongShe;
        }else{
          [buttonTemp setTitleColor:[UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0] forState:0];
            buttonTemp.backgroundColor=[UIColor whiteColor];
        }
    }
    //判断条件是否都选上了
    NSArray *keyArr = [attrDic allKeys];
    bool isChoose=false;
    [chooseArr removeAllObjects];
    for (int i=0; i<keyArr.count; i++) {
        NSString *keyStr=keyArr[i];
        NSArray *vluArr=[attrDic objectForKey:keyStr];
        for (int j=0; j<vluArr.count; j++) {
            AttrInfoBtn *buttonTemp=(AttrInfoBtn*)vluArr[j];
            SizeModel *sizeModeTemp= buttonTemp.sizeModel;
            if(sizeModeTemp.isflag){
                isChoose=true;
                [chooseArr addObject:sizeModeTemp];
                break;
            }
        }
        if(!isChoose){
            btnCall.enabled=false;
            break;
        }else{
            if(i!=keyArr.count-1){
                isChoose=false;
            }
        }
        
    }
    //判断当前价格
    if(isChoose){
        btnCall.enabled=true;
        NSMutableArray *idStrArr=[[NSMutableArray alloc]init];
        for (int i=0; i<chooseArr.count; i++) {
            SizeModel *sizeModeTemp=chooseArr[i];
            NSString *sid=sizeModeTemp.id;
            [idStrArr addObject:sid];
        }
        for (int i=0; i<priceArr.count; i++) {
            NSDictionary *picDic=priceArr[i];
            NSString *attr_values=[picDic objectForKey:@"attr_values"];
            BOOL idpipei =true;
            for (NSString *ssTemp in idStrArr) {
                NSRange range = [attr_values rangeOfString:ssTemp];
                if (range.length > 0)
                {
                    
                }else{
                    idpipei =false;
                    break;
                }
                
            }
            if(idpipei){
                chooseDic=picDic;
                break;
            }
        }
        //赋值
        //
        NSString *nowPri=[chooseDic objectForKey:@"price"];
        title_money.text=[NSString stringWithFormat:@"%@%@",@"￥",nowPri];
    }
}

#pragma mark - Navigation//工具栏

-(UIView *)getToolBar
{
    UIView *view_bar =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    view_bar.backgroundColor=[UIColor whiteColor];
    view_bar.layer.borderColor=[UIColor colorWithRed:.9 green:.9  blue:.9  alpha:1.0].CGColor;
    view_bar.layer.borderWidth=1;
    [self.view addSubview:view_bar];
    
    btnCall=[UIButton buttonWithType:0];
    btnCall.frame=CGRectMake(0, 0, self.view.frame.size.width, 49);
    btnCall.backgroundColor=[UIColor redColor];
    [btnCall setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnCall addTarget:self action:@selector(addCar:) forControlEvents:UIControlEventTouchUpInside];
    btnCall.enabled=false;
//    [btnCall setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:btnCall];
 
    return view_bar;
}
#pragma mark - Navigation
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>6.1)
    {
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);
        UIImageView *imageVV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 44+20)];
        imageVV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageVV];
        
        
    }else{
        view_bar1 .frame=CGRectMake(0, 0, self.view.frame.size.width,44);
        UIImageView *imageVV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,44)];
        imageVV.image = BundleImage(@"top.png");
        [view_bar1 addSubview:imageVV];
        
    }
    view_bar1.backgroundColor=[UIColor clearColor];
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"选择商品属性/数量";
    title_label.font=[UIFont boldSystemFontOfSize:20];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(0, view_bar1.frame.size.height-34, 47, 34);
    [btnBack setImage:BundleImage(@"left_grey") forState:0];
    [btnBack addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    [view_bar1 addSubview:btnBack];
    return view_bar1;
}
#pragma mark - 后退
-(void)btnBack:(id)sender
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 加入购物车
-(void)addCar:(id)sender{
    [parameters removeAllObjects];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:chooseDic];
    [dic setObject:numTextField.text forKey:@"buy_num"];
    
    
    [parameters setObject:self.goods.id forKey:@"goods_id"];
    [parameters setObject:[dic objectForKey:@"buy_num"] forKey:@"buy_num"];
    if([dic objectForKey:@"id"]){
        [parameters setObject:[dic objectForKey:@"id"] forKey:@"attr_price_id"];
    }

    if(self.ischange){
         NSMutableDictionary *dicTemp=[[NSMutableDictionary alloc]initWithDictionary:parameters];
        NSMutableArray *childListTemp=[[NSMutableArray alloc]init];
        for (SizeModel *sizeModel in chooseArr) {
            NSMutableDictionary *dicChiledtemp=[[NSMutableDictionary alloc]init];
            [dicChiledtemp setObject:sizeModel.attr_name forKey:@"attr_name"];
            [dicChiledtemp setObject:sizeModel.attr_id forKey:@"attr_id"];
            [dicChiledtemp setObject:sizeModel.name forKey:@"attr_val_name"];
            [childListTemp addObject:dicChiledtemp];
        }
        [dicTemp setObject:childListTemp forKey:@"goods_attr"];
        [self.delegate addShopCarFinsh:dicTemp];
       
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.navigationController popViewControllerAnimated:YES];
    }else{
        NSString* url =[NSString stringWithFormat:@"%@&f=addCart&m=cart",requestUrl]
        ;
        
        HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"addCart"];
        httpController.delegate = self;
        [httpController onSearchForPostJson];
    }
    
}

#pragma mark - 数字文本框处理
- (void) textFieldBegin:(id)sender
{
    UITextField *t = (UITextField*)sender;
    NSLog(@"%ld",t.tag);
    
}


- (void) textFieldDone:(id)sender
{
    [self keyboardWillHide:Nil];
    [sender resignFirstResponder];
    
}
#pragma mark - 文本输入不被按键挡住
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _scrollView.frame = fFrame;
    [UIView commitAnimations];
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    //    if ([_confirmPwdTextfield isFirstResponder]) {
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = _scrollView.frame;
    frame.origin.y =frame.origin.y -230;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    _scrollView.frame = frame;
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self keyboardWillHide:nil];
    
    
    
    //    }
    
    
}

//利用正则表达式验证
-(BOOL)isValidateNumber:(NSString *)number
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [self isValidateNumber:string];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self keyboardWillShow:nil];

}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSNumber *status=[dictemp objectForKey:@"status"];
    if([urlname isEqualToString:@"addCart"]){
        if(status.intValue==1){
            [self.delegate addShopCarFinsh:nil];
            AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
            [app.navigationController popViewControllerAnimated:YES];
        }
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
