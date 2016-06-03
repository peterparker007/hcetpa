//
//  SignupViewController.m
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "SignupViewController.h"
#import "ValidationViewController.h"
#import "FMDBDataAccess.h"
#import "UIView+Toast.h"
#import "HTTPManager.h"
#import "ApplicationData.h"
#import  "AppConstant.h"
#import "DEMOLeftMenuViewController.h"
#import "RESideMenu.h"
#import "DashboardViewController.h"
#import "Base64.h"

@interface SignupViewController ()<HTTPManagerDelegate,UIGestureRecognizerDelegate,RESideMenuDelegate>
{
    BOOL isNewCustomer;
    BOOL isUsedCustomer;
    BOOL isAddedSuccess;
    NSMutableArray *aryCompanyCode;
    CGPoint scrollContentOffsetValue;
    CGSize scrollSizeValue;
    CGFloat scrollHeightConstant;
    BOOL isConnectedToInternet;
}

@end

@implementation SignupViewController
@synthesize txtFirstName,txtLastName,txtUserName,txtSecretPin,txtCompanyCode,txtConfirmPin;
@synthesize aryCompanyDetails;
@synthesize btnUsedVehicle,btnNewVehicle;
@synthesize viewWithSignUp,scrollView;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        //    self.navigationController.navigationBarHidden=YES;
        self.navigationItem.title=@"Registration";
        [self companyServiceForIsPay];
        aryCompanyDetails  = [[NSMutableArray alloc] init];
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        scrollContentOffsetValue = scrollView.contentOffset;
        scrollSizeValue = scrollView.contentSize;
        DLog(@"%f,%f",scrollSizeValue.width,scrollSizeValue.height);
        isAddedSuccess=false;
        
        [self initView];
        
        txtFirstName.delegate=self;
        txtLastName.delegate=self;
        txtUserName.delegate=self;
        txtSecretPin.delegate=self;
        txtCompanyCode.delegate=self;
        txtConfirmPin.delegate=self;
        
        txtFirstName.autocorrectionType = UITextAutocorrectionTypeNo;
        txtLastName.autocorrectionType = UITextAutocorrectionTypeNo;
        txtUserName.autocorrectionType = UITextAutocorrectionTypeNo;
        txtSecretPin.autocorrectionType = UITextAutocorrectionTypeNo;
        txtCompanyCode.autocorrectionType = UITextAutocorrectionTypeNo;
        isNewCustomer=false;
        isUsedCustomer=true;
        txtFirstName.returnKeyType=UIReturnKeyDone;
        txtLastName.returnKeyType=UIReturnKeyDone;
        txtUserName.returnKeyType=UIReturnKeyDone;
        txtSecretPin.returnKeyType=UIReturnKeyDone;
        txtCompanyCode.returnKeyType=UIReturnKeyDone;
        txtConfirmPin.returnKeyType=UIReturnKeyDone;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        isConnectedToInternet=false;
        
        if(IS_IPAD){
            txtFirstName.font = [UIFont systemFontOfSize:16];
            txtLastName.font = [UIFont systemFontOfSize:16];
            txtUserName.font = [UIFont systemFontOfSize:16];
            txtSecretPin.font = [UIFont systemFontOfSize:16];
            txtCompanyCode.font = [UIFont systemFontOfSize:16];
            txtConfirmPin.font = [UIFont systemFontOfSize:16];
            txtUserName.font = [UIFont systemFontOfSize:16];
            btnNewVehicle.titleLabel.font = [UIFont systemFontOfSize:16];
            btnUsedVehicle.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)initView
{
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtFirstName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtLastName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtUserName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"locate-icon"] txtField:txtSecretPin];
    [self setTextFieldWithImage:[UIImage imageNamed:@"locate-icon"] txtField:txtConfirmPin];
    [self setTextFieldWithImage:[UIImage imageNamed:@"companycode-icon"] txtField:txtCompanyCode];
}
#pragma mark textField Delegate
-(void)setTextFieldWithImage:(UIImage*)image txtField:(UITextField*)txtField
{
    txtField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:
                               CGRectMake(0, 0, image.size.width, image.size.height)];
    imageView2.image = image;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width+5, image.size.height)];
    [paddingView addSubview:imageView2];
    txtField.leftView = paddingView;
    
}

