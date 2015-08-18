//
//  BiJiaView.m
//  haitao
//
//  Created by SEM on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "BiJiaView.h"

@implementation BiJiaView
- (id)initWithFrame:(CGRect)frame withBiJia:(NSMutableArray *)biJiaModelArr withGoods:(New_Goods *)goods{
    self = [super initWithFrame:frame];
    
    if (self) {
        myGoods=goods;
        UIView *backgroudView=[[UIView alloc]initWithFrame:CGRectMake(10, 30, self.width-20, 100)];
        backgroudView.layer.borderWidth=1;
        backgroudView.layer.cornerRadius = 0;
        backgroudView.layer.borderColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0].CGColor;
        backgroudView.backgroundColor=[UIColor whiteColor];
        [self addSubview:backgroudView];
        UrlImageView *imageHead=[[UrlImageView alloc]initWithFrame:CGRectMake(5, 10, 80, 80)];
        if(!goods.img_80){
            imageHead.image=BundleImage(@"df_04_.png");
        }else{
            
            NSURL *url=[NSURL URLWithString:goods.img_80];
            [imageHead setImageWithURL:url];
        }
        
        //        imageHead.layer.borderWidth=1;
        //        imageHead.layer.cornerRadius = 0;
        //        imageHead.layer.borderColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0].CGColor;
        imageHead.backgroundColor=[UIColor whiteColor];
        [backgroudView addSubview:imageHead];
        
        
        UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(imageHead.frame.size.width+imageHead.frame.origin.x+10, imageHead.frame.origin.y, backgroudView.width-20-75-10, 40)];
        title_label.text=[NSString stringWithFormat:@"￥%.2f",goods.price_cn];
        title_label.font=[UIFont systemFontOfSize:14];
        title_label.textColor =hexColor(@"#ff0d5e");
        title_label.backgroundColor=[UIColor clearColor];
        
        title_label.textAlignment=0;
        title_label.numberOfLines=1;
        [backgroudView addSubview:title_label];
        //收藏
        UIButton*shoucangBtn=[UIButton buttonWithType:0];
        shoucangBtn.frame=CGRectMake(title_label.frame.origin.x, title_label.frame.origin.y+title_label.frame.size.height+10, 60, 30);
        shoucangBtn.userInteractionEnabled=YES;
        shoucangBtn.backgroundColor=[UIColor clearColor];
        [shoucangBtn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
        //    [shoucangBtn setImage:BundleImage(@"shopbt_02_.png") forState:0];
        [backgroudView addSubview:shoucangBtn];
        UIImageView *scImg=[[UrlImageView alloc]initWithFrame:CGRectMake(5, (30-(24*2/3))/2, 24*2/3, 24*2/3)];
        scImg.image=[UIImage imageNamed:@"DetailsPage_icon_love_"];
        [shoucangBtn addSubview:scImg];
        UILabel *scLbl=[[UILabel alloc]initWithFrame:CGRectMake(scImg.frame.origin.x+scImg.width+2,scImg.frame.origin.y-3,shoucangBtn.frame.size.width-(scImg.frame.origin.x+scImg.width+5), 22)];
        scLbl.text=@"收藏";
        scLbl.font=[UIFont boldSystemFontOfSize:13];
        scLbl.backgroundColor=[UIColor clearColor];
        scLbl.textColor =hexColor(@"#b3b3b3");
        scLbl.numberOfLines=0;
        scLbl.textAlignment=NSTextAlignmentCenter;
        
        [shoucangBtn addSubview:scLbl];
        
        [backgroudView addSubview:shoucangBtn];
        //销量
        UIButton*xiaoliangBtn=[UIButton buttonWithType:0];
        xiaoliangBtn.frame=CGRectMake(shoucangBtn.frame.origin.x+shoucangBtn.width,shoucangBtn.top, backgroudView.width-(shoucangBtn.frame.origin.x+shoucangBtn.width), 30);
//        xiaoliangBtn.userInteractionEnabled=YES;
        xiaoliangBtn.backgroundColor=[UIColor clearColor];
        //    [shoucangBtn setImage:BundleImage(@"shopbt_02_.png") forState:0];
        [backgroudView addSubview:xiaoliangBtn];
        UIImageView *xlImg=[[UrlImageView alloc]initWithFrame:CGRectMake(1, (30-(24*2/3))/2, 24*2/3, 24*1/3)];
        xlImg.backgroundColor=[UIColor clearColor];
//        xlImg.image=[UIImage imageNamed:@"DetailsPage_icon_tag_"];
        [xiaoliangBtn addSubview:xlImg];
        UILabel *xlLbl=[[UILabel alloc]initWithFrame:CGRectMake(xlImg.frame.origin.x+xlImg.width,xlImg.frame.origin.y-3,xiaoliangBtn.frame.size.width-(xlImg.frame.origin.x+xlImg.width), 22)];
        xlLbl.text=[NSString stringWithFormat:@"销量：%@",goods.order_num ];
        xlLbl.font=[UIFont boldSystemFontOfSize:13];
        xlLbl.backgroundColor=[UIColor clearColor];
        xlLbl.textColor =hexColor(@"#b3b3b3");
        xlLbl.numberOfLines=0;
        xlLbl.textAlignment=NSTextAlignmentCenter;
        
        [xiaoliangBtn addSubview:xlLbl];
        
        [backgroudView addSubview:xiaoliangBtn];
        
        
        //底部
        UIButton*zanBtn=[UIButton buttonWithType:0];
        zanBtn.frame=CGRectMake(0, self.height-49, self.width, 49);
        
        [self addSubview:zanBtn];
        //RGB(255, 13, 94)
        [zanBtn setBackgroundColor:RGB(255, 13, 94)];
//
        UIImageView *shoushiView=[[UIImageView alloc]initWithFrame:CGRectMake(zanBtn.width/4, (49-23)/2, 20, 23)];
        shoushiView.image=[UIImage imageNamed:@"DetailsPage_icon_damuzhi_"];
        [zanBtn addSubview:shoushiView];
        UILabel *zanLabel=[[UILabel alloc]initWithFrame:CGRectMake(shoushiView.width+shoushiView.left+5, (zanBtn.height-30)/2,zanBtn.width-(shoushiView.width+shoushiView.left+5) , 30)];
        zanLabel.text=@"配你夸，给个赞呗";
        zanLabel.font=[UIFont boldSystemFontOfSize:13];
        zanLabel.backgroundColor=[UIColor clearColor];
        zanLabel.textColor =[UIColor whiteColor];
        zanLabel.textAlignment=NSTextAlignmentLeft;
        zanLabel.numberOfLines=0;
        [zanBtn addSubview:zanLabel];
        //中间
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(10, backgroudView.top+backgroudView.height+5, self.width-20, self.height-(backgroudView.top+backgroudView.height+5)-49)];
        _scrollView.backgroundColor=hexColor(@"#ededed");
        _scrollView.userInteractionEnabled=YES;
        _scrollView.contentSize=CGSizeMake(_scrollView.width, _scrollView.height);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor=[UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
        [self addSubview:_scrollView];
        //中间比价部分
        UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.width, 36)];
        titleView.backgroundColor=[UIColor whiteColor];
        [_scrollView addSubview:titleView];
        
        UILabel *c_label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, titleView.width, 20)];
        c_label.text=@"全球比价";
        c_label.font=[UIFont boldSystemFontOfSize:15];
        c_label.backgroundColor=[UIColor clearColor];
        c_label.textColor =hexColor(@"#333333");
        c_label.textAlignment=NSTextAlignmentLeft;
        c_label.numberOfLines=0;
        [titleView addSubview:c_label];
        
        UIImageView *imageLine=[[UIImageView alloc]initWithFrame:CGRectMake(10, 35, _scrollView.width, 1)];
        imageLine.image=BundleImage(@"gwc_line_.png");
        [titleView addSubview:imageLine];
        CGRect lastFrame;
        for (int i=0; i<biJiaModelArr.count; i++) {
            BiJiaModel *biJiaModel=biJiaModelArr[i];
            UIView *biJiaCell=[[UIView alloc]initWithFrame:CGRectMake(0,i*70 +36, self.width-20, 70)];
            lastFrame =biJiaCell.frame;
            biJiaCell.backgroundColor=[UIColor whiteColor];
            [self addSubview:biJiaCell];
            UrlImageView *shipImge=[[UrlImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
            if(!biJiaModel.shop_logo){
                shipImge.image=BundleImage(@"df_04_.png");
            }else{
                NSURL *url=[NSURL URLWithString:goods.img_80];
                [shipImge setImageWithURL:url];
            }

            //        imageHead.layer.borderWidth=1;
            //        imageHead.layer.cornerRadius = 0;
            //        imageHead.layer.borderColor=[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1.0].CGColor;
            shipImge.backgroundColor=[UIColor whiteColor];
            [biJiaCell addSubview:shipImge];
            
            //商店名
            UILabel *shiplal=[[UILabel alloc]initWithFrame:CGRectMake(imageHead.frame.size.width+imageHead.frame.origin.x+10,biJiaCell.height/2-10, 80, 20)];
            shiplal.text=biJiaModel.shop_name;
            shiplal.font=[UIFont boldSystemFontOfSize:11];
            shiplal.backgroundColor=[UIColor clearColor];
            shiplal.textColor =hexColor(@"#b3b3b3");
            shiplal.numberOfLines=1;
            shiplal.textAlignment=NSTextAlignmentLeft;
            [biJiaCell addSubview:shiplal];
            
            UILabel *title_label=[[UILabel alloc]initWithFrame:CGRectMake(shiplal.frame.size.width+shiplal.frame.origin.x+10, shiplal.frame.origin.y+3, biJiaCell.width-(shiplal.frame.size.width+shiplal.frame.origin.x+10), 10)];
            title_label.text=[NSString stringWithFormat:@"￥%.1f",goods.price_cn];
            title_label.font=[UIFont systemFontOfSize:14];
            title_label.textColor =hexColor(@"#ff0d5e");
            title_label.backgroundColor=[UIColor clearColor];
            
            title_label.textAlignment=NSTextAlignmentLeft;
            title_label.numberOfLines=1;
            [biJiaCell addSubview:title_label];
            
            if(i!=biJiaModelArr.count-1){
                UIImageView *lineImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, biJiaCell.height-1, biJiaCell.width, 1)];
                lineImg.image=BundleImage(@"gwc_line_.png");
                [biJiaCell addSubview:lineImg];
            }
            [_scrollView addSubview:biJiaCell];
        }
        _scrollView.contentSize=CGSizeMake(_scrollView.width, lastFrame.origin.y+lastFrame.size.height);
        
    }
    return self;
}
#pragma mark 收藏
-(void)shoucang:(id)sender{
    NSDictionary *parameters = @{@"goods_id":myGoods.id};
    NSString* url =[NSString stringWithFormat:@"%@&f=addFav&m=user",requestUrl]
    ;
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app startLoading];
    HTTPController *httpController =  [[HTTPController alloc]initWith:url withType:POSTURL withPam:parameters withUrlName:@"addFav"];
    httpController.delegate = self;
    [httpController onSearchForPostJson];
    
}
#pragma mark 接受数据
-(void) didRecieveResults:(NSDictionary *)dictemp withName:(NSString *)urlname{
//    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [app stopLoading];
    NSString *s_app_id=[dictemp objectForKey:@"s_app_id"];
    NSString *status=[dictemp objectForKey:@"status"];
    //    if(![status isEqualToString:@"1"]){
    ////        [self showMessage:message];
    ////        return ;
    //    }
    if([urlname isEqualToString:@"addFav"]){
        ShowMessage(@"收藏成功");
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
