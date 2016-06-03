//
//  ComingSoonViewController.h
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"
@interface ComingSoonViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *txtCurrentMile;
//@property (weak, nonatomic) IBOutlet UITextField *txtDesirePayment;
//@property (weak, nonatomic) IBOutlet UITextView  *txtNotesForSecondSec;
//
//@property (weak, nonatomic) IBOutlet UITextField  *txtMakeModel;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UITextView   *txtAddress;
@property (weak, nonatomic) IBOutlet UIButton     *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton     *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton     *btnText;
@property (strong, nonatomic) IBOutlet IQDropDownTextField *txtCustType;
@property (weak, nonatomic) IBOutlet IQDropDownTextField   *txtReference;
@property (weak, nonatomic) IBOutlet UIScrollView   *scrlView;
//@property (weak, nonatomic) IBOutlet UITextField   *txtSecondaryChoice;
//@property (weak, nonatomic) IBOutlet UITextField   *txtCurrentPayment;
//@property (weak, nonatomic) IBOutlet UITextField   *txtPrimaryChoice;
- (IBAction)Selectcust_type:(id)sender;
- (IBAction)SelectAboutus:(id)sender;
- (IBAction)selecttext:(id)sender;
- (IBAction)selectemail:(id)sender;
- (IBAction)selectphone:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtHome;
@property (weak, nonatomic) IBOutlet UITextField *txtWork;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextView  *txtNotesForFirstSec;
@property (weak, nonatomic) IBOutlet UITextField *txtCityCode;
- (IBAction)onNextClicked:(id)sender;




@end