/* hide keyboard click Outside*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // dismiss the keyboard
    [super touchesBegan:touches withEvent:event];
}
/* hide keyboard click Return*/

//------------------------------------------------------------------------------

#pragma mark - UITextField Delegate
#pragma mark
//------------------------------------------------------------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}
//------------------------------------------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //    if(textField==txtFirstName)
    //    {
    //        NSString *strFirstName=txtFirstName.text;
    //        NSString *firstCapChar = [[strFirstName substringToIndex:1] uppercaseString];
    //        NSString *cappedString = [strFirstName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    //
    //        txtFirstName.text=cappedString;
    //    }
    scrollViewheightConstant.constant=550;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    scrollViewheightConstant.constant=380;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark onbtnAction
- (IBAction)onBtnUsedVehicleTapped:(id)sender {
    btnUsedVehicle.selected=!btnUsedVehicle.selected;
}
- (IBAction)onBtnNewVehicleTapped:(id)sender {
    btnNewVehicle.selected=!btnNewVehicle.selected;
}

- (IBAction)btnSubmitClicked:(id)sender {
    [self.view endEditing:true];
    @try{
        if(txtFirstName.text.length==0){
            [self.view makeToast:@"First name can not be blank"];
            return;
        }
        else if (txtLastName.text.length==0)
        {
            [self.view makeToast:@"Last name can not be blank"];
            return;
        }
        else if (txtUserName.text.length==0)
        {
            [self.view makeToast:@"User name can not be blank"];
            return;
        }
        else if ([ValidationViewController validateEmail:txtUserName.text]==false)
        {
            [self.view makeToast:@"User name/Email is not valid, valid form is loren@gmail.com" duration:3.0f position:CSToastPositionBottom];
            return;
        }
        
        else if (txtSecretPin.text.length==0)
        {
            [self.view makeToast:@"Password can not be blank"];
            return;
        }
        else if (txtConfirmPin.text.length==0)
        {
            [self.view makeToast:@"Confirm password can not be blank"];
            return;
        }
        else if (![txtConfirmPin.text isEqualToString:txtSecretPin.text])
        {
            [self.view makeToast:@"Confirm password is not same as password"];
            return;
        }
        else if (txtCompanyCode.text.length==0)
        {
            [self.view makeToast:@"Company code can not be blank"];
            return;
        }
        else if (btnUsedVehicle.selected==false && btnNewVehicle.selected==false)
        {
            [self.view makeToast:@"Select a salesperson type"];
            return;
        }
        
        else{
            
            //[self.view makeToast:@"Do you want to save?"];
            AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            NSString *strUsedVehicle =  [NSString stringWithFormat:@"%d",btnUsedVehicle.isSelected];
            NSString *strNewVehicle =  [NSString stringWithFormat:@"%d",btnNewVehicle.isSelected];
            
            if([appDelegateTemp checkInternetConnection]==true)
            {
                [[ApplicationData sharedInstance] showLoader];
                NSString *postString = [NSString stringWithFormat:@"sEmail=%@&sPassword=%@&sCode=%@&sFirstName=%@&sLastName=%@&mode=%@&sNewVehicalSales=%@&sUsedVehicalSales=%@",txtUserName.text,txtConfirmPin.text,txtCompanyCode.text,txtFirstName.text,txtLastName.text,@"add",strNewVehicle, strUsedVehicle];
                
                [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
                HTTPManager *manager = [HTTPManager managerWithURL:KRegisterNewUser];
                
                [manager setPostString:postString];
                manager.requestType = HTTPRequestTypeSignUp;
                [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
                    DLog(@"%@",bodyDict);
                    if(bodyDict.count>0){
                        if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                            
                            NSArray *userDetailArr = [bodyDict valueForKey:@"userdetails"];
                            NSDictionary *userDetailDict = [userDetailArr  objectAtIndex:0];
                            
                            NSURL *url;
                            NSString *strImage = [NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"thumb_CompanyImage"]];
                            url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                            
                            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
                            
                            
                            [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation([UIImage imageWithData:imageData]) forKey:@"thumb_CompanyImage"];
                            
                            //persist nUserId in application.
                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:UserId]]forKey:UserId];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:[userDetailDict valueForKey:ComapnyCode] forKey:ComapnyCode];
                            
                            DLog(@"%@",[userDetailDict valueForKey:UserId]);
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [self insertNewUserToLocalDatabase:true];
                            
                            
                            [self SetLeftmenuItems];
                            isAddedSuccess=true;
                            
                        }
                        else
                        {
                            isAddedSuccess=false;
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup"                                                    message:[NSString stringWithFormat:@"%@",[bodyDict valueForKey:@"msg"]] delegate:self
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles: nil, nil];
                            [alert show];
                        }
                    }
                } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                    isAddedSuccess=false;
