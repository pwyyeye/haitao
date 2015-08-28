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
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SizeViewController.h"
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
    [self.view setBackgroundColor:RGB(237,237,237)];    
    chooseArr=[[NSMutableArray alloc]init];
    parameters = [[NSMutableDictionary alloc]init];
    btnArr =[[NSMutableArray alloc]init];
    attrDic=[[NSMutableDictionary alloc]init];
    UIView *naviView=(UIView*) [self getNavigationBar];
    _scrollView =[[UIScrollView alloc]initWithFrame:(CGRect){12,naviView.frame.size.height+10,self.view.frame.size.width-24,kWindowHeight-naviView.frame.size.height-59}];
    _scrollView.userInteractionEnabled=YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    fFrame=_scrollView.frame;
    _scrollView.backgroundColor=RGB(237,237,237);
     _scrollView.bounces=NO;
    
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
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, 100)];
    topView.layer.borderWidth=1;
    topView.layer.cornerRadius = 3;
    topView.layer.masksToBounds=YES;
    topView.layer.borderColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0].CGColor;
    topView.backgroundColor=[UIColor whiteColor];
    [_scrollView addSubview:topView];
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-24, SCREEN_WIDTH-84)];
    NSLog(@"----pass-goods.img_450%@---",self.goods.img_260);
    [imageView setImageWithURL:[NSURL URLWithString:self.goods.img_260] placeholderImage:[UIImage imageNamed:@"default_01"]];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    imageView.layer.borderWidth=0.3;
    imageView.layer.borderColor=RGB(237, 237, 237).CGColor;
   
    [topView addSubview:imageView];
    //商品信息
    UIView  *nameView=[[UIView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y, _scrollView.frame.size.width,45)];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, _scrollView.frame.size.width*2/3-5, 15)];
    title_label.text=self.goods.title;
    title_label.font=[UIFont boldSystemFontOfSize:13];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor colorWithRed:.3 green:.3 blue:.3 alpha:1.0];
    title_label.textAlignment=NSTextAlignmentLeft;
    title_label.numberOfLines = 2;
    CGRect txtFrame = title_label.frame;
    
     title_label.frame = CGRectMake(txtFrame.origin.x, txtFrame.origin.y, txtFrame.size.width,
     txtFrame.size.height =[title_label.text boundingRectWithSize:
     CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
     attributes:[NSDictionary dictionaryWithObjectsAndKeys:title_label.font,NSFontAttributeName, nil] context:nil].size.height);
    title_label.frame = txtFrame;
    

    [nameView insertSubview:title_label atIndex:0];
    
    
    
    title_money=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-105, 20, 75, 30)];
    title_money.layer.masksToBounds=YES;
    title_money.layer.cornerRadius=3;
    NSString *ss=[NSString stringWithFormat:@"%.2f",self.goods.price_cn];
    chooseDic=@{@"price":ss};
    title_money.text=[NSString stringWithFormat:@"%@%@",@"￥",ss];
    title_money.textColor=RGB(255, 13, 94);
    title_money.font=[UIFont boldSystemFontOfSize:13];
    title_money.backgroundColor=[UIColor clearColor ];
