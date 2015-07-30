//
//  Feedback.m
//  haitao
//
//  Created by pwy on 15/7/28.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "Feedback.h"

@interface Feedback ()

@end

@implementation Feedback

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"意见反馈";
    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_getSuggestTypeList withType:POSTURL withPam:nil withUrlName:@"types"];
    httpController.delegate = self;
    [httpController onSearch];
    _btn_array=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFeedBackType{
    if (_data!=nil) {
        float x=0;//按钮 x 坐标
        float y=0;
        float width=((SCREEN_WIDTH-40)/3);
        float height=30;
        
        for (int i=0; i<_data.count; i++) {
            x+=width+10;//间隔10
            if(i%3==0&&i!=0){//三个按钮换行
                x=0;
                if ((int)(i/3)>0) {
                    y=y+40;
                }
                
            }else if(i==0){//第一次 x＝0
               x=0;//间隔10
            }
            
            
 
            NSDictionary *dic=_data[i];
            CGRect rect=CGRectMake(x, y, width, height);
            UIButton *button=[[UIButton alloc] initWithFrame:rect];
            [button setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
            button.tag=100+[[dic objectForKey:@"id"] integerValue];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=3;
            [_btn_array addObject:button];
            [_buttonView addSubview:button];
            _buttonHeight=y+30+10;
        }
//        x=10;
    }

}

-(void)didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
    NSLog(@"----pass-login%@---",dictemp);
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app stopLoading];
    
    if ([[dictemp objectForKey:@"status"] integerValue]== 1) {
        if ([urlname isEqualToString:@"types"]) {
            _data=[dictemp objectForKey:@"data"];
            [self initFeedBackType];
        }else if([urlname isEqualToString:@"addSuggest"]) {
            ShowMessage(@"提交成功！");
            [self.navigationController popViewControllerAnimated:YES];

        }
        
    }

}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.viewWidth.constant=SCREEN_WIDTH;
    
    _buttonsViewHeight.constant=_buttonHeight;
}

-(void)btnClick:(UIButton *)sender{
    for (UIButton *button in _btn_array) {
        button.selected=NO;
        button.backgroundColor=[UIColor whiteColor];

    }
    if (!sender.selected) {
        sender.backgroundColor=RGB(255, 13, 94);
        sender.selected=YES;
        _selectedId=sender.tag-100;
    }else{
        sender.backgroundColor=[UIColor whiteColor];
        sender.selected=NO;
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)submit:(id)sender {
    NSDictionary *pam=@{@"type":[NSString stringWithFormat:@"%d",_selectedId] ,@"contact":_contact.text,@"content":_content.text};
    NSLog(@"----pass-btnClick%@---",pam);

    HTTPController *httpController =  [[HTTPController alloc]initWith:requestUrl_addSuggest withType:POSTURL withPam:pam withUrlName:@"addSuggest"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
}
@end
