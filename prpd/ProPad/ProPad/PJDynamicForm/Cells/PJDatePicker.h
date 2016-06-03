//
//  PJDatePicker.h
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FieldTableViewCell.h"
#import "AppDelegate.h"
@interface PJDatePicker : FieldTableViewCell <UITextFieldDelegate>
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic) NSString         *placeholderText;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong,nonatomic)AppDelegate *appDelegateTemp;
@property (nonatomic) BOOL isFirst;
@property (strong,nonatomic) NSMutableArray *PickedDate;
@property (strong,nonatomic) NSString *nQueid;

@end
