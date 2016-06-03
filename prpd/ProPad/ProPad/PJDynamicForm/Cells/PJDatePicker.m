//
//  PJDatePicker.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "PJDatePicker.h"
#import "AppDelegate.h"
@interface PJDatePicker ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *requiredLabel;

@property (nonatomic) NSString *selectedDate;
@property (nonatomic) UIDatePicker *datePicker;
@end
@implementation PJDatePicker

- (void)awakeFromNib {
   _appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.title.textColor     = PJColorFieldTitle;
    self.textField.textColor = PJColorFieldValue;
    self.textField.delegate  = self;
    self.textField.font      = [UIFont systemFontOfSize:PJSizeFieldValue];
    self.title.font          = [UIFont systemFontOfSize:PJSizeFieldTitle];
    self.PickedDate=[[NSMutableArray alloc]init];
}

- (void)pickerSelected:(id)picker {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"hidePopUp"
     object:self];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
     self.PickedDate=[[NSMutableArray alloc]init];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.selectedDate   = formatedDate;
    self.textField.text = self.selectedDate;
    self.value          = self.textField.text;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"callSaveData" object:self];

    //[self.PickedDate insertObject:self.textField.text atIndex:[self.nQueid intValue]];
    [self.PickedDate addObject:self.textField.text];
    [self checkValidityAndUpdate];
    
}

- (void)setUp {

    self.datePicker                 = [UIDatePicker new];
    self.PickedDate=self.PickedDate;
    self.datePicker.datePickerMode  = self.datePickerMode;
    self.datePicker.backgroundColor = [UIColor whiteColor];
   // self.datePicker.maximumDate=[NSDate date];
    self.textField.inputView        = self.datePicker;
   // self.title.text=self.title.text;
    //self.title.text=[NSDate date];
    [self.datePicker addTarget:self
                        action:@selector(pickerSelected:)
              forControlEvents:UIControlEventValueChanged];

    self.title.text = self.titleText;
    self.textField.placeholder = self.placeholderText;

   // [super addBorders];
    [self setupRequiredLabelVisibility];
    [self checkValidityAndUpdate];
}

- (void)setupRequiredLabelVisibility {
    if (self.isRequired) {
        self.requiredLabel.hidden = NO;
    } else {
        self.requiredLabel.hidden = YES;
    }
}
#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    PJDatePicker *dp=(PJDatePicker *)[[textField superview]superview] ;
    _appDelegateTemp.CurQuid=[dp.nQueid intValue];
    return YES;
}
- (void)checkValidityAndUpdate {

    if (self.isRequired && self.textField.text.length == 0) {
        self.isValid         = NO;
        self.validityMessage = @"Required field is empty!";
        return;
    } else {

        self.isValid = YES;
        self.validityMessage = @"Field is valid!";
        return;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self pickerSelected:nil];
}
@end
