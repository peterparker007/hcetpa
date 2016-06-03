//
//  AddClientSectionTwoViewController.m
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "AddClientSectionTwoViewController.h"
#import "AddClientSectionThreeViewController.h"
#import "ActionSheetStringPicker.h"
#import "FMDBDataAccess.h"
#import "UIView+Toast.h"
#import "ActionSheetPicker.h"
#import "UIImage+Helpers.h"
#import "PECropViewController.h"
#import "ApplicationData.h"
#import "AppConstant.h"
#import "IQKeyboardManager.h"

@interface AddClientSectionTwoViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate,ActionSheetCustomPickerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ZBarReaderDelegate,ZBarReaderViewDelegate>

{
    NSDictionary *dict;
    NSString *imageStringAfterCrop;
    UITextField *activeField;
    BOOL isLastItemEmpty;
    BOOL isBarScanPressed;
    BOOL isAddedAnotherVehicle;
    BOOL isOneVehicleAdded;
    BOOL isRecordAddedUsingAPI;
    BOOL isReloadTableView;
    BOOL isimagepick;
}

@property(nonatomic) float areaWidth;
@property(nonatomic) float areaXWidth;
@property(nonatomic) float areaYHeight;

@property(nonatomic, strong) CALayer *borderLayer;

@end

@implementation AddClientSectionTwoViewController

