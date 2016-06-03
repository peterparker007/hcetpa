//
//  AddClientSectionThreeViewController.m
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "AddClientSectionThreeViewController.h"
#import "PJDynamicForm.h"
#import "FieldTableViewCell.h"
#import "PJTextField.h"
#import "PJRadioCell.h"
#import "DropDowncell.h"
#import "ActionSheetStringPicker.h"
#import "FMDBDataAccess.h"
//#import "ClientListViewController.h"
#import "AddClientSectionFourViewController.h"
#import "UIView+Toast.h"
#import "HTTPManager.h"
#import "ApplicationData.h"
#import  "AppConstant.h"
#import "ActionSheetDatePicker.h"
#import "IQKeyboardManager.h"
#import "UsersData.h"
#import "Head.h"
#import "AddClientSectionTwoViewController.h"
@interface AddClientSectionThreeViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate,HTTPManagerDelegate,UITextFieldDelegate>
{
    NSString *strDesireMonthlyPayment;
    BOOL isDecisionMakerPresent;
    UITextField *activeField;
}
@end

@implementation AddClientSectionThreeViewController
@synthesize scrollView;
@synthesize txtCurrentlyFinancedWith,txtCurrentMothlyPayment,txtNextPaymentDue;
@synthesize btnHigher,btnIsDecisionMakersPresent,btnLower,btnSame;
@synthesize dataDictionary,lblCurrentlyFinance,lblCurrentMonthPay,lblDecisionMaker,lblDesireMonthPay,lblNextPaymentDue,lblQuestionSection;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initV];
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                    target:nil action:nil];
   self.navigationItem.backBarButtonItem.title=@"";
    self.navigationItem.title = @"New Customer";

    
}
-(void)initV
{
    [self companyServiceForIsPay];
    NSLog(@"%@",arrDataField);
   
}

-(void) getData
{
    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegateTemp checkInternetConnection]==true)
    {
        [[ApplicationData sharedInstance] showLoader];
        
        NSString *postString = [NSString stringWithFormat:@"nCompanyId=%@",[[NSUserDefaults standardUserDefaults] objectForKey:CompanyId]];
      
        HTTPManager *manager =[HTTPManager managerWithURL:KQuesList];
       
        //[HTTPManager managerWithURL:[KQuesList ];];
      //  @"http://216.55.169.45/~propad/master/webservices/questionlist.php"

        [manager setPostString:postString];
        manager.requestType = HTTPRequestTypeGeneral;
       // [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                [[ApplicationData sharedInstance] hideLoader];

                NSArray *arrUser = [bodyDict valueForKey:@"questiondetails"];
                arrDataField = [arrUser mutableCopy];
                 [self push:nil];
                DLog(@"%@",arrDataField);
               
            }
            else {
                [[ApplicationData sharedInstance] hideLoader];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [alert show];
               // [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            [[ApplicationData sharedInstance] hideLoader];

//            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            //[self.navigationController popViewControllerAnimated:YES];

//            NSArray *viewContrlls=[[self navigationController] viewControllers];
//            if(viewContrlls.count==3)
//            {
//                [self.navigationController popViewControllerAnimated:YES];
//
//            }
//            if([[viewContrlls lastObject] isKindOfClass:[AddClientSectionTwoViewController class]])
//            ;
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
    }
    else
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                 message:@"Connection Eroor." delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
//        [alert show];
      
       // [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)companyServiceForIsPay

{
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    [[ApplicationData sharedInstance] showLoader];
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         NSLog(@"%@",bodyDict);
         
         NSString *ispay = [bodyDict valueForKey:@"IsPay"];
          NSString *isStatus=[bodyDict valueForKey:@"isStatus"];
         NSString *msg=[bodyDict valueForKey:@"msg"];
         [self getData];

          if ([ispay isEqual:@"0"]||[isStatus isEqual:@"0"])
         {
              [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isUserLogin"];
             UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
             
             UINavigationController *naviCtrl = [[UINavigationController alloc]initWithRootViewController:rootController];
             
             naviCtrl.navigationBar.barTintColor = [UIColor clearColor];
             
             naviCtrl.navigationBar.translucent = NO;
             
             AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
             
             appdel.window.rootViewController = naviCtrl;
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];             [alert show];

         }

     }];
    
}



