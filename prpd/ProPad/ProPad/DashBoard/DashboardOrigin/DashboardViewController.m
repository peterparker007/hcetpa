//
//  DashboardViewController.m
//  ProPad
//
//  Created by Bhumesh on 24/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "DashboardViewController.h"
#import "DEMOLeftMenuViewController.h"
#import "CustomerListViewController.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
#import "UIViewController+NavigationBar.h"
#import "ApplicationData.h"
#import "AppConstant.h"
#import "FMDatabase.h"
#import "FMDBDataAccess.h"
#import "Base64.h"
#import "PJRadioCell.h"



@interface DashboardViewController ()<RESideMenuDelegate>
{
    NSInteger userIdInt;
    NSString *strUserId;
    MBProgressHUD *hud;
    PJRadioCell *rc1;
}
@end
@implementation DashboardViewController
@synthesize txtCustomerList;
@synthesize txtNewCustomer;
@synthesize txtAboutUs;

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try {
      [super viewDidLoad];
         [self setMenuIconForSideBar:@"menu"];
    [self initV];
    [self companyServiceForIsPay];
    [self setMenuIconForSideBar:@"menu"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}
- (void)viewWillAppear:(BOOL)animated {
    @try{

    [self performSelectorInBackground:@selector(insertDataWhenOnline) withObject:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}
-(void)initV
{
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];

    strUserId = [[NSUserDefaults standardUserDefaults]
                 stringForKey:UserId];
   
    self.navigationItem.title=@"DashBoard";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setLeftModeForTextField:[UIImage imageNamed:@"customerlist"] txtField:txtCustomerList];
    [self setLeftModeForTextField:[UIImage imageNamed:@"newcustomer"] txtField:txtNewCustomer];
    [self setLeftModeForTextField:[UIImage imageNamed:@"about"] txtField:txtAboutUs];
    [self setRightModeForTextField:[UIImage imageNamed:@"rightarrow"] txtField:txtCustomerList];
    [self setRightModeForTextField:[UIImage imageNamed:@"rightarrow"] txtField:txtNewCustomer];
    [self setRightModeForTextField:[UIImage imageNamed:@"rightarrow"] txtField:txtAboutUs];
     [self dispData];
    
}

#pragma mark - text field delegate
-(void)setLeftModeForTextField:(UIImage*)image txtField:(UITextField*)txtField
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, image.size.width, image.size.height)];
    imgView.image = image;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [paddingView addSubview:imgView];
    [txtField setLeftViewMode:UITextFieldViewModeAlways];
    [txtField setLeftView:paddingView];
    txtField.leftViewMode = UITextFieldViewModeAlways;
}
-(void)setRightModeForTextField:(UIImage*)image txtField:(UITextField*)txtField
{
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, 0, image.size.width, image.size.height)];
    imgView.image = image;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [paddingView addSubview:imgView];
    [txtField setRightViewMode:UITextFieldViewModeAlways];
    [txtField setRightView:paddingView];
    txtField.rightViewMode = UITextFieldViewModeAlways;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - onbtn action
- (IBAction)onCustomerListTapped:(id)sender {
    @try{
    DEMOLeftMenuViewController *leftMenuViewController = [DEMOLeftMenuViewController shareInstance];
    [leftMenuViewController setLeftmenuItems:1];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }


}

- (IBAction)onNewCustomerTapped:(id)sender {
    @try{
        AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [appdel.dataDictionary removeAllObjects];
        appdel.dataDictionary =nil;
        rc1=[[PJRadioCell alloc]init];
       
        //rc1=[[PJRadioCell alloc]init];
        [rc1.selectedOption removeAllObjects];
    DEMOLeftMenuViewController *leftMenuViewController = [DEMOLeftMenuViewController shareInstance];
    [leftMenuViewController setLeftmenuItems:2];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}

- (IBAction)onAboutUsTapped:(id)sender {
    @try{
        
        DEMOLeftMenuViewController *leftMenuViewController = [DEMOLeftMenuViewController shareInstance];
        [leftMenuViewController setLeftmenuItems:4];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dashboard"                                                   message:@"Coming soon." delegate:self
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles: nil, nil];
//    [alert show];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}
-(void) dispData
{
    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
    if([appDelegateTemp checkInternetConnection]==true)
    {
        [[ApplicationData sharedInstance] showLoader];
        NSString *postString = [NSString stringWithFormat:@"nUserId=%@",strUserId];
        HTTPManager *manager = [HTTPManager managerWithURL:KUserList];
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                 [hud hide:YES];
                NSArray *arrUser = [bodyDict valueForKey:@"userdetails"];
                userDetailArr = [arrUser mutableCopy];
                DLog(@"%@",userDetailArr);
               [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[userDetailArr valueForKey:CompanyId]]forKey:CompanyId];
                
               [[NSUserDefaults standardUserDefaults] setObject:[userDetailArr valueForKey:@"CompanyImage"] forKey:@"CompanyImage"];
                
                NSURL *url;
                NSString *strImage = [NSString stringWithFormat:@"%@",[userDetailArr valueForKey:@"CompanyImage"]];
                
                url = [NSURL URLWithString:strImage];
                 self.imgCompanyThumb.imageURL = url;
                self.imgCompanyThumb.showActivityIndicator=true;
                
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:self.imgCompanyThumb.imageURL];
//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
//                self.imgCompanyThumb.image = [UIImage imageWithData:imageData];
               
              /*  NSData* myEncodedImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myEncodedImageDataKey"];
                UIImage* image = [UIImage imageWithData:myEncodedImageData];*/
            

            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [hud hide:YES];
                [alert show];
                [hud hide:YES];

            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            [hud hide:YES];

//            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            [hud hide:YES];

        }];
    }
    else
    {
        [hud hide:YES];

        NSArray *arrUser = [dbAccess getUsers:[NSString stringWithFormat:@"%@",strUserId]];
        userDetailArr = [arrUser[0] mutableCopy];
        DLog("%@",userDetailArr);
       
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
-(void)insertDataWhenOnline
{
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    NSArray *arrRemainingData=[dbAccess CheckRemainingDataForUser];
    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if([appDelegateTemp checkInternetConnection]==true)
    {
        [[ApplicationData sharedInstance] showLoader];
        NSString *postString = [NSString stringWithFormat:@"sEmail=%@&sPassword=%@&sCode=%@&sFirstName=%@&sLastName=%@&mode=%@", [arrRemainingData valueForKey:@"sFirstName"],
                                [arrRemainingData valueForKey:@"sLastName"],
                                [arrRemainingData valueForKey:@"sEmail"],
                                [arrRemainingData valueForKey:@"nCompanyId"],
                                [arrRemainingData valueForKey:@"password"],@"add"];
        [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
        HTTPManager *manager = [HTTPManager managerWithURL:KRegisterNewUser];
        
        [manager setPostString:postString];
        manager.requestType = HTTPRequestTypeSignUp;
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            if(bodyDict.count>0)
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    NSArray *userDetailArr = [response valueForKey:@"userdetails"];
                    NSDictionary *userDetailDict = [userDetailArr  objectAtIndex:0];
                    userIdInt = [[userDetailDict valueForKey:@"nUserId"] integerValue];
                    NSString *strId = [NSString stringWithFormat:@"%ld",(long)userIdInt];
                    UDSetObject(strId, UserId);
                }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
//            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        [[ApplicationData sharedInstance] hideLoader];
    }
}

@end
