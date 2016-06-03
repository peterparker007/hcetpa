//
//  SignupViewController.h
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationViewController.h"
@interface SignupViewController : UIViewController <UITextFieldDelegate> {
    NSString *strSalesPersonType;
    __weak IBOutlet NSLayoutConstraint *scrollViewheightConstant;
}
@property (weak, nonatomic) IBOutlet UIView *viewWithSignUp;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtSecretPin;
@property (weak, nonatomic) IBOutlet UITextField *txtCompanyCode;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPin;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *aryCompanyDetails;
@property (weak, nonatomic) IBOutlet UIButton *btnUsedVehicle;
@property (weak, nonatomic) IBOutlet UIButton *btnNewVehicle;
- (IBAction)onBtnUsedVehicleTapped:(id)sender;
- (IBAction)btnSubmitClicked:(id)sender;
- (IBAction)onBtnNewVehicleTapped:(id)sender;
-(void)initView;



@end
