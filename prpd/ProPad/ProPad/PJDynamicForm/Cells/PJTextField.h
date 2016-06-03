//
//  PJTextField.h
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FieldTableViewCell.h"
#import "FieldsViewController.h"
#import "PopUpTableViewController.h"
typedef enum PJTextFieldInputType {
    PJEmail,
    PJNumber,
    PJString,
}PJTextFieldInputType;

@interface PJTextField : FieldTableViewCell <UITextFieldDelegate>
@property (nonatomic) NSString *placeholderText;
@property (nonatomic) NSString *regex;

@property (nonatomic) PJTextFieldInputType inputType;
@property (strong,nonatomic) NSString *nQueid;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel     *title;
@property (weak, nonatomic) IBOutlet UILabel     *requiredLabel;
- (void)setupRequiredLabelVisibilityIfIsRequired:(BOOL)isRequired;
@end