//    title_money.textColor =hongShe;
    title_money.textAlignment=1;
    [nameView insertSubview:title_money atIndex:0];
    
    [topView addSubview:nameView];
    //温馨提示
    //邮费重量
    UIView *yunfeiView=[[UIView alloc]initWithFrame:CGRectMake(0, nameView.frame.size.height+nameView.frame.origin.y+15, _scrollView.frame.size.width, 30)];
    yunfeiView.backgroundColor=hexColor(@"#ffe0eb");
    UILabel *yunfeititle=[[UILabel alloc]initWithFrame:CGRectMake(yunfeiView.frame.origin.x+5, 5, _scrollView.frame.size.width-40, 20)];
    yunfeititle.text=@"温馨提示:商品尺寸参数均来自国外,仅供参考。";
    yunfeititle.font=[UIFont systemFontOfSize:10];
    yunfeititle.backgroundColor=[UIColor clearColor];
    yunfeititle.textColor =RGB(175, 104, 122);
    yunfeititle.textAlignment=0;
    [yunfeiView addSubview:yunfeititle];
    [topView addSubview:yunfeiView];
    topView.height=yunfeiView.top+yunfeiView.height;
    
    UIButton *chima=[[UIButton alloc]initWithFrame:CGRectMake(yunfeititle.frame.size.width-40,nameView.frame.size.height+nameView.frame.origin.y+20,45, 20)];
    
    chima.titleLabel.font=[UIFont systemFontOfSize:11.0];
    [chima setTitle:@"尺码说明" forState:UIControlStateNormal];
    [chima setTitleColor:RGB(24, 177, 18) forState:UIControlStateNormal];
    [chima addTarget:self action:@selector(gotoChima) forControlEvents:UIControlEventTouchUpInside];

    [topView addSubview:chima];
    //    CGRect lastFrame=CGRectMake(0, topView.frame.size.height+topView.frame.origin.y, _scrollView.frame.size.width, 20);
    
    UIView *guige= [[UIView alloc] initWithFrame:CGRectMake(0, topView.height+10, SCREEN_WIDTH-24, 100)];
    guige.layer.masksToBounds=YES;
    guige.layer.cornerRadius = 3;
    guige.backgroundColor=[UIColor whiteColor];
    if(attr_info==nil){
        btnCall.selected=true;
//        btnCall.enabled=true;
        guige.frame=CGRectMake(0, topView.height+10, SCREEN_WIDTH, 0);
    }else{
        if(attr_info.count>0){
            float biaoti=10;
            for (int i=0; i<attr_info.count; i++){
                
                NSDictionary *dic=attr_info[i];
                NSString *name =[dic objectForKey:@"name"];
                NSString *attr_id =[dic objectForKey:@"id"];
                NSArray *childArr=[dic objectForKey:@"child"];
                UILabel *ys_label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-62, biaoti, 100, 20)];
                //规格Y坐标
                biaoti+=40;
                
                ys_label.text=name;
                ys_label.font=[UIFont boldSystemFontOfSize:13];
                ys_label.textColor =hui2;
                ys_label.backgroundColor=[UIColor clearColor];
                ys_label.textAlignment=NSTextAlignmentCenter;
                [guige addSubview:ys_label];
                NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
                NSString *ssTemp=@"";
                for (int j=0; j<childArr.count; j++)
                {
                    NSDictionary *childDic=childArr[j];
                    SizeModel *sizeModel=[SizeModel objectWithKeyValues:childDic];
                    sizeModel.attr_name=name;
                    sizeModel.attr_id=attr_id;
                    AttrInfoBtn *aiBtn=[[AttrInfoBtn alloc]initWithFrame:CGRectMake((j%3)*(SCREEN_WIDTH-44)/3+10, floor(j/3)*(SCREEN_WIDTH)/10+5+ys_label.frame.size.height+ys_label.frame.origin.y+5, (SCREEN_WIDTH-30-15)/3-5, (SCREEN_WIDTH-30-15)/10)];
                    
                    if ((j+1)%3==0) {
                        biaoti+=(SCREEN_WIDTH-30-15)/10+10;
                    }
                    if (j==childArr.count-1&&(j+1)%3!=0) {
                        biaoti+=(SCREEN_WIDTH-30-15)/10+10;
                        
                        
                    }
                    if (j==childArr.count-1) {
                        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, biaoti-10, _scrollView.frame.size.width, 10)];
                        label.backgroundColor=RGB(237, 237, 237);
                        [guige addSubview:label];
                    }
                    CGSize imageSize = CGSizeMake(aiBtn.width, aiBtn.height);
                    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
                    [RGB(237, 237, 237) set];
                    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
                    UIImage *normalImg = UIGraphicsGetImageFromCurrentImageContext();
                    
                    [aiBtn setBackgroundImage:normalImg forState:UIControlStateDisabled];
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
                    
                    
                //设置关联按钮
                    NSString *aiBtnId=sizeModel.id;
                    NSMutableArray *guanglianArr=[[NSMutableArray alloc]init];
                    for (int z=0; z<priceArr.count; z++) {
                        NSDictionary *picDic=priceArr[z];
                        NSString *attr_values=[picDic objectForKey:@"attr_values"];
                        NSRange range = [attr_values rangeOfString:aiBtnId];
                        if (range.length > 0)
                        {
                            [guanglianArr addObject:attr_values];
                        }

                    }
                    
                    aiBtn.guanlianArr=guanglianArr;
                    //判断是否有货
                    if(guanglianArr.count<1){
                        aiBtn.enabled=false;
                    }
                    [guige addSubview:aiBtn];
                    [btnArr addObject:aiBtn];
                    [arrTemp addObject:aiBtn];
                    ssTemp=[NSString stringWithFormat:@"%ld",aiBtn.tag];
                }
                [attrDic setValue:arrTemp forKey:ssTemp];
            }
            guige.frame=CGRectMake(guige.frame.origin.x, guige.frame.origin.y, SCREEN_WIDTH-24, biaoti);

        }

    }
    [_scrollView addSubview:guige];
    
    //数量区域
    UIView *numberView=[[UIView alloc] initWithFrame:CGRectMake(0, guige.frame.size.height+guige.frame.origin.y, _scrollView.frame.size.width, 100)];
    
    numberView.backgroundColor=[UIColor whiteColor];
    numberView.layer.cornerRadius = 3;
    numberView.layer.masksToBounds=YES;
    
    UILabel *sl_label=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, _scrollView.frame.size.width, 20)];
    sl_label.text=@"数量";
    sl_label.font=[UIFont systemFontOfSize:13];
    sl_label.textColor =hui2;
    sl_label.backgroundColor=[UIColor clearColor];
    sl_label.textAlignment=NSTextAlignmentCenter;
    [numberView addSubview:sl_label];
    //按钮
    //减
    UIButton *btnCut=[UIButton buttonWithType:0];
    btnCut.frame=CGRectMake(SCREEN_WIDTH/2-95, sl_label.frame.size.height+sl_label.frame.origin.y+10, 30, 30);
    btnCut.tag=-99;
    [btnCut setImage:BundleImage(@"减号") forState:0];
    [btnCut addTarget:self action:@selector(btnCut:) forControlEvents:UIControlEventTouchUpInside];
    
    [numberView addSubview:btnCut];
    
    numTextField=[[UITextField alloc]initWithFrame:CGRectMake(btnCut.frame.size.width+btnCut.frame.origin.x, btnCut.frame.origin.y,110,30)];
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
    [numberView addSubview:numTextField];
    
    
    //加
    UIButton *btnAdd=[UIButton buttonWithType:0];
    btnAdd.frame=CGRectMake(numTextField.frame.origin.x+numTextField.frame.size.width,btnCut.frame.origin.y, 30, 30);
    [btnAdd setBackgroundImage:BundleImage(@"加号") forState:0];
    [btnAdd addTarget:self action:@selector(btnAdd:) forControlEvents:UIControlEventTouchUpInside];
    if (btnAdd.highlighted) {
        [btnAdd setBackgroundImage:BundleImage(@"加号") forState:0];
    }
    btnAdd.tag=-101;
    [numberView addSubview:btnAdd];
    [_scrollView addSubview:numberView];
   
    [_scrollView setContentSize:CGSizeMake(_scrollView.size.width, numberView.frame.size.height+numberView.frame.origin.y+10)];
   
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
    //获取同一组尺寸的数据
    NSArray *arrTemp=[attrDic objectForKey:ssTemp];
    NSString *sid=sizeMode.id;
    NSArray *keyAttrArr=[attrDic allKeys];
    //同一组数据只能单选
    if(sizeMode.isflag){
        for (int i=0; i<arrTemp.count; i++) {
            AttrInfoBtn *buttonTemp=(AttrInfoBtn*)arrTemp[i];
            SizeModel *sizeModeTemp= buttonTemp.sizeModel;
            NSString *sidTemp=sizeModeTemp.id;
            if(![sid isEqualToString:sidTemp]){
                sizeModeTemp.isflag=false;
            }
            
        }
        //回复编辑状态1.选中的时候让非关联的尺寸处于禁止编辑状态.2.让非关联的尺寸如果选中变为不选中
        
        for (NSString *keyStrm in keyAttrArr) {
            if(![keyStrm isEqualToString:ssTemp]){
                //不同组的数据
                 NSArray *arrTemp1=[attrDic objectForKey:keyStrm];
                for (int i=0; i<arrTemp1.count; i++) {
                    AttrInfoBtn *buttonTemp=(AttrInfoBtn*)arrTemp1[i];
                    SizeModel *sizeModeTemp= buttonTemp.sizeModel;
                    NSString *sidTemp=sizeModeTemp.id;
                    NSArray *guanglingArr=button.guanlianArr;
                    bool isGuangLiang=false;
                    for (NSString *guangLiangKey in guanglingArr) {
                        NSRange range = [guangLiangKey rangeOfString:sidTemp];
                        if (range.length > 0)
                        {
                            isGuangLiang=true;
                            break;
                        }

                    }
                    if (isGuangLiang){
                        buttonTemp.enabled=true;
                        
                    }else{
                        buttonTemp.enabled=false;
                        if(sizeModeTemp.isflag){
                            sizeModeTemp.isflag=false;
                        }
                    }
                    
                }
            }
        }
        
        
    }else{
        //取消选中的时候让非关联的尺寸取消静止编辑状态
        for (NSString *keyStrm in keyAttrArr) {
            if(![keyStrm isEqualToString:ssTemp]){
                //不同组的数据
                NSArray *arrTemp1=[attrDic objectForKey:keyStrm];
                for (int i=0; i<arrTemp1.count; i++) {
                    AttrInfoBtn *buttonTemp=(AttrInfoBtn*)arrTemp1[i];
                    SizeModel *sizeModeTemp= buttonTemp.sizeModel;
                    NSString *sidTemp=sizeModeTemp.id;
                    NSArray *guanglingArr=button.guanlianArr;
                    bool isGuangLiang=false;
                    for (NSString *guangLiangKey in guanglingArr) {
                        NSRange range = [guangLiangKey rangeOfString:sidTemp];
                        if (range.length > 0)
                        {
                            isGuangLiang=true;
                            break;
                        }
                        
                    }
                    if (isGuangLiang){
                        
                        
                    }else{
                        if(buttonTemp.guanlianArr.count>0){
                            buttonTemp.enabled=true;
                        }
                        
                        
                    }
                    
                }
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
            [btnCall setSelected:false];;
//            btnCall.enabled=false;
            break;
        }else{
            if(i!=keyArr.count-1){
                isChoose=false;
            }
        }
        
    }
    //判断当前价格
    if(isChoose){
        btnCall.selected=true;
//        btnCall.enabled=true;
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
    btnCall.backgroundColor=RGB(255, 13, 94);
//    [btnCall setTitle:@"加入购物车" forState:UIControlStateNormal];
    [btnCall addTarget:self action:@selector(addCar:) forControlEvents:UIControlEventTouchUpInside];
//    btnCall.enabled=false;
    [btnCall setSelected:false];
    //
//    [btnCall setBackgroundImage:[UIImage imageNamed:@"att_btn_base_"] forState:0];
    //
    UIImageView *shoushiView=[[UIImageView alloc]initWithFrame:CGRectMake(btnCall.width/3.5, 11, 26, 26)];
    shoushiView.image=[UIImage imageNamed:@"addToCart"];
    [btnCall addSubview:shoushiView];
    UILabel *zanLabel=[[UILabel alloc]initWithFrame:CGRectMake(shoushiView.width+shoushiView.left+15, (btnCall.height-30)/2,btnCall.width-(shoushiView.width+shoushiView.left+5) , 30)];
    if(self.ischange){
        zanLabel.text=@"确定";
        zanLabel.frame=CGRectMake(shoushiView.width+shoushiView.left+35, (btnCall.height-30)/2,btnCall.width-(shoushiView.width+shoushiView.left+5) , 30);
    }else{
        zanLabel.text=@"加入购物车";
    }
    
    zanLabel.font=[UIFont boldSystemFontOfSize:15];
    zanLabel.backgroundColor=[UIColor clearColor];
    zanLabel.textColor =[UIColor whiteColor];
    zanLabel.textAlignment=NSTextAlignmentLeft;
    zanLabel.numberOfLines=0;
    [btnCall addSubview:zanLabel];

//    [btnCall setImage:BundleImage(@"shopbt_02_.png") forState:0];
    [view_bar addSubview:btnCall];
 
    return view_bar;
}
#pragma mark - Navigation
-(UIView*)getNavigationBar
{
    self.navigationController.navigationBarHidden = YES;
    view_bar1 =[[UIView alloc]init];
    view_bar1.frame=CGRectMake(0, 0, self.view.frame.size.width, 44+20);

    view_bar1.backgroundColor=RGB(255, 13, 94);
    
    [self.view addSubview:view_bar1];
    UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(65, view_bar1.frame.size.height-44, self.view.frame.size.width-130, 44)];
    title_label.text=@"选择商品属性和数量";
    title_label.font=[UIFont boldSystemFontOfSize:17];
    title_label.backgroundColor=[UIColor clearColor];
    title_label.textColor =[UIColor whiteColor];
    title_label.textAlignment=1;
    [view_bar1 addSubview:title_label];
    UIButton*btnBack=[UIButton buttonWithType:0];
    btnBack.frame=CGRectMake(10, 26, 30, 30);
    [btnBack setImage:BundleImage(@"btn_back") forState:0];
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
#pragma mark - 尺码说明
-(void)gotoChima
{
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    SizeViewController *sv=[[SizeViewController alloc] init];
    [app.navigationController pushViewController:sv animated:YES];
    
}
#pragma mark - 加入购物车
-(void)addCar:(id)sender{
    if(!btnCall.selected){
        ShowMessage(@"需要选择商品属性");
        return;
    }
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
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app startLoading];
        
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
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView commitAnimations];
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    //    if ([_confirmPwdTextfield isFirstResponder]) {
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y =frame.origin.y -230;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
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
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
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
