//
//  FilterBrandTabelView.h
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterBrandDockTavleView.h"
#import "LBRightTableView.h"
@interface FilterBrandTabelView : UIView<LetterBrandDockDelegate>

@property(strong,nonatomic) LetterBrandDockTavleView *leftTable;

@property(strong,nonatomic) LBRightTableView *rightTable;

@property(strong,nonatomic) NSArray *leftArray;

@property(strong,nonatomic) NSArray *rightArray;

@property(strong,nonatomic) NSArray *resultArray;

@property(assign,nonatomic) float leftTableHeight;

@property(assign,nonatomic) float leftTableWidth;

@property(assign,nonatomic) float rightTableHeight;

@property(assign,nonatomic) float rightTableWidth;


- (instancetype)initWithLeftArray:(NSArray *)leftArray andRightArray:(NSArray *)rightArray;

-(void)loadView;

-(NSArray *)loadRightView:(NSArray *)array;

@end