- (IBAction)push:(id)sender {
    @try {
        NSMutableArray *cellDefinitions = [NSMutableArray new];
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        int i;
        Head *header=[Head new];
        [cellDefinitions addObject:header];
        FieldsViewController *vc = [FieldsViewController new];
        vc.aryQuestionsData = [NSMutableArray new];
        NSMutableDictionary *dict1 = [NSMutableDictionary new];
        [dict1 setObject:header forKey:@"cellDefinitions"];
        [vc.aryQuestionsData addObject:dict1];
        for(i=0;i<[arrDataField count];i++)
        {
            id element = [arrDataField objectAtIndex:i];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[arrDataField objectAtIndex:i]];
            type=[element objectForKey:@"sAnsType"];
            if([type isEqualToString:@"text"])
            {
                DictTextField=arrDataField[i];
                [cellDefinitions addObject:[self setTextField]];
            }
            else if([type isEqualToString:@"CalendarDate"])
            {
                DictDate=arrDataField[i];
                [cellDefinitions addObject:[self setDate]];
            }
            
            
           
            else if([type isEqualToString:@"Checkbox"])
            {
                appDelegateTemp.selectionCount=appDelegateTemp.selectionCount+1;
                
                DictCheck=arrDataField[i];
                [cellDefinitions addObject:[self setcheck]];
            }
            else if ([type isEqualToString:@"Radio"])
            {
                appDelegateTemp.selectionCount=appDelegateTemp.selectionCount+1;
                DictRadio=arrDataField[i];
                [cellDefinitions addObject:[self setRadio]];
                
            }
            else if ([type isEqualToString:@"DropDown"])
            {
                DictDropDown=arrDataField[i];
                [cellDefinitions addObject:[self setDropDown]];
            }
            [dict setObject:cellDefinitions[i+1] forKey:@"cellDefinitions"];
            [dict setObject:@"" forKey:@"textValue"];
            [vc.aryQuestionsData addObject:dict];
        }
        PJSubmitCell *submit = [PJSubmitCell new];
        [cellDefinitions addObject:submit];
        
        //    PJHeader *head=[PJHeader new];
        //  //  head.title.text=@"CUSTOMER INFO";
        //    [cellDefinitions addObject:head];
        
        
        
        PJSection *section1 = [PJSection new];
        section1.elements =[[NSMutableArray alloc]init];
        section1.name       = @"TopFields";
        //  section1.elements = @[textField,textField];
        [section1.elements addObjectsFromArray:cellDefinitions];
        
        NSArray *sections    = @[section1];
        
        NSLog(@"aryQuestionsData:%@",vc.aryQuestionsData);
        vc.sections              = sections;
        vc.titleString           = @"New Customer";
        vc.cellDefinition        = cellDefinitions;
        [self showViewController:vc sender:nil];
    }
    @catch (NSException *exception) {
         NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,[exception description]);
    }
    @finally {
        
    }
    
    
    
}
-(PJRadioCell*)setcheck
{
    
    PJRadioCell *check=[PJRadioCell new];
    check.titleText =[DictCheck valueForKeyPath:@"sQuestion"];
    check.nQueid=[DictCheck valueForKeyPath:@"nQueid"];  check.isRequired =NO;
    check.arrOptions=[DictCheck valueForKeyPath:@"sAns"];
   check.count =[NSNumber numberWithInteger:[check.arrOptions count]];
    check.Type=type;
    return check;
    
}
-(DropDowncell*)setDropDown
{
    DropDowncell *drop=[DropDowncell new];
    drop.titleText =[DictDropDown valueForKeyPath:@"sQuestion"];
    drop.nQueid=[DictDropDown valueForKey:@"nQueid"];
    drop.isRequired =NO;
    drop.arrOptions=[DictDropDown valueForKeyPath:@"sAns"];
   // drop.dropDown.titleLabel.text=@"hii";
    return drop;
    
}
-(PJTextField*)setTextField
{
    PJTextField *textField = [PJTextField new];
    textField.titleText     = [DictTextField valueForKeyPath:@"sQuestion"];
    textField.nQueid=[DictTextField valueForKeyPath:@"nQueid"];
    textField.isRequired      = NO;
    textField.key             = @"email";
    textField.inputType       = PJEmail;
    textField.placeholderText = @"Enter Text";
    return textField;
}
-(PJRadioCell*)setRadio
{
    
    PJRadioCell *radio=[PJRadioCell new];
    radio.titleText =[DictRadio valueForKeyPath:@"sQuestion"] ;
    radio.nQueid=[DictRadio valueForKeyPath:@"nQueid"] ;
    
    radio.isRequired =NO;
   radio.arrOptions=[DictRadio valueForKeyPath:@"sAns"];
    radio.count =[NSNumber numberWithInteger:[radio.arrOptions count]];
    radio.Type=type;
    return radio;

}
-(PJDescription *)setDesc
{
    PJDescription *descriptionField  = [PJDescription new];
    descriptionField.key             = @"about";
    descriptionField.titleText       = @"About you!";
    descriptionField.placeholderText = @"Type your description here...";
    descriptionField.isRequired      = NO;
    descriptionField.defaultValue    = @"HEY";
    return descriptionField;
}

