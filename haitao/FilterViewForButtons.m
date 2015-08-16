//
//  ShopsView.m
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "FilterViewForButtons.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation FilterViewForButtons

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithBtnArray:(NSArray *)array andType:(FilterButtonType)type
{
    self = [super init];
    if (self) {
        if (type==FilterButtonTypeShop) {
            _array=array;
            if (_array.count==0)return self;
            
            int lines=0;
            //一行三个按钮 根据按钮个数计算 view高度
            if (_array.count%3==0&&_array.count>=3) {
                lines=(int)_array.count/3;
            }else{
                lines=(int)_array.count/3+1;
            }
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH, lines*40+10);
        }else if (type==FilterButtonTypeCategaty){
            _array=array;
            if (_array.count==0)return self;
            
            int lines=0;
            //一行三个按钮 根据按钮个数计算 view高度
            if (_array.count%4==0&&_array.count>=4) {
                lines=(int)_array.count/4;
            }else{
                lines=(int)_array.count/4+1;
            }
            self.frame=CGRectMake(0, 0, SCREEN_WIDTH, (lines+1)*75+50);
        
        }
        
        
        
    }
    return self;
}
-(void)loadShopsButtons{
    if (_array.count!=0) {
        float x=20;//按钮 x 坐标
        float y=10;
        float width=((SCREEN_WIDTH-80)/3);
        float height=30;
        
        for (int i=0; i<_array.count; i++) {
            x+=width+20;//间隔10
            if(i%3==0&&i!=0){//三个按钮换行
                x=20;
                if ((int)(i/3)>0) {
                    y=y+40;
                }
                
            }else if(i==0){//第一次 x＝0
                x=20;//间隔10
            }
            
            
            
            CGRect rect=CGRectMake(x, y, width, height);
            FilterBtn *button=[[FilterBtn alloc] initWithFrame:rect];
            button.layer.borderWidth=0.5;
            button.layer.borderColor=RGB(179, 179, 179).CGColor;
            button.indexModel =_array[i];

            [button setTitle:button.indexModel.name forState:UIControlStateNormal];
//            button.tag=[button.indexModel.id integerValue];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=3;
            [_btns addObject:button];
            [self addSubview:button];
//            _buttonHeight=y+30+10;
        }
        //        x=10;
    }

}

-(void)loadCategoriesButtons{
    if (_array.count!=0) {
        float x=15;//按钮 x 坐标
        float y=10;
        float width=((SCREEN_WIDTH-75)/4);
        float height=80;
        
        for (int i=0; i<_array.count; i++) {
            x+=width+15;//间隔10
            if(i%4==0&&i!=0){//三个按钮换行
                x=15;
                if ((int)(i/4)>0) {
                    y=y+90;
                }
                
            }else if(i==0){//第一次 x＝0
                x=15;//间隔10
            }
            
            
            
            CGRect rect=CGRectMake(x, y, width, height);
            FilterBtn *button=[[FilterBtn alloc] initWithFrame:rect];

            button.indexModel =_array[i];
            
//            [button setTitle:button.indexModel.name forState:UIControlStateNormal];
            
            UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
            [imageView setImageWithURL:[NSURL URLWithString:button.indexModel.img] placeholderImage:[UIImage imageNamed:@"default_04"]];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [button addSubview:imageView];
            
            UILabel *text=[[UILabel alloc] initWithFrame:CGRectMake(0, 65, 65, 10)];
            text.font=[UIFont systemFontOfSize:10];
            text.text=button.indexModel.name;
            text.textColor=RGB(51, 51, 51);
            text.textAlignment=NSTextAlignmentCenter;
            [button addSubview:text];
            
            //            button.tag=[button.indexModel.id integerValue];
            button.titleLabel.font=[UIFont systemFontOfSize:13];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(btnCategaryClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=3;
            [_btns addObject:button];
            [self addSubview:button];
            //            _buttonHeight=y+30+10;
        }
        //        x=10;
    }
    
}

-(void)btnClick:(UIButton *)sender{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            button.selected=NO;
            button.backgroundColor=[UIColor whiteColor];
        }
        
    }
    
    if (!sender.selected) {
        sender.backgroundColor=RGB(255, 13, 94);
        sender.selected=YES;
        if ([self.delegate respondsToSelector:@selector(buttonClickForShopOrCategary:andType:)]) {
            FilterBtn *btn=(FilterBtn *)sender;
            [self.delegate buttonClickForShopOrCategary:btn.indexModel andType:FilterButtonTypeShop];
        }
    }else{
        sender.backgroundColor=[UIColor whiteColor];
        sender.selected=NO;
    }
    
}

-(void)btnCategaryClick:(UIButton *)sender{
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button=(UIButton *)view;
            button.selected=NO;
            button.layer.borderColor=[UIColor clearColor].CGColor;
            button.layer.borderWidth=0;
        }
        
    }
    if (!sender.selected) {
        sender.layer.borderColor=RGB(255, 13, 94).CGColor;
        sender.layer.borderWidth=0.5;
        sender.selected=YES;
        if ([self.delegate respondsToSelector:@selector(buttonClickForShopOrCategary:andType:)]) {
            FilterBtn *btn=(FilterBtn *)sender;
            [self.delegate buttonClickForShopOrCategary:btn.indexModel andType:FilterButtonTypeCategaty];
        }
    }else{
        sender.layer.borderColor=CLEARCOLOR.CGColor;
        sender.layer.borderWidth=0;
        sender.selected=NO;
    }
    
}
@end
