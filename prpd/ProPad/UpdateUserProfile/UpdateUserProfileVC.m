//
//  UpdateUserProfileVC.m
//  ProPad
//
//  Created by Bhumesh on 04/08/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "UpdateUserProfileVC.h"
#import "UIViewController+NavigationBar.h"
#import "AppDelegate.h"
#import "ApplicationData.h"
#import "Constant.h"
#import  "AppConstant.h"
#import "FMDBDataAccess.h"
#import "RESideMenu.h"
#import "DashboardViewController.h"
#import "Base64.h"
#import <Social/Social.h>

#import "SharePhotoAndCommentViewController.h"
@interface UpdateUserProfileVC ()<RESideMenuDelegate,UIAlertViewDelegate>
{
    NSString *strUserId;
    BOOL isNewUesr;
}

@end
@implementation UpdateUserProfileVC
@synthesize txtFirstName,txtCompanyCode,txtLastName,txtUserName,txtPassword;
@synthesize scrollView,lblTapOnHint;
@synthesize btnFacebook,btnGoogle,btnLinkedIn,btnTwitter;
#pragma mark View Life Cycle
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        userDetailArr = [NSMutableArray alloc];
        strUserId = [[NSUserDefaults standardUserDefaults]
                     stringForKey:UserId];
        [self initV];
        [self companyServiceForIsPay];
        isNewUesr=false;
        scrollView.scrollEnabled=true;
        if(IS_IPAD)
        {
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setContentSize:CGSizeMake(600, 1400)];    // Do any additional setup after loading the view.
            
            txtFirstName.font = [UIFont systemFontOfSize:16];
            txtCompanyCode.font = [UIFont systemFontOfSize:16];
            txtLastName.font = [UIFont systemFontOfSize:16];
            txtUserName.font = [UIFont systemFontOfSize:16];
            txtPassword.font = [UIFont systemFontOfSize:16];
            btnFacebook.titleLabel.font = [UIFont systemFontOfSize:16];
            btnGoogle.titleLabel.font = [UIFont systemFontOfSize:16];
            btnLinkedIn.titleLabel.font = [UIFont systemFontOfSize:16];
            btnTwitter.titleLabel.font = [UIFont systemFontOfSize:16];
            lblTapOnHint.font = [UIFont systemFontOfSize:16];
        }
        else
        {
            [self.scrollView setScrollEnabled:YES];
            [self.scrollView setContentSize:CGSizeMake(600, 100)];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    // Do any additional setup after loading the view.
}

