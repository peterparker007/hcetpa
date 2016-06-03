//
//  ForgetPasswordVC.m
//  ProPad
//
//  Created by Bhumesh on 07/08/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "ApplicationData.h"
#import "HTTPManager.h"
#import "LoginViewController.h"
#import "UIView+Toast.h"
@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC
{
    UIAlertView *alert ;
    bool isSuccess;
}
@synthesize txtUserName;
#pragma mark viewLifeCycle
- (void)viewDidLoad {
    @try{
    [super viewDidLoad];
     [self companyServiceForIsPay];
    [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtUserName];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
  // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    @try{
    self.navigationItem.title = @"Forget Password";
    
    [[UIBarButtonItem   appearance]setTintColor:[UIColor whiteColor]];
    isSuccess=false;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark textfieldDelegate
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isSuccess)
    {
        [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark btnAction
- (IBAction)onBtnSubmitTapped:(id)sender {
    @try {
      [self.view endEditing:true];
    if(txtUserName.text.length==0){
        [self.view makeToast:@"Please enter email address"];
        return;
    }
    AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    if([appDelegateTemp checkInternetConnection]==true)
    {
        [[ApplicationData sharedInstance] showLoader];
        
        //  NSString *postString = [NSString stringWithFormat:@"nUserId=%@",strUserId];
        NSString *postString=[NSString stringWithFormat:@"sEmail=%@", txtUserName.text];
        
        
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:KForgetPassword];
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                alert = [[UIAlertView alloc] initWithTitle:@"Forget Password"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [alert show];
                isSuccess=true;
            }
            else {
                alert = [[UIAlertView alloc] initWithTitle:@"Forget Password"                                                  message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [alert show];
                isSuccess=false;
                
            }
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
//            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
    }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

}
@end