@synthesize dataDictionary;
@synthesize txtVINnumber,txtViewNotes;
@synthesize userImage,cell,scrollView,reader,aryNumberOfVehicle,tblViewCustCell,btnAddAnotherVehicle,aryTotalVehicles,aryNVin,dictVehicleDataResponse;
@synthesize lblCustomerCurrentVehicle,lblVIN;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        [self companyServiceForIsPay];
        txtViewNotes.text=@"Notes:";
        self.areaWidth = 3.0f;
        self.areaXWidth = 30.0f;
        self.areaYHeight = 30.0f;
        isLastItemEmpty=false;
        aryTotalVehicles = [[NSMutableArray alloc] init];
        aryNVin = [[NSMutableArray alloc] init];
        aryNumberOfVehicle = [[NSMutableArray alloc] init];
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        if(IS_IPAD){
            viewHeightDynamic.constant=1000;
            lblCustomerCurrentVehicle.font = [UIFont systemFontOfSize:20];
            lblVIN.font = [UIFont systemFontOfSize:18];
            txtVINnumber.font = [UIFont systemFontOfSize:16];
        }
        isReloadTableView=false;
        self.navigationItem.title = @"New Customer";
        dictVehicleDataResponse = [[NSMutableDictionary alloc] init];
        
        tblViewCustCell.delegate=self;
        [self registerForKeyboardNotifications];
        isBarScanPressed=false;
        isAddedAnotherVehicle=false;
        isimagepick=false;
        
        isRecordAddedUsingAPI=false;
        txtVINnumber.delegate=self;
        
        NSArray *ary;
        if(dataDictionary.count>0)
            ary = [dataDictionary valueForKey:@"VehicleDetail"];
        
        [aryNumberOfVehicle addObject:@"1"];
        for(int i=0;i<=100;i++)
            [aryTotalVehicles addObject:@"1"];
        
        if(ary.count>0){
            [aryNumberOfVehicle removeAllObjects];
            for (int i=0;i<ary.count; i++) {
                [aryNumberOfVehicle addObject:@"1"];
                [aryTotalVehicles replaceObjectAtIndex:aryNumberOfVehicle.count-1 withObject:[ary objectAtIndex:i]];
            }
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(btnSelectProfilePicturePressed:)];
        
        [self.userImage addGestureRecognizer:tap];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark Pickerview methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    
    
    [self.view endEditing:YES];
    
    
    NSMutableArray *aryVehicleDatas = [[NSMutableArray alloc] init];
    int totalvehicles = (int)aryNumberOfVehicle.count;
    for(int i=0; i<totalvehicles;i++)
    {
        if([[aryTotalVehicles objectAtIndex:i] isKindOfClass:[NSString class]])
            break;
        NSDictionary *allDict = [aryTotalVehicles objectAtIndex:i];
        NSMutableDictionary *dictVehicleDatas = [[NSMutableDictionary alloc] init];
        NSString *strVinYear = [allDict valueForKey:@"sVinYear"];
        NSString *strVinModel = [allDict valueForKey:@"sVinModel"];
        NSString *strMiles = [allDict valueForKey:@"sMiles"];
        NSString *strMake = [allDict valueForKey:@"sMake"];
        if(strVinYear.length!=0)
            [dictVehicleDatas setObject:strVinYear forKey:@"sVinYear"];
        if(strVinModel.length!=0)
            [dictVehicleDatas setObject:strVinModel forKey:@"sVinModel"];
        if(strMiles.length!=0)
            [dictVehicleDatas setObject:strMiles forKey:@"sMiles"];
        if(strMake.length!=0)
            [dictVehicleDatas setObject:strMake forKey:@"sMake"];
        [aryVehicleDatas addObject:dictVehicleDatas];
    }
    [objUser.dictUsersData setObject:aryVehicleDatas forKey:@"VehicleDetail"];
    [dataDictionary setObject:aryVehicleDatas forKey:@"VehicleDetail"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:aryVehicleDatas options:0 error:nil];
    NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    [dataDictionary setObject:jsonString forKey:@"vin_data"];
    
    NSString * result = [[aryNVin valueForKey:@"description"] componentsJoinedByString:@","];
    
    [dataDictionary setObject:result forKey:@"nVIN"];
    
    if ([txtViewNotes.text isEqualToString:@"Notes:"]) {
        txtViewNotes.text = @"";
    }
    [dataDictionary setObject:txtViewNotes.text forKey:@"sNote"];
    
    self.navigationItem.title=@"";
}
#pragma mark view life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    @try{
        
        self.navigationItem.title  = @"New Customer";
        NSString *strVINCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"VINCode"];
        if(strVINCode.length>10){
            txtVINnumber.text = strVINCode;
            [self btnSearchPressed:nil];
        }
        objUser = [UsersData sharedManager];
        dict = [[NSDictionary alloc] init];
        dict = objUser.dictUsersData;
        if(dict.count>0)
            [dataDictionary addEntriesFromDictionary:dict];
        if(![self isNotNull:[dict valueForKey:@"sImage"]]){
            NSData *imageData = [dict valueForKey:@"sImage"];
            userImage.image = [UIImage imageWithData:imageData];
        }
        
        NSString *strNote = [dict valueForKey:@"sNote"];
        if( ![self isNotNull:strNote] && strNote.length>0)
            txtViewNotes.text = strNote;
        
        NSArray *arr = [dict valueForKey:@"VehicleDetail"];
        for(int i=0;i<arr.count;i++){
            dict = [arr objectAtIndex:i];
         //  [aryTotalVehicles replaceObjectAtIndex:aryNumberOfVehicle.count-1 withObject:dict];
        }
        
        CGPoint scrollPoint = CGPointMake(0.0, 0);
        [scrollView setContentOffset:scrollPoint animated:NO];
        CGFloat height;
        if (IS_IPAD) {
            height = ([aryNumberOfVehicle count] *200);
            viewHeightDynamic.constant = height+1200;
        }
        else
        {
            height = ([aryNumberOfVehicle count] *200);
            viewHeightDynamic.constant = height+1000;
            
        }
        tableHeightConst.constant = height;
        
        if(!isimagepick)
        {
            if(!isBarScanPressed){
                [tblViewCustCell reloadData];
                
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
                                   initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];             [alert show];
             
         }
         
     }];
    
}
#pragma mark onbtn action
- (IBAction)btnSelectProfilePicturePressed:(id)sender {
    [self.view endEditing:YES];
    isimagepick=true;
    
    
    @try{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", @"Saved Album", nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (IBAction)btnSearchPressed:(id)sender {
    @try{
        [self.view endEditing:YES];
        if(txtVINnumber.text.length<17)
        {
            [self.view makeToast:@"The VIN is incorrect. It must be 17 characters"];
            return;
        }
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true)
        {
            [[ApplicationData sharedInstance] showLoader];
            
            NSString *postString = [NSString stringWithFormat:@"https://api.edmunds.com/v1/api/toolsrepository/vindecoder?vin=%@&fmt=json&api_key=%@",txtVINnumber.text,KEdmundsApiKey];
            
            HTTPManager *manager = [HTTPManager managerWithURL:postString];
            
            [manager setPostString:@""];
            manager.requestType = HTTPRequestTypeGeneral;
            [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
                NSString *strWarning = [bodyDict valueForKey:@"warning"];
                if(strWarning.length>0)
                {
                    txtVINnumber.text = @"";
                    NSArray* strCompleteWarnig = [strWarning componentsSeparatedByString: @"."];
                    if(strCompleteWarnig.count>0)
                    {
                        NSString* strActualWarnig = [strCompleteWarnig objectAtIndex: 0];
                        if ([strActualWarnig rangeOfString:@"."].location == NSNotFound) {
                            UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"VIN Warning" message:strActualWarnig delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertSuccess show];
                        }
                        else {
                            UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"VIN Warning" message:@"VIN check sum validation failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alertSuccess show];
                        }
                    }
                    else {
                        UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"VIN Warning" message:@"VIN check sum validation failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertSuccess show];
                    }
                    return;
                }
                else{
                    
                    NSMutableArray *aryVehicleDetails = [[NSMutableArray alloc] init];
                    aryVehicleDetails = [bodyDict valueForKey:@"styleHolder"];
                    if(aryVehicleDetails.count==0)
                    {
                        UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Invalid VIN" message:@"Vehicle identification number is not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertSuccess show];
                        return;
                    }
                    [aryNVin addObject:txtVINnumber.text];
                    isAddedAnotherVehicle=false;
                    txtVINnumber.text=@"";
                    isOneVehicleAdded=true;
                    isRecordAddedUsingAPI=true;
                    dictVehicleDataResponse = [[NSMutableDictionary alloc]init];
                    NSDictionary *dictVehicle = [aryVehicleDetails objectAtIndex:0];
                    
                    id objModel = [dictVehicle valueForKey:@"modelName"];
                    id objYear = [NSString stringWithFormat:@"%@",[dictVehicle valueForKey:@"year"]];
                    id objMake = [NSString stringWithFormat:@"%@",[dictVehicle valueForKey:@"makeName"]];
                    if(objModel != nil)
                        [dictVehicleDataResponse setObject:objModel forKey:@"sVinModel"];
                    if(objYear != nil)
                        [dictVehicleDataResponse setObject:objYear forKey:@"sVinYear"];
                    if(objMake != nil)
                        [dictVehicleDataResponse setObject:objMake forKey:@"sMake"];
                    
                    [dictVehicleDataResponse setObject:@"" forKey:@"sMiles"];
                    [aryTotalVehicles replaceObjectAtIndex:aryNumberOfVehicle.count-1 withObject:dictVehicleDataResponse];
                    [[ApplicationData sharedInstance] hideLoader];
                    [tblViewCustCell reloadData];
                }
                
            } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                //                [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
                
            } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            }];
        }
        else{
            [self.view endEditing:true];
            [self.view makeToast:@"Check your internet connection."];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (IBAction)btnVIMScannerPressed:(id)sender {
    @try{
        isBarScanPressed=true;
        
        // ADD: present a barcode reader that scans from the camera feed
        reader = [ZBarReaderViewController new];
        reader.readerDelegate = self;
        reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        [reader.view.layer addSublayer:self.borderLayer];
        
        [self.borderLayer setNeedsDisplay];
        
        ZBarImageScanner *scanner = reader.scanner;
        // TODO: (optional) additional reader configuration here
        
        // EXAMPLE: disable rarely used I2/5 to improve performance
        [scanner setSymbology: ZBAR_CODE39
                       config: ZBAR_CFG_ENABLE
                           to: 0];
        
        // present and release the controller
        [self presentViewController:reader animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


- (IBAction)btnAddAnotherVehiclePresssed:(id)sender {
    @try{
        [self.view endEditing:true];
        
//        AddClientSectionTwoTVC *localCell  = (AddClientSectionTwoTVC*)[[activeField superview] superview];
//
//        NSMutableDictionary *dictEditStorage = [[NSMutableDictionary alloc]init];
//        
//        [dictEditStorage setObject:localCell.txtModel.text forKey:@"sVinModel"];
//        [dictEditStorage setObject:localCell.txtYear.text forKey:@"sVinYear"];
//        [dictEditStorage setObject:localCell.txtMake.text forKey:@"sMake"];
//        [dictEditStorage setObject:localCell.txtVehicleMilaege.text forKey:@"sMiles"];
//        NSLog(@"localCell tag %ld",(long)(localCell.tag-29590));
//        [aryTotalVehicles replaceObjectAtIndex:localCell.tag-29590 withObject:dictEditStorage];
        
       // isLastItemEmpty=true;
        [self.view endEditing:true];
        CGPoint scrollPoint = CGPointMake(0.0, 0);
        [scrollView setContentOffset:scrollPoint animated:NO];
        /*  if(cell.txtYear.text.length==0){
         [self.view makeToast:@"Please enter vehicle Year"];
         return;
         }
         else if(cell.txtMake.text.length==0){
         [self.view makeToast:@"Please enter vehicle Make" duration:1 position:CSToastPositionCenter title:nil];
         return;
         }
         else if(cell.txtModel.text.length==0){
         [self.view makeToast:@"Please enter vehicle Model"];
         return;
         }
         else if(cell.txtVehicleMilaege.text.length==0)
         {
         [self.view makeToast:@"Please enter vehicle milaege" duration:1 position:CSToastPositionCenter title:nil];
         return;
         }*/
        
        txtVINnumber.text=@"";
        isOneVehicleAdded=true;
        
        isAddedAnotherVehicle=true;
       // isLastItemEmpty=true;
        [aryNumberOfVehicle addObject:@"1"];
        CGFloat height;
        if (IS_IPAD) {
            height = ([aryNumberOfVehicle count] *200);
            viewHeightDynamic.constant = height+1200;
        }
        else
        {
            height = ([aryNumberOfVehicle count] *200);
            viewHeightDynamic.constant = height+1000;
        }
        tableHeightConst.constant = height;
        isReloadTableView=true;
        [tblViewCustCell reloadData];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (IBAction)btnNextPressed:(id)sender {
    @try{
//        AddClientSectionTwoTVC *localCell  = (AddClientSectionTwoTVC*)[[activeField superview] superview];
//        
//        NSMutableDictionary *dictEditStorage = [[NSMutableDictionary alloc]init];
//        
//        [dictEditStorage setObject:localCell.txtModel.text forKey:@"sVinModel"];
//        [dictEditStorage setObject:localCell.txtYear.text forKey:@"sVinYear"];
//        [dictEditStorage setObject:localCell.txtMake.text forKey:@"sMake"];
//        [dictEditStorage setObject:localCell.txtVehicleMilaege.text forKey:@"sMiles"];
//        NSLog(@"localCell tag %ld",(long)(localCell.tag-29590));
//        [aryTotalVehicles replaceObjectAtIndex:localCell.tag-29590 withObject:dictEditStorage];
        
      //  isLastItemEmpty=true;
        
        /* if(!isOneVehicleAdded){
         if(cell.txtYear.text.length==0){
         [self.view makeToast:@"Year is empty field"];
         return;
         }
         else if(cell.txtMake.text.length==0){
         [self.view makeToast:@"Make is empty field" duration:1 position:CSToastPositionCenter title:nil];
         return;
         }
         else if(cell.txtModel.text.length==0){
         [self.view makeToast:@"Model is empty field"];
         return;
         }
         else if(cell.txtVehicleMilaege.text.length==0){
         [self.view makeToast:@"Please enter vehicle milaege" duration:1 position:CSToastPositionCenter title:nil];
         return;
         }
         */
        //        NSMutableArray *aryVehicleDatas = [[NSMutableArray alloc] init];
        //        int totalvehicles = (int)aryNumberOfVehicle.count;
        //        for(int i=0; i<totalvehicles;i++)
        //        {
        //            if([[aryTotalVehicles objectAtIndex:i] isKindOfClass:[NSString class]])
        //                break;
        //            NSDictionary *allDict = [aryTotalVehicles objectAtIndex:i];
        //            NSMutableDictionary *dictVehicleDatas = [[NSMutableDictionary alloc] init];
        //            NSString *strVinYear = [allDict valueForKey:@"sVinYear"];
        //            NSString *strVinModel = [allDict valueForKey:@"sVinModel"];
        //            NSString *strMiles = [allDict valueForKey:@"sMiles"];
        //            NSString *strMake = [allDict valueForKey:@"sMake"];
        //            if(strVinYear.length!=0)
        //                [dictVehicleDatas setObject:strVinYear forKey:@"sVinYear"];
        //            if(strVinModel.length!=0)
        //                [dictVehicleDatas setObject:strVinModel forKey:@"sVinModel"];
        //            if(strMiles.length!=0)
        //                [dictVehicleDatas setObject:strMiles forKey:@"sMiles"];
        //            if(strMake.length!=0)
        //                [dictVehicleDatas setObject:strMake forKey:@"sMake"];
        //            [aryVehicleDatas addObject:dictVehicleDatas];
        //        }
        //        [objUser.dictUsersData setObject:aryVehicleDatas forKey:@"VehicleDetail"];
        //        [dataDictionary setObject:aryVehicleDatas forKey:@"VehicleDetail"];
        //
        //        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:aryVehicleDatas options:0 error:nil];
        //        NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        //
        //        [dataDictionary setObject:jsonString forKey:@"vin_data"];
        //
        //        [dataDictionary setObject:txtVINnumber.text forKey:@"nVIN"];
        //
        //        if ([txtViewNotes.text isEqualToString:@"Notes:"]) {
        //            txtViewNotes.text = @"";
        //        }
        //        [dataDictionary setObject:txtViewNotes.text forKey:@"sNote"];
        
        [self.view endEditing:true];
        UsersData *dataCheak=[UsersData sharedManager];
        dataCheak.strCheak=@"NO";
        CGPoint scrollPoint = CGPointMake(0.0, 0);
        [scrollView setContentOffset:scrollPoint animated:NO];
        AddClientSectionThreeViewController *third=(AddClientSectionThreeViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionThreeViewController"];
        
        third.dataDictionary = [[NSMutableDictionary alloc] init];
        
        third.dataDictionary = dataDictionary;
        
        [self.navigationController pushViewController:third animated:NO];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


#pragma mark UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    @try{
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.navigationBar.tintColor = [UIColor whiteColor];
        if ([@"Camera" isEqualToString:title] && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            if(IS_IPAD)
            {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:controller animated:YES completion:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }
            else
            {
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.navigationController presentViewController:controller animated:YES completion:nil];
            }
        }
        else if ([@"Photo Library" isEqualToString:title])
        {
            
            if(IS_IPAD)
            {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:controller animated:YES completion:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }
            else
            {
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.navigationController presentViewController:controller animated:YES completion:nil];
            }
            
        } else if ([@"Saved Album" isEqualToString:title])
        {
            if(IS_IPAD)
            {
                controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:controller animated:YES completion:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:controller animated:YES completion:nil];
                });
            }
            else
            {
                controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self.navigationController presentViewController:controller animated:YES completion:nil];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSMutableDictionary *)info {
    
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(isBarScanPressed==true)
    {
        isBarScanPressed=false;
        // ADD: get the decode results
        id<NSFastEnumeration> results =
        [info objectForKey: ZBarReaderControllerResults];
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            // EXAMPLE: just grab the first barcode
            break;
        
        // EXAMPLE: do something useful with the barcode data
        txtVINnumber.text = symbol.data;
        
        // EXAMPLE: do something useful with the barcode image
        
        // ADD: dismiss the controller (NB dismiss from the *reader*!)
        [reader dismissViewControllerAnimated:YES completion:NULL];
        
        // ADD: dismiss the controller (NB dismiss from the *reader*!)
        [self btnSearchPressed:nil];
    }
#ifdef DEV_ENVIRONMENT
    DLog (@"Image Size, %f, %f", originalImage.size.width, originalImage.size.height
          );
#endif
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self openCropEditor:originalImage];
    }];
}

#pragma mark - photo cropper
-(void) openCropEditor:(UIImage *) image {
    @try{
        PECropViewController *controller = [[PECropViewController alloc] init];
        controller.delegate = self;
        controller.image = image;
        controller.cropAspectRatio = 1;
        //controller.navigationBar.tintColor = [UIColor whiteColor];
        controller.keepingCropAspectRatio = YES;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        navigationController.navigationBar.tintColor=[UIColor whiteColor];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [self presentViewController:navigationController animated:YES completion:NULL];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    @try{
        [controller dismissViewControllerAnimated:YES completion:NULL];
        userImage.image = nil;
        userImage.image=croppedImage;
        CGRect rect;
        rect.origin = CGPointZero;
        rect.size   = CGSizeMake(150, 150);
        UIGraphicsBeginImageContext(CGSizeMake(150, 150));
        [croppedImage drawInRect:rect];
        UIImage * itemImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(itemImg,0.5);
        [objUser.dictUsersData setObject:imageData forKey:@"sImage"];
        [dataDictionary setObject:imageData forKey:@"sImage"];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(void) cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try{
        if(textField ==txtVINnumber)
        {
            NSUInteger oldLength = [textField.text length];
            NSUInteger replacementLength = [string length];
            NSUInteger rangeLength = range.length;
            
            NSUInteger newLength = oldLength - rangeLength + replacementLength;
            
            BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
            
            return newLength <= 18 || returnKey;
        }
        return true;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    CGPoint scrollPoint = CGPointMake(0.0f, activeField.frame.origin.y-10);
    //    [scrollView setContentOffset:scrollPoint animated:YES];
    if ([textView.text isEqualToString:@"Address"]||[txtViewNotes.text isEqualToString:@"Notes:"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        [textView becomeFirstResponder];//optional
    }
    [textView becomeFirstResponder];
}

#pragma mark -  TABLE DELEGATE

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryNumberOfVehicle count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPAD)
        return 250;
    else
        return 200;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        static NSString *simpleTableIdentifier;
        if(IS_IPAD)
            simpleTableIdentifier= @"AddClientSectionTwoTVC";
        else
            simpleTableIdentifier = @"AddClientSectionTwoTVC_iPhone";
        cell = (AddClientSectionTwoTVC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil){
            NSArray *nib;
            if(IS_IPAD)
                nib = [[NSBundle mainBundle] loadNibNamed:@"AddClientSectionTwoTVC" owner:self options:nil];
            else
                nib = [[NSBundle mainBundle] loadNibNamed:@"AddClientSectionTwoTVC_iPhone" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
            
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [tblViewCustCell setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        cell.txtMake.delegate=self;
        cell.txtYear.delegate=self;
        cell.txtModel.delegate=self;
        txtVINnumber.delegate=self;
        cell.txtMake.placeholder=@"BMW";
        cell.txtModel.placeholder=@"i8";
        cell.tag=indexPath.row+29590;
        cell.txtVehicleMilaege.delegate=self;
        if(IS_IPAD){
            cell.lblMake.font = [UIFont systemFontOfSize:18];
            cell.lblYear.font = [UIFont systemFontOfSize:18];
            cell.lblModel.font = [UIFont systemFontOfSize:18];
            cell.txtMake.placeholder=@"BMW";
            cell.txtModel.placeholder=@"i8";
        }
        
        if(([[aryTotalVehicles objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) || ([[aryTotalVehicles objectAtIndex:indexPath.row] isKindOfClass:[NSMutableDictionary class]])){
            
            NSDictionary *dictDataVehicle = [aryTotalVehicles objectAtIndex:indexPath.row];
            cell.txtModel.text = [dictDataVehicle valueForKey:@"sVinModel"];
            cell.txtYear.text = [dictDataVehicle valueForKey:@"sVinYear"];
            cell.txtMake.text = [dictDataVehicle valueForKey:@"sMake"];
            cell.txtVehicleMilaege.text = [dictDataVehicle valueForKey:@"sMiles"];
        }
        else {
            if(aryNumberOfVehicle.count==indexPath.row+1 && isAddedAnotherVehicle==true) {
                cell.txtModel.text = @"";
                cell.txtYear.text = @"";
                cell.txtMake.text = @"";
                cell.txtVehicleMilaege.text = @"";
                if(isReloadTableView==true){
                    isReloadTableView=false;
                    [cell.txtYear becomeFirstResponder];
                }
                return cell;
            }
        }
        
        return cell;
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
    else if ([object isKindOfClass: [NSString class]] && object!=nil) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"nil"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}


#pragma mark - UITextField Delegate
#pragma mark
//------------------------------------------------------------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return TRUE;
}
//------------------------------------------------------------------------------

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[IQKeyboardManager sharedManager] setEnable:FALSE];
    activeField = textField;
    [activeField setTintColor:[UIColor blueColor]];
    [textField becomeFirstResponder];
}
//------------------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try{
        
        [[IQKeyboardManager sharedManager] setEnable:YES];
        AddClientSectionTwoTVC *localCell  = (AddClientSectionTwoTVC*)[[textField superview] superview];
          NSMutableDictionary *dictEditStorage = [[NSMutableDictionary alloc]init];
        NSLog(@"cell tag %ld",(long)localCell.tag);
        
        if(localCell!=nil){
            if(isLastItemEmpty){
                isLastItemEmpty=false;
            }else{
              
                
                [dictEditStorage setObject:localCell.txtModel.text forKey:@"sVinModel"];
                [dictEditStorage setObject:localCell.txtYear.text forKey:@"sVinYear"];
                [dictEditStorage setObject:localCell.txtMake.text forKey:@"sMake"];
                [dictEditStorage setObject:localCell.txtVehicleMilaege.text forKey:@"sMiles"];
                NSLog(@"localCell tag %ld",(long)(localCell.tag-29590));
                [aryTotalVehicles replaceObjectAtIndex:localCell.tag-29590 withObject:dictEditStorage];
            }
        }
        if (cell.txtVehicleMilaege==textField) {
            if(isRecordAddedUsingAPI)
            {
                [dictEditStorage setObject:localCell.txtVehicleMilaege.text forKey:@"sMiles"];
            }
        }
       /* if (cell.txtVehicleMilaege==textField) {
            if(isRecordAddedUsingAPI)
            {
                [dictEditStorage setObject:localCell.txtVehicleMilaege.text forKey:@"sMiles"];
                if(cell.txtYear.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Please enter vehicle Year"];
                    textField.text=@"";
                    return;
                }
                else if(cell.txtMake.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Pleas enter vehicle Make" duration:1 position:CSToastPositionCenter title:nil];
                    textField.text=@"";
                    
                    return;
                }
                else if(cell.txtModel.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Pleas enter vehicle Model"];
                    textField.text=@"";
                    return;
                }
                else if(cell.txtVehicleMilaege.text.length==0){
                    [textField endEditing:true];
                    return;
                }
                isRecordAddedUsingAPI=false;
//                [dictVehicleDataResponse setObject:cell.txtVehicleMilaege.text forKey:@"sMiles"];
//                [aryTotalVehicles replaceObjectAtIndex:aryNumberOfVehicle.count-1 withObject:dictVehicleDataResponse];
                cell.txtVehicleMilaege.text=textField.text;
            }
            else
            {
                if(cell.txtYear.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Please enter vehicle Year"];
                    textField.text=@"";
                    return;
                }
                else if(cell.txtMake.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Please enter vehicle Make" duration:1 position:CSToastPositionCenter title:nil];
                    textField.text=@"";
                    
                    return;
                }
                else if(cell.txtModel.text.length==0){
                    [textField endEditing:true];
                    [self.view makeToast:@"Please enter vehicle Model"];
                    textField.text=@"";
                    return;
                }
                else if(cell.txtVehicleMilaege.text.length==0){
                    [textField endEditing:true];
                    return;
                }
//                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
//                [dict1 setObject:cell.txtModel.text forKey:@"sVinModel"];
//                [dict1 setObject:cell.txtYear.text forKey:@"sVinYear"];
//                [dict1 setObject:cell.txtMake.text forKey:@"sMake"];
//                [dict1 setObject:cell.txtVehicleMilaege.text forKey:@"sMiles"];
//                [aryTotalVehicles replaceObjectAtIndex:aryNumberOfVehicle.count-1 withObject:dict1];
                cell.txtVehicleMilaege.text=textField.text;
            }
            
        }*/
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
        
        if([txtViewNotes isFirstResponder]){
            return;
        }
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+70, 0.0);
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        CGPoint scrollPoint = CGPointMake(0.0, 0);
        [scrollView setContentOffset:scrollPoint animated:NO];
        
        if(activeField==cell.txtVehicleMilaege || activeField==cell.txtMake || activeField==cell.txtModel|| activeField==cell.txtYear){
            scrollView.contentInset = contentInsets;
            scrollView.scrollIndicatorInsets = contentInsets;
            
            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your application might not need or want this behavior.
            AddClientSectionTwoTVC *localCell  = (AddClientSectionTwoTVC*)[[activeField superview] superview];

            NSInteger totalVehicleInteger = localCell.tag-29590;
            float activeTextFieldHeight = activeField.frame.origin.y;
            CGRect aRect = self.view.frame;
            aRect.size.height -= kbSize.height;
            CGPoint scrollPoint;
            if(IS_IPAD){
                //[ipad]
                switch (totalVehicleInteger) {
                    case 0:
                        scrollPoint = CGPointMake(0.0, (activeTextFieldHeight+20)*3);
                        break;
                    case 1:
                        scrollPoint = CGPointMake(0.0,(activeTextFieldHeight+kbSize.height-50)*3);
                        break;
                    case 2:
                        scrollPoint = CGPointMake(0.0, (activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*70)*3);
                        break;
                    case 3:
                        scrollPoint = CGPointMake(0.0, (activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*130)*3);
                        break;
                    case 4:
                        scrollPoint = CGPointMake(0.0, (activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*170)*3);
                        break;
                        
                    default:
                        scrollPoint = CGPointMake(0.0, (activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*180)*3);
                        
                        break;
                }
            }
            else{
                if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
                {
                    if ([[UIScreen mainScreen] bounds].size.height == 568.0f)
                    {
                        // iphone  5s
                        switch (totalVehicleInteger) {
                            case 0:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+20);
                                break;
                            case 1:
                                scrollPoint = CGPointMake(0.0,activeTextFieldHeight+kbSize.height-50);
                                break;
                            case 2:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*70);
                                break;
                            case 3:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*130);
                                break;
                            case 4:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*170);
                                break;
                                
                            default:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*180);
                                
                                break;
                        }
                    }
                    else
                    {
                        
                        switch (totalVehicleInteger) {
                            case 0:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+20);
                                break;
                            case 1:
                                scrollPoint = CGPointMake(0.0,activeTextFieldHeight+kbSize.height-80);
                                break;
                            case 2:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*20);
                                break;
                            case 3:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*80);
                                break;
                            case 4:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*120);
                                break;
                                
                            default:
                                scrollPoint = CGPointMake(0.0, activeTextFieldHeight+kbSize.height+(totalVehicleInteger)*170);
                                break;
                        }
                    }
                }
                
                [scrollView setContentOffset:scrollPoint animated:NO];
                
                return;
            }
        }
        
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
    @try{
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
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


#pragma mark - get & set
- (CALayer *)borderLayer
{
    if (nil == _borderLayer) {
        _borderLayer = [CALayer layer];
        _borderLayer.frame = CGRectMake((self.view.frame.origin.x), ((self.view.frame.size.height)/2)-142, (self.view.frame.size.width), (self.view.frame.size.height)/2);
        _borderLayer.delegate = self;
    }
    return _borderLayer;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef) context
{
    @try{
        CGContextSetLineWidth(context, self.areaWidth);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        
        UIBezierPath*    topLeftBezierPath = [[UIBezierPath alloc] init];
        
        [topLeftBezierPath moveToPoint:CGPointMake(0.0, 0.0)];
        [topLeftBezierPath addLineToPoint:CGPointMake(self.areaXWidth, 0.0f)];
        [topLeftBezierPath addLineToPoint:CGPointMake(self.areaXWidth, self.areaWidth)];
        [topLeftBezierPath addLineToPoint:CGPointMake(self.areaWidth, self.areaWidth)];
        [topLeftBezierPath addLineToPoint:CGPointMake(self.areaWidth, self.areaYHeight)];
        [topLeftBezierPath addLineToPoint:CGPointMake(0.0f, self.areaYHeight)];
        [topLeftBezierPath closePath];
        
        CGContextBeginPath(context);
        CGContextAddPath(context, topLeftBezierPath.CGPath);
        
        UIBezierPath *topRightPath = [[UIBezierPath alloc] init];
        
        [topRightPath moveToPoint:CGPointMake(layer.bounds.size.width, 0.0f)];
        [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, 0.0f)];
        [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, self.areaWidth)];
        [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, self.areaWidth)];
        [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, self.areaYHeight)];
        [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width, self.areaYHeight)];
        [topRightPath closePath];
        CGContextAddPath(context, topRightPath.CGPath);
        
        UIBezierPath *bottomLeftPath = [[UIBezierPath alloc] init];
        [bottomLeftPath moveToPoint:CGPointMake(0.0f, layer.bounds.size.height)];
        [bottomLeftPath addLineToPoint:CGPointMake(self.areaXWidth, layer.bounds.size.height)];
        [bottomLeftPath addLineToPoint:CGPointMake(self.areaXWidth, layer.bounds.size.height - self.areaWidth)];
        [bottomLeftPath addLineToPoint:CGPointMake(self.areaWidth, layer.bounds.size.height - self.areaWidth)];
        [bottomLeftPath addLineToPoint:CGPointMake(self.areaWidth, layer.bounds.size.height - self.areaYHeight)];
        [bottomLeftPath addLineToPoint:CGPointMake(0.0f, layer.bounds.size.height - self.areaYHeight)];
        [bottomLeftPath closePath];
        CGContextAddPath(context, bottomLeftPath.CGPath);
        
        UIBezierPath *bottomRightPath = [[UIBezierPath alloc] init];
        [bottomRightPath moveToPoint:CGPointMake(layer.bounds.size.width, layer.bounds.size.height)];
        [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, layer.bounds.size.height)];
        [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, layer.bounds.size.height - self.areaWidth)];
        [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, layer.bounds.size.height - self.areaWidth)];
        [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, layer.bounds.size.height - self.areaYHeight)];
        [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width, layer.bounds.size.height - self.areaYHeight)];
        [bottomRightPath closePath];
        CGContextAddPath(context, bottomRightPath.CGPath);
        
        CGContextDrawPath(context, kCGPathStroke);
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

@end
