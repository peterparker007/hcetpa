//
//  ViewController.h
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidationViewController.h"
@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton    *btnRememberMe;
@property(nonatomic,strong)IBOutlet UIScrollView *scrlView;
- (IBAction)onBtnForgetPasswordTapped:(id)sender;
- (IBAction)onBtnSubmitTapped:(id)sender;
- (IBAction)onBtnRememberMeTapped:(id)sender;
- (IBAction)onBtnSignUpTapped:(id)sender;
-(void)initV;

@property (weak, nonatomic) IBOutlet UIButton *lblForgetPass;
@property (weak, nonatomic) IBOutlet UILabel *lblNewUserRegister;

@end