-(void)initV
{
    self.navigationItem.title=@"Profile";
    //    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    //
    //    strUserId = [[NSUserDefaults standardUserDefaults]
    //                 stringForKey:UserId];
    //    NSString *strImage=[dbAccess getThumbImage:strUserId];
    //
    //    NSData *imageData = [Base64 decode:strImage];
    //    UIImage* image = [UIImage imageWithData:imageData];
    //    self.imgCompanyThumb.image =image;
    [self dispData];
    btnEdit = [[UIBarButtonItem alloc]
               initWithTitle:@"Edit"
               style:UIBarButtonItemStylePlain
               target:self
               action:@selector(editData)];
    [btnEdit setTintColor:[UIColor whiteColor]];
    [btnEdit setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIFont fontWithName:@"Helvetica-Neue" size:26.0], NSFontAttributeName,
                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                     nil]
                           forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = btnEdit;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setMenuIconForSideBar:@"menu"];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtFirstName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtLastName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtUserName];
    [self setTextFieldWithImage:[UIImage imageNamed:@"locate-icon"] txtField:txtPassword];
    [self setTextFieldWithImage:[UIImage imageNamed:@"companycode-icon"] txtField:txtCompanyCode];
    [self dispData];
    [self setTextFieldToUserData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
 [[ApplicationData sharedInstance] hideLoader];
}
-(void) dispData
{
    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    if([appDelegateTemp checkInternetConnection]==true)
    {
        [[ApplicationData sharedInstance] showLoader];
        NSString *postString = [NSString stringWithFormat:@"nUserId=%@",strUserId];
        HTTPManager *manager = [HTTPManager managerWithURL:KUserList];
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                NSArray *arrUser = [bodyDict valueForKey:@"userdetails"];
                userDetailArr = [arrUser mutableCopy];
                DLog(@"%@",userDetailArr);
                
                
              //  NSURL *url;
              //  NSString *strImage = [NSString stringWithFormat:@"%@",[userDetailArr valueForKey:@"CompanyImage"]];
                
             //   url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
              //  NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
             //   self.imgCompanyThumb.image = [UIImage imageWithData:imageData];
                
                
                
                NSURL *url;
                NSString *strImage = [NSString stringWithFormat:@"%@",[userDetailArr valueForKey:@"CompanyImage"]];
                
                url = [NSURL URLWithString:strImage];
                self.imgCompanyThumb.imageURL = url;
                self.imgCompanyThumb.showActivityIndicator=true;
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.imgCompanyThumb.imageURL];
                
                
                
                
                
                
                NSString *strCompanyCode = [[NSUserDefaults standardUserDefaults] objectForKey:ComapnyCode];
                
                if([strCompanyCode length]>0)
                    txtCompanyCode.text=strCompanyCode;
                [self setTextFieldToUserData];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [alert show];
                
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
//            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
    }
    else
    {
        NSArray *arrUser = [dbAccess getUsers:[NSString stringWithFormat:@"%@",strUserId]];
        userDetailArr = [arrUser[0] mutableCopy];
        DLog("%@",userDetailArr);
        [self setTextFieldToUserData];
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
-(void)setTextFieldToUserData
{
    @try{
        if(userDetailArr.count>0)
        {
            txtFirstName.text = [userDetailArr valueForKey:@"sFirstName"];
            txtLastName.text = [userDetailArr valueForKey:@"sLastName"];
            txtUserName.text = [userDetailArr valueForKey:@"sEmail"];
            txtCompanyCode.text = [userDetailArr valueForKey:@"nCompanyId"];
            txtPassword.text = [userDetailArr valueForKey:@"password"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
#pragma mark - user update
-(void)updateUserToLocalDatabase:(BOOL)IsAdded
{
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:txtFirstName.text forKey:@"sFirstName"];
    [dict setValue:txtLastName.text forKey:@"sLastName"];
    [dict setValue:txtUserName.text forKey:@"sEmail"];
    [dict setValue:txtPassword.text forKey:@"password"];
    [dict setValue:txtCompanyCode.text forKey:@"nCompanyId"];
    [dict setValue:[NSString stringWithFormat:@"%@",strUserId] forKey:@"nUserId"];
    if (IsAdded){
        [dict setValue:[NSString stringWithFormat:@"%d",0] forKey:@"IsAdded"];
        [dbAccess updateUserData:dict];
    }
    else{
        [dict setValue:[NSString stringWithFormat:@"%d",1] forKey:@"IsAdded"];
        
        if([dbAccess updateUserData:dict])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile"                                                  message:@"User Data updated successfully." delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
            
        }
    }
}
#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isNewUesr)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        DashboardViewController *objDashboardViewController=(DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objDashboardViewController]
                                                     animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textField Delegate
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
-(void)editData
{
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         //[self showProgressHud];
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
             //[self hideProgressHud];
             
             
         }
         
         else{
    
    txtFirstName.enabled=true;
    txtLastName.enabled=true;
    txtUserName.enabled=true;
    txtPassword.enabled=false;
    txtCompanyCode.enabled=false;
    [self.view endEditing:false];
    [txtFirstName becomeFirstResponder];
         }}];
}

