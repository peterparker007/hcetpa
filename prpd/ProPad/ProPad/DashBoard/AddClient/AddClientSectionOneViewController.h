//
//  AddClientSectionOneViewController.h
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersData.h"
@interface AddClientSectionOneViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet NSLayoutConstraint *heightConst;
    UsersData *objUser;
}

@property (strong, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *clientView;
@property (strong,nonatomic) NSMutableDictionary *dict;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnText;
@property (weak, nonatomic) IBOutlet UIButton *btnInternet;
@property (weak, nonatomic) IBOutlet UIButton *btnMailer;
@property (weak, nonatomic) IBOutlet UIButton *btnWalkIn;
@property (weak, nonatomic) IBOutlet UIButton *btnReferral;
@property (weak, nonatomic) IBOutlet UIButton *btnThirdPartyWebsite;
@property (weak, nonatomic) IBOutlet UIButton *btnOther;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstTimeCustomer;
@property (weak, nonatomic) IBOutlet UIButton *btnBeBack;
@property (weak, nonatomic) IBOutlet UIButton *btnAppointmentInternet;
@property (weak, nonatomic) IBOutlet UIButton *btnNotAppointment;
@property (strong, nonatomic) IBOutlet UIButton *btnSelfgenerated;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtState;

@property (weak, nonatomic) IBOutlet UITextField *txtHome;
@property (weak, nonatomic) IBOutlet UITextField *txtWork;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCityCode;
- (IBAction)btnAppointmentTypeTapped:(id)sender;

- (IBAction)btnCustomerTypePressed:(id)sender;
- (IBAction)btnAboutUsPressed:(id)sender;
- (IBAction)btnPrefferedContactTypePressed:(id)sender;
- (IBAction)btnNextPressed:(id)sender;
- (IBAction)btnSelectStatePressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblCutomerInfo;

@property (weak, nonatomic) IBOutlet UILabel *lblPreferredContact;

@property (weak, nonatomic) IBOutlet UILabel *lblCustomerType;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointment;
@property (weak, nonatomic) IBOutlet UILabel *lbleHowDidYouHear;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;


@end
