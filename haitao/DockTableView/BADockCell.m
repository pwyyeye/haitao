//
//  BADockCell.m
//  酒吧助手
//
//  Created by 叶星龙 on 15/5/22.
//  Copyright (c) 2015年 北京局外者科技有限公司. All rights reserved.
//

#import "BADockCell.h"
#import "Header.h"
@interface BADockCell ()




@end


@implementation BADockCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        UILabel *category =[[UILabel alloc]initWithFrame:(CGRect){20,10,75-20,20}];
        [self.contentView addSubview:category];
        _category=category;
        UrlImageView *urlImgeView=[[UrlImageView alloc]initWithFrame:CGRectMake(2, (40-20)/2, 20, 20)];
        [urlImgeView setContentMode:UIViewContentModeScaleAspectFill];
        urlImgeView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:urlImgeView];
        _urlView=urlImgeView;
        
        

        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,39.5,75,0.5}];
        viewShow.backgroundColor=RGB(204, 204, 204);
        viewShow.alpha=0.4;
        [self.contentView addSubview:viewShow];
        UIView *viewShow1 =[[UIView alloc]initWithFrame:(CGRect){0,0,2,40}];
        viewShow1.backgroundColor=RGB(255, 13, 94);
        [self.contentView addSubview:viewShow1];
        
            viewShow1.hidden=YES;
        
        
        _viewShow1=viewShow1;
    }
    return self;
}

-(void)setCategoryText:(NSString *)categoryText
{
    _category.text=categoryText;
    _category.textAlignment=NSTextAlignmentCenter;
    _category.font=Font(12);
    
}
-(void)setImgurlText:(NSString *)imgurlText{
    [_urlView setImage:[UIImage imageNamed:imgurlText]];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BADockCell";
    BADockCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[BADockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com