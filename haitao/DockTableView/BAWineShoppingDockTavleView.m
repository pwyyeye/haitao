//
//  BAWineShoppingDockTavleView.m
//  酒吧助手
//
//  Created by 叶星龙 on 15/5/22.
//  Copyright (c) 2015年 北京局外者科技有限公司. All rights reserved.
//

#import "BAWineShoppingDockTavleView.h"
#import "BADockCell.h"
#import "Header.h"
@interface BAWineShoppingDockTavleView ()<UITableViewDelegate,UITableViewDataSource>

{
    bool isfis;
}

@property (nonatomic ,strong) NSIndexPath *path;

@property (nonatomic ,assign) BOOL is;
@end

@implementation BAWineShoppingDockTavleView


-(id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    isfis=true;
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
    
    BADockCell *cell =[BADockCell cellWithTableView:tableView];
    cell.categoryText=_dockArray[indexPath.row][@"dockName"];
    cell.imgurlText=_dockArray[indexPath.row][@"image"];
    cell.backgroundColor=RGB(237, 237, 237);
    if(indexPath.row==0){
        if(isfis){
            isfis=false;
            cell.backgroundColor=[UIColor whiteColor];
            cell.viewShow1.hidden=NO;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_path!=nil) {
        BADockCell *cell = (BADockCell *)[tableView cellForRowAtIndexPath:_path];
        cell.backgroundColor=RGB(237, 237, 237);
//        cell.category.textColor=RGB(51, 51, 51);
        cell.viewShow1.hidden=YES;
    }
    if ([_dockDelegate respondsToSelector:@selector(dockClickindexPathRow:  index: indeXPath:)]) {
        
        [_dockDelegate dockClickindexPathRow:_dockArray[indexPath.row][@"right"]  index:_path indeXPath:indexPath];
    }
    //取消选中颜色
    BADockCell *cell = (BADockCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.category.textColor=RGB(255, 13, 94);
    cell.backgroundColor=[UIColor whiteColor];
    cell.viewShow1.hidden=NO;
    _path=indexPath;
    
    
    
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com