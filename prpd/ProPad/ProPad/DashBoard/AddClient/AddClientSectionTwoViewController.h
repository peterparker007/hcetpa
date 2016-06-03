//
//  AddClientSectionTwoViewController.h
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddClientSectionTwoTVC.h"
#import "ZBarSDK.h"
#import "UsersData.h"

@interface AddClientSectionTwoViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *viewHeightDynamic;
    IBOutlet NSLayoutConstraint *tableHeightConst;
    UIPopoverController *pop;
    UsersData *objUser;
}

@property(strong,nonatomic)NSMutableDictionary *dataDictionary;
@property(strong,nonatomic)NSMutableArray *aryNumberOfVehicle;
@property(strong,nonatomic)NSMutableArray *aryTotalVehicles;
@property(strong,nonatomic)NSMutableArray *aryNVin;
@property(strong,nonatomic)NSMutableArray *aryMilaege;
@property(strong,nonatomic)NSMutableDictionary *dictVehicleDataResponse;


@property (nonatomic,retain)ZBarReaderViewController *reader;

@property (weak, nonatomic) IBOutlet UITextField *txtVINnumber;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (nonatomic,retain)AddClientSectionTwoTVC *cell;
@property (weak, nonatomic) IBOutlet UITableView *tblViewCustCell;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAnotherVehicle;

@property (weak, nonatomic) IBOutlet UILabel *lblCustomerCurrentVehicle;
@property (weak, nonatomic) IBOutlet UILabel *lblVIN;
@property (weak, nonatomic) IBOutlet UITextView *txtViewNotes;



- (IBAction)btnSelectProfilePicturePressed:(id)sender;
- (IBAction)btnSearchPressed:(id)sender;
- (IBAction)btnVIMScannerPressed:(id)sender;

- (IBAction)btnAddAnotherVehiclePresssed:(id)sender;
- (IBAction)btnNextPressed:(id)sender;

@end
