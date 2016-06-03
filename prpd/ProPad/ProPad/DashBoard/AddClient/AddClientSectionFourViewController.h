//
//  AddClientSectionFourViewController.h
//  ProPad Step-4
//
//  Created by dhara on 7/28/15.
//  Copyright (c) 2015 com.zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "UsersData.h"

@interface AddClientSectionFourViewController : UIViewController
{
    IBOutlet NSLayoutConstraint *heightConst;
    UsersData *objUser;
}

@property(strong,nonatomic)NSMutableDictionary *dataDictionary;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstNewVehicle;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstUsedVehicle;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstStockNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstYear;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstSelectMake;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstSelectModel;


@property (weak, nonatomic) IBOutlet UIButton *btnSecondUsedVehicle;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondNewVehicle;

@property (weak, nonatomic) IBOutlet UITextField *txtSecondStockNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondYear;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondSelectMake;
@property (weak, nonatomic) IBOutlet UITextField *txtSecondSelectModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lbltime;


- (void)startTimedTask;
- (IBAction)btnVehicleOfInterestPressed:(id)sender;
- (IBAction)btnSubmitPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblVehicleOfInterest;

@end

