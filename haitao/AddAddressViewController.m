//
//  AddAddressViewController.m
//  haitao
//
//  Created by pwy on 15/7/19.
//  Copyright (c) 2015年 上海市配夸网络科技有限公司. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrrow_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(editAddress)];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(editAddress)];
   
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 150)];
   
    [self initArea];
    
    _picker.dataSource = self;
    _picker.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)editAddress{
    NSLog(@"----pass editAddress%@---",@"test");
}

-(void)initArea{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"----pass-areaDic%@---",_areaDic);
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    _province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [_province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    _city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [_city objectAtIndex: 0];
    _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    _selectedProvince = [_province objectAtIndex: 0];

}
- (IBAction)areaPick:(id)sender {
    
    UIAlertController* alertVc=[UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* ok=[UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        NSLog(@"----pass-ok%@---",@"test");
        NSInteger provinceIndex = [_picker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [_picker selectedRowInComponent: CITY_COMPONENT];
        NSInteger districtIndex = [_picker selectedRowInComponent: DISTRICT_COMPONENT];
        
        NSString *provinceStr = [_province objectAtIndex: provinceIndex];
        NSString *cityStr = [_city objectAtIndex: cityIndex];
        NSString *districtStr = [_district objectAtIndex:districtIndex];
        
        if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
            cityStr = @"";
            districtStr = @"";
        }
        else if ([cityStr isEqualToString: districtStr]) {
            districtStr = @"";
        }
        
        NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", provinceStr, cityStr, districtStr];
        _address.font=[UIFont systemFontOfSize:12.0];
        _address.text=showMsg;
    }];
    UIAlertAction* no=[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    [alertVc.view addSubview:_picker];
    [alertVc addAction:ok];
    [alertVc addAction:no];
    [self presentViewController:alertVc animated:YES completion:nil];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"----pass %@%d---",@"action",buttonIndex);

}

#pragma mark- Picker Data Source Methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return [_province count];
    }
    else if (component == CITY_COMPONENT) {
        return [_city count];
    }
    else {
        return [_district count];
    }

}
#pragma mark- Picker Delegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        _selectedProvince = [_province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%d", row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        _city = [[NSArray alloc] initWithArray: array];
        
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [_city objectAtIndex: 0]]];
        [_picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: CITY_COMPONENT];
        [_picker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[_province indexOfObject: _selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        _district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [_picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [_picker reloadComponent: DISTRICT_COMPONENT];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = UITextAlignmentCenter;
        myView.text = [_province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = UITextAlignmentCenter;
        myView.text = [_city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = UITextAlignmentCenter;
        myView.text = [_district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}
@end
