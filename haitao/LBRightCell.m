//
//  LBRightCell.m
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LBRightCell.h"
#import "Header.h"
@interface LBRightCell ()

@property (weak ,nonatomic) UIImageView *wineImage;



@property (weak ,nonatomic) UILabel *wineName;
@end
@implementation LBRightCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *wineImage =[[UIImageView alloc]init];
        [self.contentView addSubview:wineImage];
        _wineImage=wineImage;
        
        UILabel *wineName =[[UILabel alloc]init];
        [self.contentView addSubview:wineName];
        _wineName=wineName;
        
        UIView *viewShow =[[UIView alloc]initWithFrame:(CGRect){0,89.5,kWindowWidth,0.5}];
        viewShow.backgroundColor=[UIColor blackColor];
        viewShow.alpha=0.3;
        [self.contentView addSubview:viewShow];
        
        
    }
    return self;
}



-(void)setRightData:(NSMutableDictionary *)rightData
{
    
    _rightData=rightData;
    _wineImage.frame=(CGRect){5,15,65,65};
    _wineImage.image=[UIImage imageNamed:@"shuma_icon_xiangji_top_"];
    _wineImage.layer.masksToBounds=YES;
    _wineImage.layer.cornerRadius=6;
    
    
    
    
    NSString *wineNameText =_rightData[@"name"];
    CGRect wineNameRect =[wineNameText boundingRectWithSize:CGSizeMake(kWindowWidth-75-CGRectGetMaxX(_wineImage.frame)-10, 35) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(14),NSFontAttributeName, nil] context:nil];
    _wineName.text=wineNameText;
    _wineName.font=Font(14);
    _wineName.numberOfLines=2;
    _wineName.textAlignment=NSTextAlignmentJustified;
    _wineName.frame =(CGRect){{CGRectGetMaxX(_wineImage.frame)+5,10},wineNameRect.size};
}

-(void)wineRightClick
{

    _TapActionBlock([ _rightData[@"Quantity"] integerValue],[_rightData[@"money"] integerValue] ,_rightData[@"ProductID"]);
}

-(void)wineLeftClick
{
    
    _TapActionBlock([ _rightData[@"Quantity"] integerValue],[_rightData[@"money"] integerValue],_rightData[@"ProductID"]);

    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BARightCell";
    LBRightCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[LBRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        //取消选中状态
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
