//
//  CusCell.h
//  SEMCM
//
//  Created by SEM on 14/10/30.
//  Copyright (c) 2014年 SEM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UrlImageButton *shopImgView;
@property (weak, nonatomic) IBOutlet UILabel *shipName;
@property (weak, nonatomic) IBOutlet UIButton *shopbtn;
@property (weak, nonatomic) IBOutlet UrlImageView *shipImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *lineLal;

@end
