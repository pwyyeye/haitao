//
//  BiJiaView.h
//  haitao
//
//  Created by SEM on 15/8/8.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiJiaModel.h"
#import "New_Goods.h"
@interface BiJiaView : UIView<HTTPControllerProtocol>{
     UIScrollView *_scrollView;
    New_Goods *myGoods;
}
- (id)initWithFrame:(CGRect)frame withBiJia:(NSMutableArray *)biJiaModelArr withGoods:(New_Goods *)goods;
@end
