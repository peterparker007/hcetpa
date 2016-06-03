//
//  PJBoolField.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "PJBoolField.h"
@interface PJBoolField ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

@end

@implementation PJBoolField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.textColor = PJColorFieldTitle;
    self.title.font = [UIFont systemFontOfSize:PJSizeFieldTitle];
    self.switchControl.onTintColor = PJColorFieldTitle;
    self.switchControl.tintColor = PJColorFieldTitle;
    [self.switchControl addTarget:self
                           action:@selector(setState:)
                 forControlEvents:UIControlEventValueChanged];

}

- (void)setUp {
    self.title.text = self.titleText;
    //Bool Field always have a default state so it's valid.
    self.isValid = YES;
    self.validityMessage = @"Valid!";
    self.value = self.defaultValue;
    if (self.defaultValue == nil) {
        self.value = @YES;
    }
    if (![self.value respondsToSelector:@selector(boolValue)]) {
        NSLog(@"Key: %@ is defined as BOOL field but the value passed is different",self.key);
        return;
    }
    bool switchState = [self.defaultValue boolValue];
    if (switchState) {
        [self.switchControl setOn:YES animated:NO];
        self.value       = @YES;
        self.textValue   = self.valueWhenOn;

    } else {
        [self.switchControl setOn:NO animated:NO];
        self.value       = @NO;
        self.textValue   = self.valueWhenOff;
    }
}

- (void)layoutSubviews {
 //   [super addBorders];
}
#pragma mark - Selectors
- (void)setState:(UISwitch *)sender {
    if (sender.isOn) {
        self.value       = @YES;
        self.textValue   = self.valueWhenOn ;

    } else {

        self.value       = @NO;
        self.textValue   = self.valueWhenOff;
    }
    self.isValid = YES;
    self.validityMessage = @"Valid!";
}




@end
