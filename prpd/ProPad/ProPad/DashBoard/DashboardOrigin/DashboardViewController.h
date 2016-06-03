//
//  DashboardViewController.h
//  ProPad
//
//  Created by Bhumesh on 24/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface DashboardViewController : UIViewController
{
    NSMutableArray *userDetailArr;
}
@property (strong, nonatomic) IBOutlet AsyncImageView *imgCompanyThumb;
@property (weak, nonatomic) IBOutlet UITextField *txtCustomerList;
@property (weak, nonatomic) IBOutlet UITextField *txtNewCustomer;
@property (weak, nonatomic) IBOutlet UITextField *txtAboutUs;
@property (weak, nonatomic) IBOutlet UIButton *btnCustomerList;
@property (weak, nonatomic) IBOutlet UIButton *btnNewCustomer;
@property (weak, nonatomic) IBOutlet UIButton *btnAboutUs;

-(void)setLeftModeForTextField:(UIImage*)image txtField:(UITextField*)txtField;
-(void)setRightModeForTextField:(UIImage*)image txtField:(UITextField*)txtField;
-(void)initV;
- (IBAction)onCustomerListTapped:(id)sender;
- (IBAction)onNewCustomerTapped:(id)sender;
- (IBAction)onAboutUsTapped:(id)sender;

@end