-(PJDatePicker *)setDate
{
    PJDatePicker *datePicker   = [PJDatePicker new];
    datePicker.key             = @"dob";
    datePicker.titleText       = [DictDate valueForKeyPath:@"sQuestion"];
    datePicker.nQueid       = [DictDate valueForKeyPath:@"nQueid"];
    datePicker.isRequired      = NO;
    datePicker.placeholderText = @"Select Date";
    datePicker.datePickerMode  = UIDatePickerModeDate;
    return datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
//    [super viewWillDisappear:NO];
   self.navigationItem.title=@"";
    [super viewDidAppear:animated];
   
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    UsersData *dataCheak=[UsersData sharedManager];
    
    if ([dataCheak.strCheak isEqualToString:@"YES"]) {
        [self.navigationController popViewControllerAnimated:NO];
        dataCheak.strCheak=@"NO";
    }
    
    
    
    self.navigationItem.title  = @"New Customer";
    
}



- (IBAction)btnNextPressed:(id)sender {
    [self.view endEditing:true];
    @try{
       
        if(txtCurrentMothlyPayment.text.length!=0)
            [dataDictionary setObject:txtCurrentMothlyPayment.text forKey:@"sCurrentMonthly"];
        
        if(strDesireMonthlyPayment.length!=0)
            [dataDictionary setObject:strDesireMonthlyPayment forKey:@"sDesireMonthly"];
        
        if(txtNextPaymentDue.text.length!=0)
            
            [dataDictionary setObject:txtNextPaymentDue.text forKey:@"sNextPayment"];
        
        if(txtCurrentlyFinancedWith.text.length!=0)
            [dataDictionary setObject:txtCurrentlyFinancedWith.text forKey:@"sCurrentlyFinance"];
        
        
        
        AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
        fourth.dataDictionary = [[NSMutableDictionary alloc] init];
        fourth.dataDictionary = dataDictionary;
        [self.navigationController pushViewController:fourth animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}
- (BOOL) isNotNull:(NSObject*) object {
    if (!object)
        return YES;
    else if (object == [NSNull null])
        return YES;
    else if ([object isKindOfClass: [NSString class]] && object!=nil) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"nil"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    @try{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+50, 0.0);
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
            [scrollView setContentOffset:scrollPoint animated:YES];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}



@end
