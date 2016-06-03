//
//  AddClientSectionOneViewController.m
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "AddClientSectionOneViewController.h"
#import "AddClientSectionTwoViewController.h"
#import "UIView+Toast.h"
#import "ActionSheetStringPicker.h"
#import "FMDBDataAccess.h"
#import "UIView+Toast.h"
#import "ValidationViewController.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "UIViewController+NavigationBar.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetCustomPicker.h"
#import "IQKeyboardManager.h"
#import "Constant.h"
#import "AppConstant.h"
#import "HTTPManager.h"
#import "ApplicationData.h"
@interface AddClientSectionOneViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate,ActionSheetCustomPickerDelegate>
{
    NSString *strCustTypeSelected;
    NSString *strAppointmentTypeSelected;
    NSString *strAboutUsSelected;
    NSString *strPreferredSelected;
    NSString *sStartTime;
    NSArray *custTypeArray;
    NSArray *referenceArray;
    BOOL isCustType;
    BOOL isRefernce;
    UITextField *activeField;
    NSArray *arrSelectStatelDropDown;
    NSDateFormatter *dateFormatter;
    
    
}

@end

@implementation AddClientSectionOneViewController
@synthesize dict;
@synthesize txtAddress,txtLastName,txtFirstName,txtCity,txtMobile,txtHome,txtWork,txtEmail,txtCityCode,txtState;
@synthesize btnEmail,btnText,btnPhone,btnBeBack,btnFirstTimeCustomer,btnInternet,btnOther,btnReferral,btnThirdPartyWebsite,btnWalkIn,btnAppointmentInternet,btnSelfgenerated,btnNotAppointment,btnMailer;
@synthesize pickerView,scrollView,clientView;
@synthesize  lblAppointment,lblCustomerType,lbleHowDidYouHear,lblPreferredContact,lblCutomerInfo,lblTime;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        [self startTimedTask];
        [self companyServiceForIsPay];
        dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];
        sStartTime=[dateFormatter stringFromDate:[NSDate date]];
        
        [self registerForKeyboardNotifications];
        
        if(IS_IPAD )
            heightConst.constant=1300;
        else if (IS_IPHONE_6 || IS_IPHONE_6P)
            heightConst.constant=1000;
        
        dict = [[NSMutableDictionary alloc] init];
        
        self.navigationController.title  = @"New Customer";
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        
        [self.clientView addGestureRecognizer:tap];
        
        isCustType=false;
        isRefernce=false;
        
        [self setMenuIconForSideBar:@"menu"];
        [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtFirstName];
        [self setTextFieldWithImage:[UIImage imageNamed:@"user-icon"] txtField:txtLastName];
        
        [self setTextFieldWithImage:[UIImage imageNamed:@"address-icon"] txtField:txtAddress];
        [self setTextFieldWithImage:[UIImage imageNamed:@"city-icon"] txtField:txtCity];
        [self setTextFieldWithImage:[UIImage imageNamed:@"state-icon"] txtField:txtState];
        [self setTextFieldWithImage:[UIImage imageNamed:@"zip-icon"] txtField:txtCityCode];
        
        [self setTextFieldWithImage:[UIImage imageNamed:@"phone-icon"] txtField:txtMobile];
        [self setTextFieldWithImage:[UIImage imageNamed:@"phone-icon"] txtField:txtHome];
        [self setTextFieldWithImage:[UIImage imageNamed:@"phone-icon"] txtField:txtWork];
        [self setTextFieldWithImage:[UIImage imageNamed:@"email-icon"] txtField:txtEmail];
        
        
        arrSelectStatelDropDown = [NSArray arrayWithObjects:@"AL" ,@"AK" ,@"AZ" ,@"AR" ,@"CA" ,@"CO" ,@"CT" ,@"DE" ,@"FL" ,@"GA" ,@"HI" ,@"ID" ,@"IL" ,@"IN" ,@"IA" ,@"KS" ,@"KY" ,@"LA" ,@"ME" ,@"MD" ,@"MA" ,@"MI" ,@"MN" ,@"MS" ,@"MO" ,@"MT" ,@"NE" ,@"NV" ,@"NH" ,@"NJ" ,@"NM" ,@"NY" ,@"NC" ,@"ND" ,@"OH" ,@"OK" ,@"OR" ,@"PA" ,@"RI" ,@"SC" ,@"SD" ,@"TN" ,@"TX" ,@"UT" ,@"VT" ,@"VA" ,@"WA" ,@"WV" ,@"WI" ,@"WY" ,nil];
        
        if(IS_IPAD){
            txtAddress.font = [UIFont systemFontOfSize:16];
            txtLastName.font = [UIFont systemFontOfSize:16];
            txtFirstName.font = [UIFont systemFontOfSize:16];
            txtCity.font = [UIFont systemFontOfSize:16];
            txtMobile.font = [UIFont systemFontOfSize:16];
            txtHome.font = [UIFont systemFontOfSize:16];
            txtWork.font = [UIFont systemFontOfSize:16];
            txtEmail.font = [UIFont systemFontOfSize:16];
            txtCityCode.font = [UIFont systemFontOfSize:16];
            txtState.font = [UIFont systemFontOfSize:16];
            btnEmail.titleLabel.font = [UIFont systemFontOfSize:16];
            btnText.titleLabel.font = [UIFont systemFontOfSize:16];
            btnPhone.titleLabel.font = [UIFont systemFontOfSize:16];
            btnBeBack.titleLabel.font = [UIFont systemFontOfSize:16];
            btnFirstTimeCustomer.titleLabel.font = [UIFont systemFontOfSize:16];
            btnInternet.titleLabel.font = [UIFont systemFontOfSize:16];
            btnOther.titleLabel.font = [UIFont systemFontOfSize:16];
            btnReferral.titleLabel.font = [UIFont systemFontOfSize:16];
            btnThirdPartyWebsite.titleLabel.font = [UIFont systemFontOfSize:16];
            btnWalkIn.titleLabel.font = [UIFont systemFontOfSize:16];
            btnAppointmentInternet.titleLabel.font = [UIFont systemFontOfSize:16];
            btnSelfgenerated.titleLabel.font = [UIFont systemFontOfSize:16];
            btnNotAppointment.titleLabel.font = [UIFont systemFontOfSize:16];
            btnMailer.titleLabel.font = [UIFont systemFontOfSize:16];
            
            lblAppointment.font = [UIFont systemFontOfSize:18];
            lblCustomerType.font = [UIFont systemFontOfSize:18];
            lbleHowDidYouHear.font = [UIFont systemFontOfSize:18];
            lblPreferredContact.font = [UIFont systemFontOfSize:18];
            lblCutomerInfo.font = [UIFont systemFontOfSize:20];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

//-(void)userIDForEmail
//{
//    NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
//    
//    NSString *postString = [NSString stringWithFormat:@"nUserId=%@",strUserId];
//   // HTTPManager *manager = [HTTPManager managerWithURL:URL_EmailFromUserID];
//    
//    [manager setPostString:postString];
//    manager.requestType = HTTPRequestTypeGeneral;
//    [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict)
//     {
//         
//         NSLog(@"%@",bodyDict);
//         
//     }
//                            failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error)
//     {
//         
//     }
//                        didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//                            
//                        }];
//    
//    
//}
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


- (void)startTimedTask
{
    NSTimer *fiveSecondTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(performBackgroundTask) userInfo:nil repeats:YES];
}

