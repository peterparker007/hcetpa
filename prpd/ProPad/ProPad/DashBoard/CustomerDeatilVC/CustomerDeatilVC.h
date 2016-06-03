//
//  CustomerDeatilVCViewController.h
//  ProPad
//
//  Created by pradip.r on 7/30/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CustomerDetailTVC.h"
#import "AsyncImageView.h"

@interface CustomerDeatilVC : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *tblVehicleDetailsHeight;
    IBOutlet NSLayoutConstraint *tableheightConst;
    IBOutlet NSLayoutConstraint *heightConst;
    NSMutableDictionary *dictDynamicData;
}
@property (strong, nonatomic) NIDropDown *dropDown;
@property (weak, nonatomic) IBOutlet UIView *viewSocial;
@property (weak, nonatomic) IBOutlet UITextField *txtFrontGrossAmout;
@property (weak, nonatomic) IBOutlet UITextField *txtBackGrossAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnTotalGrossAmount;
@property (nonatomic,retain)UIImageView *userImage;
@property (nonatomic,retain)CustomerDetailTVC *cell;
@property (nonatomic,retain)AsyncImageView *imageObj;
@property (nonatomic,retain)NSArray * arrForCustomer;
@property (nonatomic,retain) NSDictionary *dictCustomerDetails;
@property(nonatomic,retain)NSMutableDictionary *dataDictionary;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;
@property (nonatomic,retain) UIPopoverController *popoverImageViewController;
@property(strong,nonatomic)NSMutableArray *aryTotalVehicles;
@property(strong,nonatomic)NSMutableArray *aryQuesAns;
 // txtfields
@property (weak, nonatomic) IBOutlet UITextField *txtSecondaryModel;

@property (weak, nonatomic) IBOutlet UITextField *txtSecondaryMake;

@property (weak, nonatomic) IBOutlet UITextField *txtSecondaryYear;

@property (weak, nonatomic) IBOutlet UITextField *txtSecStockNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAns;

@property (weak, nonatomic) IBOutlet UITextField *txtSecondaryVehicleOfInterest;

@property (weak, nonatomic) IBOutlet UITextField *txtPrimaryModel;

@property (weak, nonatomic) IBOutlet UITextField *txtPrimaryMake;

@property (weak, nonatomic) IBOutlet UITextField *txtPrimaryYer;

@property (weak, nonatomic) IBOutlet UITextField *txtPrimaryStockNumber;


@property (weak, nonatomic) IBOutlet UITextField *txtPrimaryVehicleOfInterest;

//@property (weak, nonatomic) IBOutlet UITextField *txtDecisionMkrsRPresent;
//
//@property (weak, nonatomic) IBOutlet UITextField *txtCurrentFinanceWith;
//
//@property (weak, nonatomic) IBOutlet UITextField *txtNextPayDueDate;
//
//@property (weak, nonatomic) IBOutlet UITextField *txtDesiredMonthlyPayment;
//
//@property (weak, nonatomic) IBOutlet UITextField *txtCurrentMontlyPayment;
@property (weak, nonatomic) IBOutlet UITableView *tblVehicleDetails;

@property (weak, nonatomic) IBOutlet UITextField *txtVehicleMilege;

@property (weak, nonatomic) IBOutlet UITextField *txtModel;

@property (weak, nonatomic) IBOutlet UITextField *txtMake;

@property (weak, nonatomic) IBOutlet UITextField *txtYear;

@property (weak, nonatomic) IBOutlet UITextField *txtCurrntVehiclNum;

@property (strong, nonatomic) IBOutlet UITextField *txtAppointment;

@property (weak, nonatomic) IBOutlet UITextField *txtPreferContcType;

@property (weak, nonatomic) IBOutlet UITextField *txtEmailAdd;

@property (weak, nonatomic) IBOutlet UITextField *txtWorkNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtHomeNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtMobile;

@property (weak, nonatomic) IBOutlet UITextField *txtZip;

@property (weak, nonatomic) IBOutlet UITextField *txtState;

@property (weak, nonatomic) IBOutlet UITextField *txtCity;

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtHowDidYouHearAbtUs;

@property (weak, nonatomic) IBOutlet UITextField *txtCustomerType;

@property (weak, nonatomic) IBOutlet UITableView *tblViewCustCell;
@property (strong, nonatomic) IBOutlet UITableView *tblDynamicViewCell;

@property (weak, nonatomic) IBOutlet UIView *viewCustomerDetailList;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollCustomerDetailList;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UITextField *txtStarttime;
@property (strong, nonatomic) IBOutlet UITextField *txtEndtime;
@property (strong, nonatomic) IBOutlet UITextField *txtNote;
@property (strong, nonatomic) IBOutlet UITextView *tvNote;



//btnActionfor fb,twiter,g+,linkedIn

-(void)initView;
- (IBAction)btnLinkedIn:(id)sender;

- (IBAction)btnGoogle:(id)sender;

- (IBAction)btnTwitter:(id)sender;

- (IBAction)btnFacebook:(id)sender;

- (IBAction)btnEditPressed:(id)sender;

- (IBAction)btnUpdatePressed:(id)sender;



@end
