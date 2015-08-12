//
//  ShopsView.h
//  haitao
//
//  Created by pwy on 15/8/11.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterBtn.h"
typedef NS_ENUM(NSInteger, FilterButtonType) {
    FilterButtonTypeShop = 0,                         // no button type
    FilterButtonTypeCategaty = 1
};

@protocol FilterViewForButtonsDelegate <NSObject>

-(void)buttonClickForShopOrCategary:(IndexModel *)indexModel andType:(FilterButtonType) type;

@end

@interface FilterViewForButtons : UIView


@property(strong,nonatomic) id<FilterViewForButtonsDelegate> delegate;

//所有商城或者分类按钮
@property(strong,nonatomic) NSMutableArray *btns;

@property(strong,nonatomic) NSArray *array;

- (instancetype)initWithBtnArray:(NSArray *)array andType:(FilterButtonType)type;


-(void)loadShopsButtons;

-(void)loadCategoriesButtons;

@end