- (IBAction)onUpdatebtnTapped:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         //[self showProgressHud];
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
             //[self hideProgressHud];
             
             
         }
         
         else{
             @try{
                 AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                 if([appDelegateTemp checkInternetConnection]==true)
                 {
                     [[ApplicationData sharedInstance] showLoader];
                     NSString *postString = [NSString stringWithFormat:@"sEmail=%@&sPassword=%@&sCode=%@&sFirstName=%@&sLastName=%@&mode=%@&nUserId=%@",txtUserName.text,txtPassword.text,txtCompanyCode.text,txtFirstName.text,txtLastName.text,@"edit",strUserId];
                     [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
                     HTTPManager *manager = [HTTPManager managerWithURL:KRegisterNewUser];
                     
                     [manager setPostString:postString];
                     manager.requestType = HTTPRequestTypeSignUp;
                     [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
                         DLog(@"%@",bodyDict);
                         if(bodyDict.count>0){
                             if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                                 isNewUesr=true;
                                 [self updateUserToLocalDatabase:true];
                                 
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self
                                                                       cancelButtonTitle:@"Ok"
                                                                       otherButtonTitles: nil, nil];
                                 [alert show];
                             }
                             else
                             {
                                 isNewUesr=false;
                                 
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                message:[bodyDict valueForKey:@"msg"] delegate:self
                                                                       cancelButtonTitle:@"Ok"
                                                                       otherButtonTitles: nil, nil];
                                 [alert show];
                                 
                             }
                         }
                         
                     } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                         
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                  message:@"Email already registered." delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles: nil, nil];
                         [alert show];
//                         [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
                         
                     } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                 message:@"Email already registered." delegate:self
                                                               cancelButtonTitle:@"Ok"
                                                               otherButtonTitles: nil, nil];
                         [alert show];
                         
                         
                     }];
                     
                 }
                 else
                 {
                     [self updateUserToLocalDatabase:false];
                 }
             } @catch (NSException *exception) {
                 NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
             }
             @finally {
             }
         }
     }];
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

#pragma mark - Social sharing btn Action

- (IBAction)btnFacebookPressed:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
   [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
    
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
             //[self hideProgressHud];
             
             
         }
         
         else{
    @try{
        SharePhotoAndCommentViewController *second=(SharePhotoAndCommentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SharePhotoAndCommentViewController"];
        second.socialMediaStr = @"Facebook";
        
        [self.navigationController pushViewController:second animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }
}];
}

- (IBAction)btnTwitterPressed:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         //[self showProgressHud];
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
             //[self hideProgressHud];
             
             
         }
         
         else{
    @try{
        SharePhotoAndCommentViewController *second=(SharePhotoAndCommentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SharePhotoAndCommentViewController"];
        second.socialMediaStr = @"Twitter";
        
        [self.navigationController pushViewController:second animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }
     }];
    
}

- (IBAction)btnGooglePressed:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         //[self showProgressHud];
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
             //[self hideProgressHud];
             
             
         }
         
         else{
    @try{
        SharePhotoAndCommentViewController *second=(SharePhotoAndCommentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SharePhotoAndCommentViewController"];
        second.socialMediaStr = @"GooglePlus";
        
        [self.navigationController pushViewController:second animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }
     }];
    
}

- (IBAction)btnLinkedinPressed:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
    
    [objappData getIspayList:sendParamsContact withcomplitionblock:^(NSMutableDictionary *bodyDict, int status)
     {
         //[self showProgressHud];
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
             //[self hideProgressHud];
             
             
         }
         
         else{
    @try{
        SharePhotoAndCommentViewController *second=(SharePhotoAndCommentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SharePhotoAndCommentViewController"];
        second.socialMediaStr = @"LinkedIn";
        [self.navigationController pushViewController:second animated:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }
     }];
    
}
//-(void)alertForSocialMediabtnPress
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Profile"                                                  message:@"Coming soon." delegate:self
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles: nil, nil];
//    [alert show];
//}
@end
