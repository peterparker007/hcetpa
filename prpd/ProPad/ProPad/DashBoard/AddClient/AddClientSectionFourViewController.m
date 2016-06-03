//
//  AddClientSectionFourViewController.m
//  ProPad Step-4
//
//  Created by dhara on 7/28/15.
//  Copyright (c) 2015 com.zaptech. All rights reserved.
//

#import "AddClientSectionFourViewController.h"
#import "NIDropDown.h"
#import "ApplicationData.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "FMDBDataAccess.h"
#import "UIView+Toast.h"
#import "CustomerListViewController.h"
#import "Base64.h"
@interface AddClientSectionFourViewController ()<UITextFieldDelegate>
{
    NIDropDown *dropDown;
    
    NSString *strFirstVehicleOfInterest;
    NSString *strSecondVehicleOfInterest;
    
    BOOL isCustomerAddedSuccess;
    
    NSArray *arrSelectModelDropDown;
    NSArray *arrSelectStockNumber;
    NSString *strImageData;
    NSDateFormatter *dateFormatter;
    NSString *sEndTime;
}

@end

@implementation AddClientSectionFourViewController
@synthesize dataDictionary;
@synthesize btnFirstNewVehicle,txtFirstSelectMake,txtSecondYear,btnFirstUsedVehicle,txtFirstStockNumber,btnSecondNewVehicle,txtSecondSelectMake,txtSecondSelectModel,txtSecondStockNumber,btnSecondUsedVehicle,txtFirstYear,txtFirstSelectModel,lblVehicleOfInterest,lbltime;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        [self startTimedTask];
        [self companyServiceForIsPay];
        dateFormatter=[[NSDateFormatter alloc] init];
        txtFirstStockNumber.delegate=self;
        txtFirstYear.delegate=self;
        txtFirstSelectMake.delegate=self;
        txtFirstSelectModel.delegate=self;
        
        txtSecondStockNumber.delegate=self;
        txtSecondYear.delegate=self;
        txtSecondSelectMake.delegate=self;
        txtSecondSelectModel.delegate=self;
        
        txtFirstStockNumber.tag=0;
        txtFirstYear.tag=1;
        txtFirstSelectMake.tag=2;
        txtFirstSelectModel.tag=3;
        
        txtSecondStockNumber.tag=4;
        txtSecondYear.tag=5;
        txtSecondSelectMake.tag=6;
        txtSecondSelectModel.tag=7;
        
        
        if(IS_IPAD){
            heightConst.constant=1000;
            btnFirstNewVehicle.titleLabel.font = [UIFont systemFontOfSize:16];txtFirstSelectMake.font = [UIFont systemFontOfSize:16];
            txtSecondYear.font = [UIFont systemFontOfSize:16];
            btnFirstUsedVehicle.titleLabel.font = [UIFont systemFontOfSize:16];
            txtFirstStockNumber.font = [UIFont systemFontOfSize:16];
            btnSecondNewVehicle.titleLabel.font = [UIFont systemFontOfSize:16];
            txtSecondSelectMake.font = [UIFont systemFontOfSize:16];
            txtSecondSelectModel.font = [UIFont systemFontOfSize:16];
            txtSecondStockNumber.font = [UIFont systemFontOfSize:16];
            btnSecondUsedVehicle.titleLabel.font = [UIFont systemFontOfSize:16];
            txtFirstYear.font = [UIFont systemFontOfSize:16];
            txtFirstSelectModel.font = [UIFont systemFontOfSize:16];
            lblVehicleOfInterest.font = [UIFont systemFontOfSize:16];
        }
        arrSelectModelDropDown = [NSArray arrayWithObjects:@"Chrysler" ,@"Chalmers",@"Chalmers-Detroit",@"DeSoto",@"Dodge",@"SRT",@"Eagle",@"Fargo",@"Imperial",@"Jeep",@"Maxwell",@"Plymouth",@"Ram",@"Valiant",@"Ford",@"Continental",@"Edsel",@"Lincoln",@"Mercury",@"General Motors",@"Buick",@"Marquette",@"Cadillac ",@"LaSalle",@"Cartercar",@"Chevrolet",@"Geo",@"Elmore",@"Ewing",@"GMC ",@"Hummer",@"Oakland",@"Pontiac",@"Oldsmobile",@"Viking",@"Rainier",@"Saturn",@"Scripps Booth",@"Sheridan",@"Welch",@"Welch-Detroit",@"AC Propulsion",@"AM General",@"Mobility Ventures",@"Anteros",@"Aurica",@"Avanti",@"Berrien Buggy",@"Blast",@"BXR",@"Callaway",@"Commuter",@"DeLorean",@"Detroit Electric",@"Dragon",@"E-Z-GO",@"Falcon Motorsports",@"Fisker",@"Formula1 Street",@"Googly",@"Hennessey",@"Ida",@"Lucra",@"Lyons",@"Mosler",@"Niama-Reisser" ,@"Next Autoworks",@"Panoz",@"Polaris",@"RDC",@"Rossion", @"Rezvani",@"Shelby American",@"SSC",@"Studebaker",@"Tanom",@"Tesla",@"Vector",@"Zimmer",nil];
        
        arrSelectStockNumber = [NSArray arrayWithObjects:@"2334", @"4512",@"4527", @"8562",@"4745",nil];
        strFirstVehicleOfInterest=@"FirstNewVehicle";
        strSecondVehicleOfInterest=@"SecondNewVehicle";
        
        isCustomerAddedSuccess=false;
        self.navigationItem.title  = @"New Customer";
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem alloc] initWithTitle:@""
//                                     style:UIBarButtonItemStylePlain
//                                    target:nil action:nil];
    //self.navigationItem.title = @"Appointment Reminder";
