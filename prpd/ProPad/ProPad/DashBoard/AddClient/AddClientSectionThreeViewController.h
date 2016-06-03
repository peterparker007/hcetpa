//
//  AddClientSectionThreeViewController.h
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersData.h"
#import <UIKit/UIKit.h>
#import "FieldTableViewCell.h"
#import "PJTextField.h"
@interface AddClientSectionThreeViewController : UIViewController<UITextFieldDelegate>
{
    NSString *txtDate;
    IBOutlet NSLayoutConstraint *heightConst;
    UsersData *objUser;
    
    
    NSString *type;
    NSMutableArray *arrDataField;
    NSMutableDictionary *DictTextField;
    NSMutableDictionary *DictDate;
    NSMutableDictionary *DictRadio;
    NSMutableDictionary *DictCheck;
    NSMutableDictionary *DictDropDown;
}
-(void)initV;
-(PJTextField *)setTextField;

@property (nonatomic) NSString *placeholderText;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentlyFinancedWith;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentMothlyPayment;
@property (weak, nonatomic) IBOutlet UITextField *txtNextPaymentDue;
@property (weak, nonatomic) IBOutlet UIButton *btnLower;
@property (weak, nonatomic) IBOutlet UIButton *btnSame;
@property (weak, nonatomic) IBOutlet UIButton *btnHigher;
@property (weak, nonatomic) IBOutlet UIButton *btnIsDecisionMakersPresent;
@property(strong,nonatomic)NSMutableDictionary *dataDictionary;

@property (weak, nonatomic) IBOutlet UIScrollView   *scrollView;
- (IBAction)btnSelectDatePressed:(id)sender;

- (IBAction)btnDecisionMakersPresentPressed:(id)sender;

- (IBAction)btnDesireMonthlyPaymentPressed:(id)sender;

- (IBAction)btnNextPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDecisionMaker;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentMonthPay;
@property (weak, nonatomic) IBOutlet UILabel *lblDesireMonthPay;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentlyFinance;
@property (weak, nonatomic) IBOutlet UILabel *lblNextPaymentDue;
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionSection;
-(void) getData;
@end