- (void)performBackgroundTask
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update UI
            [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss"];
            lblTime.text=[dateFormatter stringFromDate:[NSDate date]];
        });
    });
}

-(void)dismissKeyboard {
    [self.clientView endEditing:YES];
}


- (void)menuAction
{
    [self.sideMenuViewController presentLeftMenuViewController];
}
-(void)viewWillAppear:(BOOL)animated
{
   // [self userIDForEmail];
    self.navigationItem.title=@"";
    NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    AppDelegate *appDelegateTemp= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (appDelegateTemp.NewcustomerClick)
    {
        [self SendMail];
        
    }
}
-(void)SendMail
{
    NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    AppDelegate *appDelegateTemp= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegateTemp.NewcustomerClick=FALSE;
    
    if([appDelegateTemp checkInternetConnection]==true)
    {
        
        NSString *postString = [NSString stringWithFormat:@"nUserId=%@&nCompanyId=%@&dDate=%@",strUserId,[[NSUserDefaults standardUserDefaults] objectForKey:CompanyId],sStartTime];
        HTTPManager *manager = [HTTPManager managerWithURL:KNotify];
        // NSString *postString = [NSString stringWithFormat:@"nCompanyId=%@",[[NSUserDefaults standardUserDefaults] objectForKey:CompanyId]];
        
        [manager setPostString:postString];
        manager.requestType = HTTPRequestTypeGeneral;
        
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            DLog(@"%@",bodyDict);
            
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        //     [self SendMail];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title=@"";
}

- (void)viewDidAppear:(BOOL)animated
{
    @try{
        self.navigationItem.title  = @"New Customer";
        scrollView.contentSize= CGSizeMake(self.view.frame.size.width-10, 717);
        if (IS_IPAD ) {
            scrollView.contentSize= CGSizeMake(self.view.frame.size.width-10, 1400);
        }
        else if (IS_IPHONE_6 || IS_IPHONE_6P)
            scrollView.contentSize= CGSizeMake(self.view.frame.size.width-10, 1000);
        
        objUser = [UsersData sharedManager];
        dict = objUser.dictUsersData ;
        
        NSString *strFirstName = [dict valueForKey:@"sFirstName"];
        if( ![self isNotNull:strFirstName] && strFirstName.length>0)
            txtFirstName.text = strFirstName;
        
        NSString *strLastName = [dict valueForKey:@"sLastName"];
        if( ![self isNotNull:strLastName] && strLastName.length>0)
            txtLastName.text = strLastName;
        
        NSString *strAddress = [dict valueForKey:@"sAddress"];
        if( ![self isNotNull:strAddress] && strAddress.length>0)
            txtAddress.text = strAddress;
        
        NSString *strCity = [dict valueForKey:@"sCity"];
        if( ![self isNotNull:strCity] && strCity.length>0)
            txtCity.text = strCity;
        
        NSString *strCityCode = [dict valueForKey:@"sZip"];
        if( ![self isNotNull:strCityCode] && strCityCode.length>0)
            txtCityCode.text = strCityCode;
        
        NSString *strMobile = [dict valueForKey:@"nMobile"];
        if( ![self isNotNull:strMobile] && strMobile.length>0)
            txtMobile.text = strMobile;
        
        NSString *strHome = [dict valueForKey:@"sHome"];
        if( ![self isNotNull:strHome] && strHome.length>0)
            txtHome.text = strHome;
        
        NSString *strWork = [dict valueForKey:@"sWork"];
        if( ![self isNotNull:strWork] && strWork.length>0)
            txtWork.text = strWork;
        
        NSString *strEmail = [dict valueForKey:@"sEmail"];
        if( ![self isNotNull:strEmail] && strEmail.length>0)
            txtEmail.text = strEmail;
        
        NSString *strPreferContType = [dict valueForKey:@"PreferContType"];
        if(strPreferContType.length !=0)
            [self initAboutUs:strPreferContType];
        
        NSString *strCustomerType = [dict valueForKey:@"sCustomerType"];
        if(strCustomerType.length !=0)
            [self initCustType:strCustomerType];
        
        NSString *strAppointment = [dict valueForKey:@"sAppointment"];
        if(strAppointment.length !=0)
            [self initAppointmentType:strAppointment];
        
        NSString *strHearAbout = [dict valueForKey:@"sHearAbout"];
        if(strHearAbout.length !=0)
            [self initAboutUs:strHearAbout];
        
        NSString *strContactType = [dict valueForKey:@"sContactType"];
        if(strContactType.length !=0)
            [self initPrefferedContactType:strContactType];
        
        NSString *strState = [dict valueForKey:@"sState"];
        if( ![self isNotNull:strState] && strState.length>0)
            txtState.text = strState;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element {
    
    DLog(@"%@",selectedIndex);
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"Address"]||[textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // dismiss the keyboard
    
    [super touchesBegan:touches withEvent:event];
}
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


-(IBAction)btnNextPressed:(id)sender
{
    @try {
        [self.view endEditing:true];
        NSString *preferenceTypeTxt = strAboutUsSelected;
        
        /* if(txtFirstName.text.length==0){
         [self.view makeToast:@"Please enter first name" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtEmail.text.length>0)
         {
         if (![ValidationViewController validateEmail:txtEmail.text])
         {
         [self.view makeToast:@"Please enter valid email address" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         }
         
         if (strCustTypeSelected.length==0)
         {
         [self.view makeToast:@"Please select cutomer type" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if (strAboutUsSelected.length==0)
         {
         [self.view makeToast:@"Please select how did you hear about us?" duration:2 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtFirstName.text.length==0){
         [self.view makeToast:@"Please enter first name" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtLastName.text.length==0){
         [self.view makeToast:@"Please enter last name" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtAddress.text.length==0){
         [self.view makeToast:@"Please enter address" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtCity.text.length==0){
         [self.view makeToast:@"Please enter city" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         
         else if(txtState.text.length==0){
         [self.view makeToast:@"Please enter state" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         
         else if(txtCityCode.text.length==0){
         [self.view makeToast:@"Please enter zip" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         else if(txtMobile.text.length==0){
         [self.view makeToast:@"Please enter mobile" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         
         else if(txtEmail.text.length>0)
         {
         if (![ValidationViewController validateEmail:txtEmail.text])
         {
         [self.view makeToast:@"Please enter valid email address" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }
         }
         else if (strPreferredSelected.length==0)
         {
         [self.view makeToast:@"Please select preferred contact type" duration:1 position:CSToastPositionBottom title:nil];
         return;
         }*/
        
        
        if( txtFirstName.text.length != 0)
            [objUser.dictUsersData setValue:txtFirstName.text forKey:@"sFirstName"];
        if( txtLastName.text.length != 0)
            [objUser.dictUsersData setObject:txtLastName.text forKey:@"sLastName"];
        if( txtAddress.text.length != 0)
            [objUser.dictUsersData setObject:txtAddress.text forKey:@"sAddress"];
        if( txtCity.text.length != 0)
            [objUser.dictUsersData setObject:txtCity.text forKey:@"sCity"];
        if( txtCityCode.text.length != 0)
            [objUser.dictUsersData setObject:txtCityCode.text forKey:@"sZip"];
        if( txtMobile.text.length != 0)
            [objUser.dictUsersData setObject:txtMobile.text forKey:@"nMobile"];
        if( txtHome.text.length != 0)
            [objUser.dictUsersData setObject:txtHome.text forKey:@"sHome"];
        if( txtWork.text.length != 0)
            [objUser.dictUsersData setObject:txtWork.text forKey:@"sWork"];
        if( txtEmail.text.length != 0)
            [objUser.dictUsersData setObject:txtEmail.text forKey:@"sEmail"];
        
        else if(strAboutUsSelected.length !=0)
            [objUser.dictUsersData setObject:strAboutUsSelected forKey:@"PreferContType"];
        
        else if(strCustTypeSelected.length !=0)
            [objUser.dictUsersData setObject:strCustTypeSelected forKey:@"sCustomerType"];
        
        else if(strAppointmentTypeSelected.length !=0)
            [objUser.dictUsersData setObject:strAppointmentTypeSelected forKeyedSubscript:@"sAppointment"];
        
        else if(strAboutUsSelected.length !=0)
            [objUser.dictUsersData setObject:strAboutUsSelected forKey:@"sHearAbout"];
        
        else if(strPreferredSelected.length !=0)
            [objUser.dictUsersData setObject:strPreferredSelected forKey:@"sContactType"];
        
        
        if( txtState.text.length != 0)
            [objUser.dictUsersData setObject:txtState.text forKey:@"sState"];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsAddClient"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if(strCustTypeSelected.length !=0)
            
            [objUser.dictUsersData setObject:strCustTypeSelected forKey:@"sCustomerType"];
        
        if(strAppointmentTypeSelected.length !=0)
            
            [objUser.dictUsersData setObject:strAppointmentTypeSelected forKeyedSubscript:@"sAppointment"];
        
        if(strAboutUsSelected.length !=0)
            [dict setObject:strAboutUsSelected forKey:@"sHearAbout"];
        
        if(strPreferredSelected.length !=0)
            [objUser.dictUsersData setObject:strPreferredSelected forKey:@"sContactType"];
        
        if( txtState.text.length != 0)
            [objUser.dictUsersData setObject:txtState.text forKey:@"sState"];
        
        if( txtFirstName.text.length != 0)
            [dict setValue:txtFirstName.text forKey:@"sFirstName"];
        
        if( txtLastName.text.length != 0)
            [dict setObject:txtLastName.text forKey:@"sLastName"];
        
        if( txtAddress.text.length != 0)
            [dict setObject:txtAddress.text forKey:@"sAddress"];
        
        if( txtCity.text.length != 0)
            [dict setObject:txtCity.text forKey:@"sCity"];
        
        if( txtCityCode.text.length != 0)
            [dict setObject:txtCityCode.text forKey:@"sZip"];
        
        if( txtMobile.text.length != 0)
            [dict setObject:txtMobile.text forKey:@"nMobile"];
        
        if( txtHome.text.length != 0)
            [dict setObject:txtHome.text forKey:@"sHome"];
        
        if( txtWork.text.length != 0)
            [dict setObject:txtWork.text forKey:@"sWork"];
        
        if( txtEmail.text.length != 0)
            [dict setObject:txtEmail.text forKey:@"sEmail"];
        
        if(preferenceTypeTxt.length !=0)
            [dict setObject:preferenceTypeTxt forKey:@"PreferContType"];
        
        if(strCustTypeSelected.length !=0)
            
            [dict setObject:strCustTypeSelected forKey:@"sCustomerType"];
        
        if(strAppointmentTypeSelected.length !=0)
            
            [dict setObject:strAppointmentTypeSelected forKeyedSubscript:@"sAppointment"];
        
        if(strAboutUsSelected.length !=0)
            [dict setObject:strAboutUsSelected forKey:@"sHearAbout"];
        
        if(strPreferredSelected.length !=0)
            [dict setObject:strPreferredSelected forKey:@"sContactType"];
        
        if( txtState.text.length != 0)
            [dict setObject:txtState.text forKey:@"sState"];
        [dict setObject:sStartTime forKey:@"sStartTime"];
        
        
        AddClientSectionTwoViewController *second=(AddClientSectionTwoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionTwoViewController"];
        second.dataDictionary = [[NSMutableDictionary alloc] init];
        second.dataDictionary = dict;
        [self.navigationController pushViewController:second animated:YES];
    }
    @catch (NSException *exception) {
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
    else if ([object isKindOfClass: [NSString class]]) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"nil"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}

- (IBAction)btnSelectStatePressed:(id)sender {
    @try{
    [self.view endEditing:YES];
    
        @try{
            [[IQKeyboardManager sharedManager] setEnable:FALSE];
            activeField = txtState;
            if(IS_IPAD )
            {
                scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, 1400);
             //    scrollView.contentOffset = CGPointMake(0,400);
            }
            else if (IS_IPHONE_6 || IS_IPHONE_6P)
            {
                    scrollView.contentOffset = CGPointMake(0,200);
                scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, 1000);
            }
            else
            {
                scrollView.contentSize=CGSizeMake(self.view.frame.size.width, 700);
                scrollView.contentOffset = CGPointMake(0,300);
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
        }
        @finally {
        }
        ActionSheetCustomPicker *picker = [[ActionSheetCustomPicker alloc] initWithTitle:@"Select State" delegate:self showCancelButton:NO origin:sender initialSelections:@[@(0)]];
        [picker showActionSheetPicker];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

- (IBAction)btnAppointmentTypeTapped:(id)sender {
    @try{
        NSInteger btnTagValue =  [sender tag];
        switch (btnTagValue) {
            case 301:{
                strAppointmentTypeSelected=@"NotAppointment";
                btnNotAppointment.selected=true;
                btnSelfgenerated.selected=false;
                btnAppointmentInternet.selected=false;
                
            }
                break;
            case 302:{
                strAppointmentTypeSelected=@"Internet";
                btnNotAppointment.selected=false;
                btnSelfgenerated.selected=false;
                btnAppointmentInternet.selected=true;
                
            }
                break;
            case 303:{
                strAppointmentTypeSelected=@"Selfgenerated";
                btnNotAppointment.selected=false;
                btnSelfgenerated.selected=true;
                btnAppointmentInternet.selected=false;
                
            }
                break;
                
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
- (void)initAppointmentType :(NSString*) strAppointmentType {
    if([strAppointmentType isEqualToString:@"NotAppointment"]){
        strAppointmentTypeSelected=@"NotAppointment";
        btnNotAppointment.selected=true;
        btnSelfgenerated.selected=false;
        btnAppointmentInternet.selected=false;
        
    }
    if([strAppointmentType isEqualToString:@"Internet"])
    {
        strAppointmentTypeSelected=@"Internet";
        btnNotAppointment.selected=false;
        btnSelfgenerated.selected=false;
        btnAppointmentInternet.selected=true;
        
    }
    if([strAppointmentType isEqualToString:@"Selfgenerated"])
    {
        strAppointmentTypeSelected=@"Selfgenerated";
        btnNotAppointment.selected=false;
        btnSelfgenerated.selected=true;
        btnAppointmentInternet.selected=false;
        
    }
}

- (IBAction)btnCustomerTypePressed:(id)sender {
    NSInteger btnTagValue =  [sender tag];
    switch (btnTagValue) {
        case 201:{
            strCustTypeSelected=@"FirstTimeCustomer";
            btnFirstTimeCustomer.selected=true;
            btnBeBack.selected=false;
            
            
        }
            break;
        case 202:{
            strCustTypeSelected=@"BeBack";
            btnBeBack.selected=true;
            btnFirstTimeCustomer.selected=false;
            
        }
            break;
            
        default:
            break;
    }
}

-(void)initCustType: (NSString*)strCustType{
    if([strCustType isEqualToString:@"FirstTimeCustomer"])
    {
        strCustTypeSelected=@"FirstTimeCustomer";
        btnFirstTimeCustomer.selected=true;
        btnBeBack.selected=false;
    }else
    {
        strCustTypeSelected=@"BeBack";
        btnBeBack.selected=true;
        btnFirstTimeCustomer.selected=false;
    }
}


- (IBAction)btnAboutUsPressed:(id)sender {
    @try{
        NSInteger btnTagValue =  [sender tag];
        switch (btnTagValue) {
            case 205:{
                btnInternet.selected=true;
                btnWalkIn.selected=false;
                btnReferral.selected=false;
                btnMailer.selected=false;
                btnThirdPartyWebsite.selected=false;
                btnOther.selected=false;
                strAboutUsSelected=@"Internet";
            }
                break;
            case 206:{
                btnWalkIn.selected=true;
                btnInternet.selected=false;
                btnReferral.selected=false;
                btnMailer.selected=false;
                btnThirdPartyWebsite.selected=false;
                btnOther.selected=false;
                strAboutUsSelected=@"WalkIn";
            }
                break;
            case 207:{
                btnReferral.selected=true;
                btnWalkIn.selected=false;
                btnInternet.selected=false;
                btnMailer.selected=false;
                btnThirdPartyWebsite.selected=false;
                btnOther.selected=false;
                strAboutUsSelected=@"Referral";
            }
                break;
            case 208:{
                btnMailer.selected=true;
                btnReferral.selected=false;
                btnWalkIn.selected=false;
                btnInternet.selected=false;
                btnThirdPartyWebsite.selected=false;
                btnOther.selected=false;
                strAboutUsSelected=@"Mailer";
            }
                break;
            case 209:{
                btnThirdPartyWebsite.selected=true;
                btnMailer.selected=false;
                btnReferral.selected=false;
                btnWalkIn.selected=false;
                btnInternet.selected=false;
                btnOther.selected=false;
                strAboutUsSelected=@"ThirdPartyWebsite";
            }
                break;
            case 210:{
                btnOther.selected=true;
                btnThirdPartyWebsite.selected=false;
                btnMailer.selected=false;
                btnReferral.selected=false;
                btnWalkIn.selected=false;
                btnInternet.selected=false;
                strAboutUsSelected=@"Other";
            }
                break;
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
-(void)initAboutUs: (NSString*)strAboutUs
{
    @try{
        if([strAboutUs isEqualToString:@"Internet"]){
            btnInternet.selected=true;
            btnWalkIn.selected=false;
            btnReferral.selected=false;
            btnMailer.selected=false;
            btnThirdPartyWebsite.selected=false;
            btnOther.selected=false;
            strAboutUsSelected=@"Internet";
        }
        if([strAboutUs isEqualToString:@"WalkIn"]){
            btnWalkIn.selected=true;
            btnInternet.selected=false;
            btnReferral.selected=false;
            btnMailer.selected=false;
            btnThirdPartyWebsite.selected=false;
            btnOther.selected=false;
            strAboutUsSelected=@"WalkIn";
        }
        if([strAboutUs isEqualToString:@"Referral"]){
            btnReferral.selected=true;
            btnWalkIn.selected=false;
            btnInternet.selected=false;
            btnMailer.selected=false;
            btnThirdPartyWebsite.selected=false;
            btnOther.selected=false;
            strAboutUsSelected=@"Referral";
        }
        if([strAboutUs isEqualToString:@"Mailer"]){
            btnMailer.selected=true;
            btnReferral.selected=false;
            btnWalkIn.selected=false;
            btnInternet.selected=false;
            btnThirdPartyWebsite.selected=false;
            btnOther.selected=false;
            strAboutUsSelected=@"Mailer";
        }
        if([strAboutUs isEqualToString:@"ThirdPartyWebsite"]){
            btnThirdPartyWebsite.selected=true;
            btnMailer.selected=false;
            btnReferral.selected=false;
            btnWalkIn.selected=false;
            btnInternet.selected=false;
            btnOther.selected=false;
            strAboutUsSelected=@"ThirdPartyWebsite";
        }
        if([strAboutUs isEqualToString:@"Other"]){
            btnOther.selected=true;
            btnThirdPartyWebsite.selected=false;
            btnMailer.selected=false;
            btnReferral.selected=false;
            btnWalkIn.selected=false;
            btnInternet.selected=false;
            strAboutUsSelected=@"Other";
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

- (IBAction)btnPrefferedContactTypePressed:(id)sender {
    NSInteger btnTagValue =  [sender tag];
    switch (btnTagValue) {
        case 211:{
            strPreferredSelected=@"Phone";
            btnPhone.selected=true;
            btnEmail.selected=false;
            btnText.selected=false;
        }
            break;
        case 212:{
            strPreferredSelected=@"Email";
            btnEmail.selected=true;
            btnPhone.selected=false;
            btnText.selected=false;
        }
            break;
        case 213:{
            strPreferredSelected=@"Text";
            btnText.selected=true;
            btnEmail.selected=false;
            btnPhone.selected=false;
        }
            break;
        default:
            break;
    }
}

-(void)initPrefferedContactType : (NSString*)strPrefferContactType
{
    @try{
        if([strPrefferContactType isEqualToString:@"Phone"]){
            strPreferredSelected=@"Phone";
            btnPhone.selected=true;
            btnEmail.selected=false;
            btnText.selected=false;
        }
        if([strPrefferContactType isEqualToString:@"Email"]){
            strPreferredSelected=@"Email";
            btnEmail.selected=true;
            btnPhone.selected=false;
            btnText.selected=false;
        }
        if([strPrefferContactType isEqualToString:@"Text"]){
            strPreferredSelected=@"Text";
            btnText.selected=true;
            btnEmail.selected=false;
            btnPhone.selected=false;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


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
    @try{
        [[IQKeyboardManager sharedManager] setEnable:FALSE];
        activeField = textField;
        if(IS_IPAD )
            scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, 1400);
        else if (IS_IPHONE_6 || IS_IPHONE_6P)
            scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, 1000);
        else
            scrollView.contentSize=CGSizeMake(self.view.frame.size.width, 700);
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}
//------------------------------------------------------------------------------



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try{
        [scrollView setContentOffset:CGPointMake(0.0f, 0)];
        
        scrollView.contentSize= CGSizeMake(self.view.frame.size.width-10, 717);
        if (IS_IPAD ) {
            scrollView.contentSize= CGSizeMake(self.view.frame.size.width-10, 1400);
        }
        else if (IS_IPHONE_6 || IS_IPHONE_6P)
            scrollView.contentSize=CGSizeMake(self.view.frame.size.width-10, 1000);
        
        
        [UIView animateWithDuration:0 animations:^{
            [[IQKeyboardManager sharedManager] setEnable:YES];
            
        }];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
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
            CGPoint scrollPoint = CGPointMake(0.0f, activeField.frame.origin.y-kbSize.height);
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



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrSelectStatelDropDown count];
}


- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    @try{
        NSInteger index1 = [(UIPickerView *)actionSheetPicker.pickerView selectedRowInComponent:0];
        
        txtState.text=arrSelectStatelDropDown[index1];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    // [btnFirstSelectModel setTitle:arrSelectStatelDropDown[index1] forState:UIControlStateNormal];
    
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *itemLabel = (id)view;
    if (itemLabel == nil) {
        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f,([pickerView rowSizeForComponent:component].width), [pickerView rowSizeForComponent:component].height)];
        itemLabel.textAlignment = NSTextAlignmentCenter;
        
        itemLabel.text =  [arrSelectStatelDropDown objectAtIndex:row];
    }
    return itemLabel;
}



@end
