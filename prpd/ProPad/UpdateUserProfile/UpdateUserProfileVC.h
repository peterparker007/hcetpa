//
//  UpdateUserProfileVC.h
//  ProPad
//
//  Created by Bhumesh on 04/08/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface UpdateUserProfileVC : UIViewController
{
     UIBarButtonItem *btnEdit;
      NSMutableArray *userDetailArr;
}
@property (strong, nonatomic) IBOutlet AsyncImageView *imgCompanyThumb;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtUserName;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtCompanyCode;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblTapOnHint;
@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIButton *btnTwitter;
@property (weak, nonatomic) IBOutlet UIButton *btnGoogle;
@property (weak, nonatomic) IBOutlet UIButton *btnLinkedIn;



- (IBAction)onUpdatebtnTapped:(id)sender;
- (IBAction)btnFacebookPressed:(id)sender;
- (IBAction)btnTwitterPressed:(id)sender;
- (IBAction)btnGooglePressed:(id)sender;
- (IBAction)btnLinkedinPressed:(id)sender;
-(void)initV;
-(void) dispData;
-(void)editData;
-(void)setTextFieldToUserData;
@end
