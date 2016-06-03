//
//  ViewController.m
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidationViewController.h"
#import "SignupViewController.h"
#import "DataBaseHelper.h"
#import "AppDelegate.h"
#import "FMDBDataAccess.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "HTTPManager.h"
#import "ApplicationData.h"
#import  "AppConstant.h"
#import "DashboardViewController.h"
#import "DEMOLeftMenuViewController.h"
#import "ForgetPasswordVC.h"
#import "RESideMenu.h"
#import "Base64.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()<HTTPManagerDelegate,RESideMenuDelegate> {
    FMDBDataAccess *dataBaseHelper;
}
@end

@implementation LoginViewController
{
    NSInteger *isPayCHeak;
}
@synthesize txtUserName;
@synthesize txtPassword;
@synthesize btnRememberMe;
@synthesize scrlView,lblForgetPass,lblNewUserRegister;
#pragma mark view life cycle
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self initV];
        dataBaseHelper = [[FMDBDataAccess alloc]init];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession setActiveSession:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title=@"";
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.title=@"Login";
}

-(void)initV
{
    @try{
        self.navigationItem.title=@"Login";
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        //SET Image in Right View.
        [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtUserName];
        [self setTextFieldWithImage:[UIImage imageNamed:@"Password"] txtField:txtPassword];
        //for Retriving value from NSUserDefailt.
        txtUserName.text= [[NSUserDefaults standardUserDefaults]
                           stringForKey:@"UserName"];
        [scrlView setContentOffset:CGPointMake(0, 0) animated:NO];
        txtPassword.text = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"Password"];
        
        if(txtUserName.text.length>0){
            self.btnRememberMe.selected=YES;
    
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"isUserLogin"])
            {
                [self SetLeftmenuItems];
                return;
            }
        }
        
        if(IS_IPAD){
            txtUserName.font = [UIFont systemFontOfSize:16];
            txtPassword.font = [UIFont systemFontOfSize:16];
            self.btnRememberMe.titleLabel.font = [UIFont systemFontOfSize:16];
            lblForgetPass.titleLabel.font = [UIFont systemFontOfSize:16];
            lblNewUserRegister.font = [UIFont systemFontOfSize:16];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma textFieldDelegate
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark OnbtnAction
- (IBAction)onBtnForgetPasswordTapped:(id)sender {
    @try{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        ForgetPasswordVC *second=(ForgetPasswordVC *)[storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordVC"];
        [self.navigationController pushViewController:second animated:YES];
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
         [self showProgressHud];
         NSLog(@"%@",bodyDict);
         
         NSString *ispay = [bodyDict valueForKey:@"IsPay"];
         NSString *isStatus=[bodyDict valueForKey:@"isStatus"];
         NSString *msg=[bodyDict valueForKey:@"msg"];
          if ([ispay isEqual:@"0"]||[isStatus isEqual:@"0"])
         {
              [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isUserLogin"];
             
             UIAlertView *alert = [[UIAlertView alloc]
                                   initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [alert show];
             [self hideProgressHud];
             
             
         }
         else
         {
             [[NSUserDefaults standardUserDefaults] synchronize];
             
             [[ApplicationData sharedInstance] hideLoader];
             [self SetLeftmenuItems];
         }
         
     }];
    
}
- (IBAction)onBtnSubmitTapped:(id)sender {
    
    [self hideProgressHud];
    
    @try{
        [self.view endEditing:YES];
        if(txtUserName.text.length==0){
            [self.view makeToast:@"Email address cannot be blank."];
            return;
        }
        if(txtPassword.text.length==0){
            [self.view makeToast:@"Password cannot be blank."];
            return;
        }
        if(self.btnRememberMe.isSelected)
        {
            [[NSUserDefaults standardUserDefaults] setObject:txtUserName.text forKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults] setObject:txtPassword.text forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserName"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true)
        {
            [[ApplicationData sharedInstance] showLoader];
            NSString *postString = [NSString stringWithFormat:@"sEmail=%@&sPassword=%@",txtUserName.text,txtPassword.text];
            HTTPManager *manager = [HTTPManager managerWithURL:KLogin];
            
            [manager setPostString:postString];
            manager.requestType = HTTPRequestTypeGeneral;
            [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
                DLog(@"%@",bodyDict);
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isUserLogin"];
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    dict=[bodyDict valueForKey:@"userdetails"];
                    //persist nUserId in application.
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[dict valueForKey:UserId]]forKey:UserId];
                    DLog(@"%@",[dict valueForKey:UserId]);
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:ComapnyCode] forKey:ComapnyCode];
                    [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:@"CompanyImage"] forKey:@"CompanyImage"];
                    NSURL *url;
                    NSString *strImage = [NSString stringWithFormat:@"%@",[dict valueForKey:@"CompanyImage"]];
                    url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
                    [self companyServiceForIsPay];
                    [self insertUserToLocalDataBase:dict];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                    return;
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                  message:@"Please enter valid email address and password." delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                    [alert show];
                    [[ApplicationData sharedInstance] hideLoader];
                }
                
            } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                [[ApplicationData sharedInstance] hideLoader];
                
                //                         [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
                
            } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                
            }];
            return;
        }
        else if ([dataBaseHelper checkUserLogin:txtUserName.text andPassword:txtPassword.text])
        {
            [self SetLeftmenuItems];
        }
        else
        {
            [self.view makeToast:@"User is not registered."];
            return;
        }   } @catch (NSException *exception) {
            NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
        }
    @finally {
    }
    
    
}
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
    
    id<NSURLAuthenticationChallengeSender> sender = [challenge sender];
    
    if ([[protectionSpace authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        SecTrustRef trust = [[challenge protectionSpace] serverTrust];
        
        NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:trust];
        
        [sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    else
    {
        [sender performDefaultHandlingForAuthenticationChallenge:challenge];
    }
}
-(void)insertUserToLocalDataBase:(NSMutableDictionary *)dict
{
    @try{
        NSMutableDictionary *dict1 = [dict mutableCopy];
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        
        NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"CompanyImage"];
        NSString* strImageData1 = [Base64 encode:data];
        [dict1 setValue:strImageData1 forKey:@"thumb_CompanyImage"];
        [dict1 setValue:txtPassword.text forKey:@"password"];
        
        // [dict setObject:strImageData1 forKey:@"thumb_CompanyImage"];
        if (![dataBaseHelper checkUserLogin:txtUserName.text andPassword:txtPassword.text])
        {
            [dbAccess insertuserData:dict1];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
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
#pragma mark OnBtnAction
- (IBAction)onBtnRememberMeTapped:(id)sender {
    btnRememberMe.selected=!btnRememberMe.selected;
}
- (IBAction)onBtnSignUpTapped:(id)sender  {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    SignupViewController *second=(SignupViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    [self.navigationController pushViewController:second animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ProgressHud
- (void) showProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [progressHUD setLabelText:@"Please wait"];
    });
}
- (void) hideProgressHud
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    });
}

@end

