//
//  LetterBrandDockTavleView.m
//  haitao
//
//  Created by SEM on 15/8/5.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "LetterBrandDockTavleView.h"
#import "Header.h"
#import "LBDockCell.h"
@interface LetterBrandDockTavleView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) NSIndexPath *path;

@property (nonatomic ,assign) BOOL is;
@end

@implementation LetterBrandDockTavleView

-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.dataSource=self;
        self.delegate=self;
        
        
        
        
        
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(!_is)
    {
        NSInteger selectedIndex = 0;
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [self tableView:self didSelectRowAtIndexPath:selectedIndexPath];
        _is=YES;
    }
}

-(void)setDockArray:(NSMutableArray *)dockArray
{
    _dockArray=dockArray;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dockArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LBDockCell *cell =[LBDockCell cellWithTableView:tableView];
    cell.categoryText=_dockArray[indexPath.row];
    cell.backgroundColor=UIColorRGBA(246, 246, 246, 1);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_path!=nil) {
        LBDockCell *cell = (LBDockCell *)[tableView cellForRowAtIndexPath:_path];
        cell.backgroundColor=UIColorRGBA(246, 246, 246, 1);
        cell.category.textColor=RGB(51, 51, 51);
        cell.viewShow1.hidden=YES;
    }
    if ([_dockDelegate respondsToSelector:@selector(lbDockClickindexPathRow:  index: indeXPath:)]) {
        
        [_dockDelegate lbDockClickindexPathRow:_dockArray[indexPath.row] index:_path indeXPath:indexPath];
    }
    //取消选中颜色
    LBDockCell *cell = (LBDockCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.category.textColor=RGB(255, 13, 94);
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.viewShow1.hidden=NO;
    _path=indexPath;
    
    
    
    
}



@end