//    [self.navigationItem.backBarButtonItem setTitle:@""];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
   // [self setnavigationImage:@"toppurpleheader"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appdel.isNext=YES;
    
    
    self.navigationItem.title=@"";
}
-(void)viewDidAppear:(BOOL)animated
{
    @try{
        [super viewWillAppear:NO];
       
//        self.navigationController.navigationBar.backItem.title =@"";
//       //  self.navigationController.navigationBar.topItem.title = @"The Title";
//        self.navigationItem.title=@"";
//        [self.navigationController.navigationItem.backBarButtonItem setTitle:@""];
      //  self.navigationItem.leftBarButtonItem.title = @"";
        self.title  = @"New Customer";
        
        objUser = [UsersData sharedManager];
        NSDictionary *dictFourthUserData = [[NSDictionary alloc] init];
        dictFourthUserData = objUser.dictUsersData;
        
        if(dictFourthUserData.count>0)
            [dataDictionary addEntriesFromDictionary:dictFourthUserData];
        
        NSString *strFirstSelectMake = [dictFourthUserData valueForKey:@"sFirstMake"];
        if( ![self isNotNull:strFirstSelectMake] && strFirstSelectMake.length>0)
            txtFirstSelectMake.text = strFirstSelectMake;
        
        NSString *strFirstSelectModel = [dictFourthUserData valueForKey:@"sFirstModel"];
        if( ![self isNotNull:strFirstSelectModel] && strFirstSelectModel.length>0)
            txtFirstSelectModel.text = strFirstSelectModel;
        
        NSString *strFirstStockNumber = [dictFourthUserData valueForKey:@"sFirstModel"];
        if( ![self isNotNull:strFirstStockNumber] && strFirstStockNumber.length>0)
            txtFirstStockNumber.text = strFirstStockNumber;
        
        NSString *strFirstYear = [dictFourthUserData valueForKey:@"sFirstYear"];
        if( ![self isNotNull:strFirstYear] && strFirstYear.length>0)
            txtFirstYear.text = strFirstYear;
        
        NSString *strSecondSelectMake = [dictFourthUserData valueForKey:@"sSecondMake"];
        if( ![self isNotNull:strSecondSelectMake] && strSecondSelectMake.length>0)
            txtSecondSelectMake.text = strSecondSelectMake;
        
        
        NSString *strSecondSelectModel = [dictFourthUserData valueForKey:@"sSecondModel"];
        if( ![self isNotNull:strSecondSelectModel] && strSecondSelectModel.length>0)
            txtSecondSelectModel.text = strSecondSelectModel;
        
        
        NSString *strSecondStockNumber = [dictFourthUserData valueForKey:@"sSecondStockNumber"];
        if( ![self isNotNull:strSecondStockNumber] && strSecondStockNumber.length>0)
            txtSecondStockNumber.text = strSecondStockNumber;
        
        NSString *strSecondYear = [dictFourthUserData valueForKey:@"sSecondYear"];
        if( ![self isNotNull:strSecondYear] && strSecondYear.length>0)
            txtSecondYear.text = strSecondYear;
        
        NSString *strFirstVehType = [dictFourthUserData valueForKey:@"sFirstVehType"];
        if(strFirstVehType.length !=0)
            [self initVehicleOfInterest:strFirstVehType];
        
        NSString *strSecondVehType = [dictFourthUserData valueForKey:@"sSecondVehType"];
        if(strSecondVehType.length !=0)
            [self initVehicleOfInterest:strSecondVehType];
        
        AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
        //appdel.isBack=NO;
        
        NSLog(@"%@",appdel.dataDictionary);
       
        
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
             
//             LoginViewController *log=(LoginViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//             [self.navigationController pushViewController:log animated:YES];
             
             
             
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
           
            lbltime.text=[dateFormatter stringFromDate:[NSDate date]];
        });
    });
}
- (IBAction)btnVehicleOfInterestPressed:(id)sender {
    @try{
        NSInteger btnTagValue =  [sender tag];
        switch (btnTagValue) {
            case 201:{
                strFirstVehicleOfInterest=@"FirstNewVehicle";
                btnFirstNewVehicle.selected=true;
                btnFirstUsedVehicle.selected=false;
                [objUser.dictUsersData setObject:strFirstVehicleOfInterest forKey:@"sFirstVehType"];
                
            }
                break;
            case 202:{
                strFirstVehicleOfInterest=@"FirstUsedVehicle";
                btnFirstUsedVehicle.selected=true;
                btnFirstNewVehicle.selected=false;
                [objUser.dictUsersData setObject:strFirstVehicleOfInterest forKey:@"sFirstVehType"];
                
            }
                break;
            case 203:{
                strSecondVehicleOfInterest=@"SecondNewVehicle";
                btnSecondNewVehicle.selected=true;
                btnSecondUsedVehicle.selected=false;
                [objUser.dictUsersData setObject:strSecondVehicleOfInterest forKey:@"sSecondVehType"];
                
            }
                break;
            case 204:{
                strSecondVehicleOfInterest=@"SecondUsedVehicle";
                btnSecondUsedVehicle.selected=true;
                btnSecondNewVehicle.selected=false;
                [objUser.dictUsersData setObject:strSecondVehicleOfInterest forKey:@"sSecondVehType"];
                
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
- (void)initVehicleOfInterest: (NSString*)strVehicleOfInterest {
    @try{
        if([strVehicleOfInterest isEqualToString:@"FirstNewVehicle"]){
            strFirstVehicleOfInterest=@"FirstNewVehicle";
            btnFirstNewVehicle.selected=true;
            btnFirstUsedVehicle.selected=false;
        }
        if([strVehicleOfInterest isEqualToString:@"FirstUsedVehicle"]){
            
            strFirstVehicleOfInterest=@"FirstUsedVehicle";
            btnFirstUsedVehicle.selected=true;
            btnFirstNewVehicle.selected=false;
        }
        if([strVehicleOfInterest isEqualToString:@"SecondNewVehicle"]){
            
            strSecondVehicleOfInterest=@"SecondNewVehicle";
            btnSecondNewVehicle.selected=true;
            btnSecondUsedVehicle.selected=false;
        }
        if([strVehicleOfInterest isEqualToString:@"SecondUsedVehicle"]){
            
            strSecondVehicleOfInterest=@"SecondUsedVehicle";
            btnSecondUsedVehicle.selected=true;
            btnSecondNewVehicle.selected=false;
        }
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

#pragma mark ***********************Timer Picker*****************

-(void)timeWasCancelled:(NSDate *)selectedTime element:(id)element{
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element
{
    //    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //    [dateformatter setDateFormat:@"dd-MM-yyyy"];
    //    NSString *dateString=[dateformatter stringFromDate:selectedTime];
    
}

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if(isCustomerAddedSuccess){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        CustomerListViewController *second=(CustomerListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
        
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}


- (IBAction)btnSubmitPressed:(id)sender {
    
    @try{
        [self.view endEditing:true];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        appDelegate.NewcustomerClick=true;
        /* if(!((btnFirstNewVehicle.selected || btnFirstUsedVehicle.selected) || (btnSecondNewVehicle.selected || btnSecondUsedVehicle.selected))) {
         [self.view makeToast:@"Please select vehchicle of interest"];
         return;
         }*/
    
        NSMutableDictionary *localDict =  [[NSMutableDictionary alloc] init];
        if(objUser.dictUsersData.count>0)
            [localDict addEntriesFromDictionary:objUser.dictUsersData];
        if(dataDictionary.count>0)
            [localDict addEntriesFromDictionary:dataDictionary];
        
        NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
        [dataDictionary setObject:[NSString stringWithFormat:@"%@",strUserId]  forKey:@"nUserId"];
        [dataDictionary setObject:[NSString stringWithFormat:@"%ld",random()%500] forKey:@"nClientId"];
        
        strImageData = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"sImage"]];
        
        [localDict setObject:strFirstVehicleOfInterest forKey:@"sFirstVehType"];
        if (!localDict[@"sCorrectAns"])
            [localDict addEntriesFromDictionary:appDelegate.dataDictionary ];
               
        
        [localDict setObject:strSecondVehicleOfInterest forKey:@"sSecondVehType"];
        
        id strFisrtMake = txtFirstSelectMake.text;
        if(![strFisrtMake isEqualToString:@"Select Make"] && strFisrtMake!=nil)
            [localDict setObject:strFisrtMake forKey:@"sFirstMake"];
        
        id strFisrtModel = txtFirstSelectModel.text;
        if(![strFisrtModel isEqualToString:@"Select Model"] && strFisrtModel!=nil)
            [localDict setObject:strFisrtModel forKey:@"sFirstModel"];
        
        id strFisrtStockNumber = txtFirstStockNumber.text;
        if(![strFisrtStockNumber isEqualToString:@"Stock Number"] && strFisrtStockNumber!=nil)
            [localDict setObject:strFisrtStockNumber forKey:@"sFirstStockNumber"];
        
        id strFisrtYear = txtFirstYear.text;
        if(![strFisrtYear isEqualToString:@"Year"] && strFisrtYear!=nil)
            [localDict setObject:strFisrtYear forKey:@"sFirstYear"];
        
        id strSecondMake = txtSecondSelectMake.text;
        if(![strSecondMake isEqualToString:@"Select Make"] && strSecondMake!=nil)
            [localDict setObject:strSecondMake forKey:@"sSecondMake"];
        
        id strSecondModel = txtSecondSelectModel.text;
        if(![strSecondModel isEqualToString:@"Select Model"] && strSecondModel!=nil)
            [localDict setObject:strSecondModel forKey:@"sSecondModel"];
        
        id strSecondStockNumber = txtSecondStockNumber.text;
        if(![strSecondStockNumber isEqualToString:@"Stock Number"] && strSecondStockNumber!=nil)
            [localDict setObject:strSecondStockNumber forKey:@"sSecondStockNumber"];
        
        id strSecondYear = txtSecondYear.text;
        if(![strSecondYear isEqualToString:@"Year"] && strSecondYear!=nil)
            [localDict setObject:strSecondYear forKey:@"sSecondYear"];
        [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss"];
        sEndTime =[dateFormatter stringFromDate:[NSDate date]];
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        [localDict setObject:sEndTime forKey:@"sEndTime"];
        [localDict setObject:[NSString stringWithFormat:@"%@",strUserId]  forKey:@"nUserId"];
        if([appDelegateTemp checkInternetConnection]==true)
        {
            [localDict setObject:@"add" forKey:@"mode"];
             [self companyServiceForIsPay];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
            
            NSDictionary *parameters=localDict;
            
            NSData *imageData = [dataDictionary valueForKey:@"sImage"];
            
            /* NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
             [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
             [request setHTTPShouldHandleCookies:NO];
             [request setTimeoutInterval:30];
             [request setHTTPMethod:@"POST"];
             NSString *boundary = @"0xKhTmLbOuNdArY";
             NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
             [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
             
             NSMutableData *body = [NSMutableData data];
             for(NSString *param in parameters) {
             
             
             
             [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             }
             
             NSString *FileParamConstant = @"sImage";
             
             if (imageData) {
             
             
             
             [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             [body appendData:imageData];
             
             
             
             [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
             
             
             
             }
             [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [request setHTTPBody:body];
             */
            
            
            
            
            
            NSString *FileParamConstant = @"sImage";
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            [request setHTTPShouldHandleCookies:NO];
            [request setTimeoutInterval:30];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"0xKhTmLbOuNdArY";
            // set Content-Type in HTTP header
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            // post body
            NSMutableData *body = [NSMutableData data];
            
            // add params (all params are strings)
            for(NSString *param in parameters) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            // add image data
            //NSData *imageData = UIImageJPEGRepresentation(imageToPost, 1.0);
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            [request setURL:[NSURL URLWithString:KAddClient]];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       
                                       [hud hide:YES];
                                       NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                       
                                       if ([httpResponse statusCode] == 200) {
                                           NSError *errorJson=nil;
                                           NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                                           
                                           DLog(@"responseDict=%@",responseDict);
                                           if([ [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"status"] ] isEqualToString:@"1" ])
                                           {
                                               
                                               
                                               isCustomerAddedSuccess=true;
                                               [self insertClientToLocalDatabase:true];
                                               [objUser.dictUsersData removeAllObjects];
                                               UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"AddCustomer" message:@"Customer added successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               alertSuccess.tag = 1;
                                               [alertSuccess show];
                                               [hud hide:YES];
                                           }
                                           
                                           else
                                           {
                                               [hud hide:YES];
                                               
                                               if(responseDict.count==0)
                                               {
                                                   UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Failed to add customer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   [alertSuccess show];
                                                   return;
                                                   
                                               }
                                               else{
                                                   UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"msg"]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   alertSuccess.tag = 1;
                                                   [hud hide:YES];
                                                   [alertSuccess show];
                                               }
                                               
                                               
                                           }
                                           DLog(@"success");
                                       }
                                       
                                   }];
            
        }
        else
        {
            isCustomerAddedSuccess=true;
            
            [self insertClientToLocalDatabase:false];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AddCustomer"                                                   message:@"Customer data has been successfully added."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil, nil];
            [alert show];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
     AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdel.isBack=NO;
   [appdel.dataDictionary removeAllObjects];
    [appdel.dataDictionary1 removeAllObjects];
    [appdel.checkBoxTag removeAllObjects];
   // appdel.isBack = NO;
   
}

-(void)insertClientToLocalDatabase:(BOOL)isClientOnline
{
    @try{
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM-dd-yyyy"];
        NSString *dateString=[NSString stringWithFormat:@"%@",[NSDate date]];
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        [dataDictionary setValue:dateString forKey:@"dDate"];
        
        NSString *jsonString = [dataDictionary valueForKey:@"vin_data"];
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableString *strVinModel = [NSMutableString string];
        NSMutableString *strVinYear = [NSMutableString string];
        NSMutableString *strMake = [NSMutableString string];
        NSMutableString *strMiles = [NSMutableString string];
        
        for (int i=0; i<parsedData.count; i++) {
            if ([strVinModel length]>0)
                [strVinModel appendString:@","];
            [strVinModel appendFormat:@"%@",[[parsedData objectAtIndex:i]  valueForKey:@"sVinModel"]];
            if ([strVinYear length]>0)
                [strVinYear appendString:@","];
            [strVinYear appendFormat:@"%@", [[parsedData objectAtIndex:i]  valueForKey:@"sVinYear"]];
            if ([strMake length]>0)
                [strMake appendString:@","];
            [strMake appendFormat:@"%@",[[parsedData objectAtIndex:i]  valueForKey:@"sMake"]];
            if ([strMiles length]>0)
                [strMiles appendString:@","];
            [strMiles appendFormat:@"%@",[[parsedData objectAtIndex:i]  valueForKey:@"sMiles"]];
        }
        
        [dataDictionary setObject:strVinYear forKey:@"sVinYear"];
        [dataDictionary setObject:strVinModel forKey:@"sVinModel"];
        [dataDictionary setObject:strMake forKey:@"sMake"];
        [dataDictionary setObject:strMiles forKey:@"sMiles"];
        if(isClientOnline)
            [dataDictionary setObject:[strImageData dataUsingEncoding:NSUTF8StringEncoding] forKey:@"sImage"];
        else{
            NSData *imageData = [dataDictionary valueForKey:@"sImage"];
            NSString* strImageData1 = [Base64 encode:imageData];
            [dataDictionary setObject:strImageData1 forKey:@"sImage"];
        }
        
        [dataDictionary setValue:[NSString stringWithFormat:@"%d",!isClientOnline] forKey:@"IsClientOnline"];
        [dataDictionary setValue:[NSString stringWithFormat:@"0"] forKey:@"nBackGrossAmount"];
        [dataDictionary setValue:[NSString stringWithFormat:@"0"] forKey:@"nFrontGrossAmount"];
        [dataDictionary setValue:[NSString stringWithFormat:@"0"] forKey:@"nTotalGrossAmount"];
        
        
        DLog(@"%@",dataDictionary);
        [dbAccess insertclientData:dataDictionary];
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
    heightConst.constant=1000;
}
//------------------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try{
        
        
        
        if(textField==txtFirstSelectMake){
            id strFisrtMake = txtFirstSelectMake.text;
            if(![strFisrtMake isEqualToString:@"Select Make"] && strFisrtMake!=nil)
                [objUser.dictUsersData setObject:strFisrtMake forKey:@"sFirstMake"];
        }
        if(textField==txtFirstSelectModel){
            id strFisrtModel = txtFirstSelectModel.text;
            if(![strFisrtModel isEqualToString:@"Select Model"] && strFisrtModel!=nil)
                [objUser.dictUsersData setObject:strFisrtModel forKey:@"sFirstModel"];
        }
        if(textField==txtFirstStockNumber){
            id strFisrtStockNumber = txtFirstStockNumber.text;
            if(![strFisrtStockNumber isEqualToString:@"Stock Number"] && strFisrtStockNumber!=nil)
                [objUser.dictUsersData setObject:strFisrtStockNumber forKey:@"sFirstStockNumber"];
        }
        
        if(textField==txtFirstYear){
            id strFisrtYear = txtFirstYear.text;
            if(![strFisrtYear isEqualToString:@"Year"] && strFisrtYear!=nil)
                [objUser.dictUsersData setObject:strFisrtYear forKey:@"sFirstYear"];
        }
        if(textField==txtSecondSelectMake){
            id strSecondMake = txtSecondSelectMake.text;
            if(![strSecondMake isEqualToString:@"Select Make"] && strSecondMake!=nil)
                [objUser.dictUsersData setObject:strSecondMake forKey:@"sSecondMake"];
        }
        
        if(textField==txtSecondSelectModel){
            id strSecondModel = txtSecondSelectModel.text;
            if(![strSecondModel isEqualToString:@"Select Model"] && strSecondModel!=nil)
                [objUser.dictUsersData setObject:strSecondModel forKey:@"sSecondModel"];
        }
        
        if(textField==txtSecondStockNumber){
            id strSecondStockNumber = txtSecondStockNumber.text;
            if(![strSecondStockNumber isEqualToString:@"Stock Number"] && strSecondStockNumber!=nil)
                [objUser.dictUsersData setObject:strSecondStockNumber forKey:@"sSecondStockNumber"];
        }
        if(textField==txtSecondYear){
            id strSecondYear = txtSecondYear.text;
            if(![strSecondYear isEqualToString:@"Year"] && strSecondYear!=nil)
                [objUser.dictUsersData setObject:strSecondYear forKey:@"sSecondYear"];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

@end
