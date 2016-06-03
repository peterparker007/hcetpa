//
//  PJDescription.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "PJDescription.h"
#import "DescriptionViewController.h"
@interface PJDescription()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel * title;
@property (weak, nonatomic) IBOutlet UILabel * requiredLabel;
@end

@implementation PJDescription

- (void)awakeFromNib {
    self.title.textColor     = PJColorFieldTitle;
    self.textField.textColor = PJColorFieldValue;
    self.title.font          = [UIFont systemFontOfSize:PJSizeFieldTitle];
    self.textField.font      = [UIFont systemFontOfSize:PJSizeFieldValue];

}

- (void)setUp {
    self.title.text            = self.titleText;
    self.textField.placeholder = self.placeholderText;
    [self setupRequiredLabelVisibility];
 //   [super addBorders];

    if (self.defaultValue != nil && self.value == nil) {
        self.value = self.defaultValue;
    }
    if (self.value != nil && [self.value length] != 0) {
        self.textField.text = self.value;
    }

    if ((self.value == nil || [self.value length] == 0) && self.isRequired) {
        self.textField.text = @"";
        self.validityMessage = @"Required Field Empty!";
        self.isValid = NO;
    } else {
        self.validityMessage = @"Valid data!";
        self.isValid = YES;
    }
}

- (void)setupRequiredLabelVisibility {
    if (super.isRequired) {
        self.requiredLabel.hidden = NO;
    } else {
        self.requiredLabel.hidden = YES;
    }
}

@end
