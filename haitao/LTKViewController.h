//
//  LTKViewController.h
//  LvTongKa
//
//  Created by 123 on 13-8-26.

//

#import <UIKit/UIKit.h>


#import "HaiTaoBase.h"
#import "MenuModel.h"
@interface LTKViewController : UIViewController
@property(nonatomic,assign)CGRect mainFrame;
@property(nonatomic,retain)MenuModel *menuModel;
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;

@end