//                    [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
                    
                } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                    
                }];
                
            }
            else
            {
                NSString *newRegisterId = [[NSUserDefaults standardUserDefaults] valueForKey:UserId];
                if(newRegisterId==nil)
                {
                    newRegisterId=0;
                }
                NSInteger newRegisterIdInt;
                newRegisterIdInt=[newRegisterId integerValue]+1;
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)newRegisterIdInt] forKey:UserId];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIImage *thumb_CompanyImage =[UIImage imageNamed:@"logo"];
                NSData *imageData= UIImageJPEGRepresentation(thumb_CompanyImage,0.0);
                
                [[NSUserDefaults standardUserDefaults]setObject:UIImagePNGRepresentation([UIImage imageWithData:imageData]) forKey:@"thumb_CompanyImage"];
                
                [self insertNewUserToLocalDatabase:false];
                
                isAddedSuccess=true;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup"                                                    message:@"User data has been successfully added."
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil, nil];
                [alert show];
                
                
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
-(void)companyServiceForIsPay

{
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         
         NSLog(@"%@",bodyDict);
         
         NSString *ispay = [bodyDict valueForKey:@"IsPay"];
          NSString *isStatus=[bodyDict valueForKey:@"isStatus"];
         NSString *msg=[bodyDict valueForKey:@"msg"];
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
                                   initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             
             
         }
     }];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField* )textField{
    //    if(textField==txtCompanyCode)
    //    {
    //        if(isConnectedToInternet==true){
    //            [self.view endEditing:true];
    //            ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Select Company Code" delegate:self showCancelButton:NO origin:textField initialSelections:@[@(0)]];
    //            [picker showActionSheetPicker];
    //        }
    //        return YES;
    //    }
    return YES;
}

-(void)insertNewUserToLocalDatabase:(BOOL)IsAdded
{
    @try{
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setValue:txtFirstName.text forKey:@"sFirstName"];
        [dict setValue:txtLastName.text forKey:@"sLastName"];
        [dict setValue:txtUserName.text forKey:@"sEmail"];
        [dict setValue:txtSecretPin.text forKey:@"password"];
        [dict setValue:txtCompanyCode.text forKey:@"nCompanyId"];
        [dict setValue:[NSString stringWithFormat:@"%d",!IsAdded] forKey:@"IsAdded"];
        [dict setValue:strSalesPersonType forKey:@"salesPersonType"];
        
        [dict setValue:[NSString stringWithFormat:@"%d",btnNewVehicle.isSelected] forKey:@"sNewVehicalSales"];
        [dict setValue:[NSString stringWithFormat:@"%d",btnUsedVehicle.isSelected] forKey:@"sUsedVehicalSales"];
        NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
        [dict setValue:[NSString stringWithFormat:@"%@",strUserId] forKey:@"nUserId"];
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"thumb_CompanyImage"];
        NSString* strImageData1 = [Base64 encode:data];
        [dict setObject:strImageData1 forKey:@"thumb_CompanyImage"];
        
        [dbAccess insertuserData:dict];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void) SetLeftmenuItems{
    @try{
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        DashboardViewController *objDashboardViewController=(DashboardViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objDashboardViewController];
        DEMOLeftMenuViewController *leftMenuViewController = [DEMOLeftMenuViewController shareInstance];
        RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                        leftMenuViewController:leftMenuViewController
                                                                       rightMenuViewController:nil];
        
        sideMenuViewController.view.backgroundColor=[UIColor colorWithRed:(0/255.0f) green:(10/255.0f) blue:(230/255.0f) alpha:1.0f];
        sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
        sideMenuViewController.delegate = self;
        sideMenuViewController.contentViewShadowOpacity =0;
        appDelegateTemp.window.rootViewController = sideMenuViewController;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark ALERT
-(void)dispAlrt:(NSString*)txtmsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Signup"                                                    message:txtmsg
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if(isAddedSuccess)
        [self SetLeftmenuItems];
}
@end
