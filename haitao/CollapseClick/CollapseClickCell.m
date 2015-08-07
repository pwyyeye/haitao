//
//  CollapseClickCell.m
//  CollapseClick
//
//  Created by Ben Gordon on 2/28/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickCell.h"

@implementation CollapseClickCell

- (float)cellHeight {
    if (!_cellHeight) {
        _cellHeight = kCCHeaderHeight;
    }
    return _cellHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title index:(int)index content:(UIView *)content withHeight:(float) height{
    if (height==0) {
        height=50;
    }
    NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"CollapseClickCell" owner:nil options:nil];
    CollapseClickCell *cell = [[CollapseClickCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    cell = [views objectAtIndex:0];
    
    // Initialization Here
    cell.TitleLabel.text = title;
    cell.index = index;
    cell.TitleButton.tag = index;
    CGRect rect=cell.frame;
    cell.TitleLabel.frame=CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width,height);
    
    //右边箭头
    rect=cell.TitleArrow.frame;
    cell.TitleArrow.frame=CGRectMake(SCREEN_WIDTH-height/2,rect.origin.y, height/2,height/2);
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10,10)];
    imageView.image=[UIImage imageNamed:@"icon_Drop-rightList"];
    [imageView setClipsToBounds:YES];
    [imageView setContentMode:UIViewContentModeTopLeft];
    [cell.TitleArrow addSubview:imageView];
    
    //下分割线
    rect=cell.darkBorder.frame;
    cell.darkBorder.frame=CGRectMake(rect.origin.x, height-1, SCREEN_WIDTH, 0.5);
    
    cell.ContentView.frame = CGRectMake(cell.ContentView.frame.origin.x, cell.ContentView.frame.origin.y, cell.ContentView.frame.size.width, content.frame.size.height);
    [cell.ContentView addSubview:content];
    
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
