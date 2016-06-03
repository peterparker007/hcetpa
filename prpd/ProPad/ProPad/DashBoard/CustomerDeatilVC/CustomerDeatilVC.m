
//  ProPad
//
//  Created by pradip.r on 7/30/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "CustomerDeatilVC.h"
#import "AsyncImageView.h"
#import "ApplicationData.h"
#import "UIImage+Helpers.h"
#import "PECropViewController.h"
#import "FMDBDataAccess.h"
#import "AppConstant.h"
#import "CustomerListViewController.h"
#import "RESideMenu.h"
#import "IQKeyboardManager.h"
#import "AddClientSectionTwoTVC.h"
#import "UIView+Toast.h"
#import "Base64.h"
#import <Social/Social.h>
#import <linkedin-sdk/LISDK.h>
#import "DynamicDisplayCell.h"
#import "SharePhotoAndCommentViewController.h"

@interface CustomerDeatilVC ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NIDropDownDelegate,RESideMenuDelegate,UIPopoverControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet NSLayoutConstraint *viewWidth;
    BOOL isEditBtnPressed;
    BOOL isImageChanged;
    UIButton *senderBtnReferenceForDropDown;
    UITextField *activeField;
    BOOL isClientProfileUpdated;
    BOOL isClientOnline;
    NSMutableDictionary  *localDataDictionary;
    UIImage *imageAfterCrop;
}

@end

@implementation CustomerDeatilVC
@synthesize txtYear,txtAddress,txtCity,txtCurrntVehiclNum,txtCustomerType,txtEmailAdd,txtFirstName,txtHomeNumber,txtHowDidYouHearAbtUs,txtLastName,txtMake,txtMobile,txtModel,txtPreferContcType,txtPrimaryMake,txtPrimaryModel,txtPrimaryStockNumber,txtPrimaryVehicleOfInterest,txtPrimaryYer,txtSecondaryMake,txtSecondaryModel,txtSecondaryVehicleOfInterest,txtSecondaryYear,txtSecStockNumber,txtState,txtStarttime,txtEndtime,txtNote,txtVehicleMilege,txtWorkNumber,txtZip,dataDictionary,btnEdit,btnTotalGrossAmount,btnUpdate,txtAppointment,txtAns;
@synthesize userImage,dropDown,cell,popoverImageViewController,arrForCustomer,scrollCustomerDetailList;
@synthesize imageObj,aryTotalVehicles,tblVehicleDetails,txtBackGrossAmount,txtFrontGrossAmout;
@synthesize aryQuesAns;

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try{
    
        [super viewDidLoad];
        [self companyServiceForIsPay];
        localDataDictionary = [[NSMutableDictionary alloc] init];
        isClientOnline=false;
        [self registerForKeyboardNotifications];
        scrollCustomerDetailList.delegate=self;
        isClientProfileUpdated=false;
        self.navigationItem.title = @"Customer Details";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
        
        arrForCustomer = [[NSArray alloc] init];
        arrForCustomer = [NSArray arrayWithObjects:@"Working Customer", @"Sold Customer", @"Lost Customer",nil];
        //       dictDynamicData=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
        //        [NSString  stringWithFormat:@"Test"], @"Que1",
        //        [NSString stringWithFormat:@"Test"], @"Ans1",
        //        [NSString  stringWithFormat:@"Test"], @"Que2",
        //        [NSString stringWithFormat:@"Test"], @"Ans2",
        //       [NSString  stringWithFormat:@"Test"], @"Que3",
        //       [NSString stringWithFormat:@"Test"], @"Ans3"
        //                                              ,nil];
        
        [self enableAndDisableTextField:NO];
        aryQuesAns=[[NSMutableArray alloc]init];
        aryTotalVehicles = [[NSMutableArray alloc] init];
        self.tblViewCustCell.scrollEnabled=false;
        DLog(@"%@",self.dictCustomerDetails);
        
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true){
            isClientOnline=true;
        }
        else
            isClientOnline=false;
        
        [self initView];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tblVehicleDetails reloadData];
    [self.tblDynamicViewCell reloadData];
     [[ApplicationData sharedInstance] hideLoader];
}

- (void)viewDidLayoutSubviews
{
    @try{
        if(IS_IPAD)
            [scrollCustomerDetailList setContentSize:CGSizeMake(self.view.frame.size.width, 2350)];
        else
            [scrollCustomerDetailList setContentSize:CGSizeMake(self.view.frame.size.width, 1750)];
        scrollCustomerDetailList.scrollEnabled = TRUE;
        [viewWidth setConstant:self.view.frame.size.width];
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


#pragma mark ************    TABLE DELEGATE   *****************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try{
        if(self.tblVehicleDetails==tableView)
            return [aryTotalVehicles count];
        else if(self.tblViewCustCell==tableView)
            return 1;
        else if(self.tblDynamicViewCell==tableView){
            
            return [aryQuesAns count];
        }
        else
            return 0;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try{
        
        if(self.tblVehicleDetails==tableView){
            if(IS_IPAD)
                return 250;
            else
                return 200;
        }
        
        else if(self.tblViewCustCell==tableView)
            return 108;
        else if (self.tblDynamicViewCell==tableView)
        {
            if(IS_IPAD)
                return 72;
            else
                return 57;
        }
        else
            return 0;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if(tableView==self.tblViewCustCell)
        {
            static NSString *simpleTableIdentifier = @"ClientTableViewCell";
            
            cell = (CustomerDetailTVC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerDetailTVC" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [_tblViewCustCell setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                
            }
            NSURL *url;
            if(isClientOnline){
                  NSString *strImage = [NSString stringWithFormat:@"%@",[self.dictCustomerDetails valueForKey:@"sImage"]];
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@",[self.dictCustomerDetails valueForKey:@"sImage"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                if([strImage isEqualToString:@""])
                {
                    cell.imgView.image=[UIImage imageNamed:@"no-image"];
                    //                        [cell.contentView addSubview:cell.imgCustomerImage];
                    //                    [imageObja.ai stopAnimating];
                }else{
                    cell.imgView.imageURL = url;
                    cell.imgView.showActivityIndicator=true;
                    
                    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgCustomerImage.imageURL];
                }
                cell.imgView.layer.cornerRadius = 6;
                cell.imgView.layer.masksToBounds=YES;
                
               // cell.imgView.tag=indexPath.row+40034;
              
               //  [cell.imgView.layer setCornerRadius:6];
//                                 cell.imgView.layer.cornerRadius =  cell.imgView.frame.size.width/2;
                
                //image circal....
                //cell.imgView.imageURL = url;
                
//                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgView];
//                imageObj=cell.imgView;
                //                [imageObj setImageAtURL:url];
                //                [imageObj.ai stopAnimating];
            }
            else
            {
                NSData* data = [Base64 decode:[NSString stringWithFormat:@"%@",[self.dictCustomerDetails valueForKey:@"sImage"]]];
                imageObj.image = [UIImage imageWithData:data];
            }
            if(cell.imgView.image==nil)
                cell.imgView.image=imageAfterCrop;
            imageObj.tag = 4567;
            [cell.contentView addSubview:imageObj];
            
            CALayer *imageLayer = imageObj.layer;
            [imageLayer setCornerRadius:6];
            [imageLayer setBorderColor:(__bridge CGColorRef)([UIColor clearColor])];
            [imageLayer setMasksToBounds:YES];
            
            UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
            [singleTap setNumberOfTapsRequired:1];
            [imageObj addGestureRecognizer:singleTap];
            imageObj.userInteractionEnabled=true;
            
            [cell.btnCustomerType addTarget:self action:@selector(btnCustomerTypePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.btnBrower addTarget:self action:@selector(btnBrowerPressed) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[self.dictCustomerDetails valueForKey:@"sCustomerStatus"]isEqualToString:@
                 "Lost"])
            {
                [cell.btnCustomerType setTitle:@"Lost Customer" forState:UIControlStateNormal];
                cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-red"];
            }
            
            else if ([[self.dictCustomerDetails valueForKey:@"sCustomerStatus"]isEqualToString:@
                      "Sold"])
            {
                [cell.btnCustomerType setTitle:@"Sold Customer" forState:UIControlStateNormal];
                cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-yellow"];
            }
            else
            {
                [cell.btnCustomerType setTitle:@"Working Customer" forState:UIControlStateNormal];
                cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-blue"];
            }
            return cell;
        }
        else if(tableView==self.tblVehicleDetails)
        {
            NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld",indexPath.row+11000];
            tableView.layer.borderWidth = 2;
            tableView.layer.borderColor = [[UIColor blackColor] CGColor];
            tableView.layer.cornerRadius=15;
            
            AddClientSectionTwoTVC *cellVehicleDetail = (AddClientSectionTwoTVC *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cellVehicleDetail == nil){
                
                static NSString *simpleTableIdentifier;
                if(IS_IPAD)
                    simpleTableIdentifier= @"AddClientSectionTwoTVC";
                else
                    simpleTableIdentifier = @"AddClientSectionTwoTVC_iPhone";
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
                cellVehicleDetail = [nib objectAtIndex:0];
                [cellVehicleDetail setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [self.tblVehicleDetails setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            }
            cellVehicleDetail.txtMake.delegate=self;
            cellVehicleDetail.txtYear.delegate=self;
            cellVehicleDetail.txtModel.delegate=self;
            cellVehicleDetail.txtVehicleMilaege.delegate=self;
            cellVehicleDetail.divider.hidden=true;
            cellVehicleDetail.txtYear.tag = [simpleTableIdentifier intValue]+100;
            cellVehicleDetail.txtModel.tag = [simpleTableIdentifier intValue]+200;
            cellVehicleDetail.txtVehicleMilaege.tag = [simpleTableIdentifier intValue]+300;
            cellVehicleDetail.txtMake.tag =[simpleTableIdentifier intValue]+400;
            cellVehicleDetail.txtMake.enabled=isEditBtnPressed;
            cellVehicleDetail.txtMake.placeholder=@"";
            cellVehicleDetail.txtModel.placeholder=@"";
            cellVehicleDetail.txtYear.placeholder=@"";
            cellVehicleDetail.txtVehicleMilaege.placeholder=@"";
            cellVehicleDetail.txtYear.enabled=isEditBtnPressed;
            cellVehicleDetail.txtModel.enabled=isEditBtnPressed;
            cellVehicleDetail.txtVehicleMilaege.enabled=isEditBtnPressed;
            cellVehicleDetail.lblVehicle.textColor = [UIColor blackColor];
            [cellVehicleDetail.lblVehicle setFont:[UIFont systemFontOfSize:12.0]];
            cellVehicleDetail.tag=indexPath.row+20000;
            
            if(aryTotalVehicles.count>0){
                NSDictionary *dictDataVehicle = [aryTotalVehicles objectAtIndex:indexPath.row];
                cellVehicleDetail.txtModel.text = [dictDataVehicle valueForKey:@"sVinModel"];
                cellVehicleDetail.txtYear.text = [dictDataVehicle valueForKey:@"sVinYear"];
                cellVehicleDetail.txtMake.text = [dictDataVehicle valueForKey:@"sMake"];
                cellVehicleDetail.txtVehicleMilaege.text = [dictDataVehicle valueForKey:@"sMiles"];
            }
            [[aryTotalVehicles objectAtIndex:indexPath.row] setObject:cellVehicleDetail forKey:@"cell"];
            return cellVehicleDetail;
        }
        else if(tableView==self.tblDynamicViewCell)
        {
            NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld",indexPath.row+12000];
            tableView.layer.borderWidth = 2;
            tableView.layer.borderColor = [[UIColor blackColor] CGColor];
            tableView.layer.cornerRadius=15;
            
            DynamicDisplayCell *cellDynamicDetail = (DynamicDisplayCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cellDynamicDetail == nil){
                
                static NSString *simpleTableIdentifier;
                if(IS_IPAD)
                    simpleTableIdentifier= @"DynamicDisplayCell";
                else
                    simpleTableIdentifier = @"DynamicDisplayCell";
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
                cellDynamicDetail = [nib objectAtIndex:0];
                [cellDynamicDetail setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [self.tblDynamicViewCell setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            }
            
            
            cellDynamicDetail.txtAns.delegate=self;
            
            cellDynamicDetail.txtAns.tag = [simpleTableIdentifier intValue]+500;
            
            cellDynamicDetail.txtAns.enabled=isEditBtnPressed;
            //            cellDynamicDetail.txtAns.userInteractionEnabled=isEditBtnPressed;
            
            cellDynamicDetail.lblQuestion.textColor = [UIColor blackColor];
            [cellDynamicDetail.lblQuestion setFont:[UIFont systemFontOfSize:12.0]];
            cellDynamicDetail.tag=indexPath.row+30000;
            if(aryQuesAns.count>0){
                NSDictionary *dictData = [aryQuesAns objectAtIndex:indexPath.row];
                cellDynamicDetail.lblQuestion.text = [dictData valueForKey:@"nQueid"];
                cellDynamicDetail.txtAns.text = [dictData valueForKey:@"sCorrectAns"];
                
            }
            
            //            if(dictDynamicData.count>0){
            //                NSDictionary *dictData = dictDynamicData;
            //                NSArray *aryKey = [dictData allKeys];
            //                NSArray *arrValue = [dictData allValues];
            //                cellDynamicDetail.lblQuestion.text =[ NSString stringWithFormat:@"%@",[aryKey objectAtIndex:indexPath.row]];
            //                cellDynamicDetail.txtAns.text = [ NSString stringWithFormat:@"%@",[arrValue objectAtIndex:indexPath.row]];
            //
            //            }
            //[[aryTotalVehicles objectAtIndex:indexPath.row] setObject:cellDynamicDetail forKey:@"cell"];
            return cellDynamicDetail;
        }
        return nil;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath {
    //stuff
    //as last line:
    @try {
        if(tableView==self.tblViewCustCell)
        {
            [dropDown hideDropDown:senderBtnReferenceForDropDown];
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
            self.scrollCustomerDetailList.scrollEnabled=true;
            tableheightConst.constant = 108;
        }
    }
    @catch (NSException *exception) {
        
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
-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self btnImagePressed];
}

-(void)btnImagePressed
{
    if(isEditBtnPressed==true){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", @"Saved Album", nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
    }
}

-(void)btnCustomerTypePressed:(id)sender
{
    @try{
        senderBtnReferenceForDropDown=nil;
        senderBtnReferenceForDropDown = (UIButton*)sender;
        [self.view endEditing:YES];
        
        CGFloat f = 70;
        if(dropDown == nil && isEditBtnPressed && arrForCustomer.count>0) {
            
            dropDown = [[NIDropDown alloc] showDropDownMenu:sender dropDownheight:&f dropDownarr:arrForCustomer dropDowndirection:@"down"];
            dropDown.delegate = self;
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height+150);
            
            if ([[self.dictCustomerDetails valueForKey:@"sCustomerStatus"]isEqualToString:@
                 "Lost"])
            {
                
                [dropDown.btnSender setTitle:@"Lost Customer" forState:UIControlStateNormal];
            }
            
            else if ([[self.dictCustomerDetails valueForKey:@"sCustomerStatus"]isEqualToString:@
                      "Sold"])
            {
                [dropDown.btnSender setTitle:@"Sold Customer" forState:UIControlStateNormal];
            }
            else
            {
                [dropDown.btnSender setTitle:@"Working Customer" forState:UIControlStateNormal];
            }
        }
        else{
            NSString *strCustomerType = [dataDictionary valueForKey:@"sCustomerStatus"];
            
            if([strCustomerType isEqualToString:@"Lost"])
                strCustomerType=@"Lost Customer";
            else if([strCustomerType isEqualToString:@"Sold"])
                strCustomerType=@"Sold Customer";
            else
                strCustomerType=@"Working Customer";
            
            dropDown.delegate = self;
            cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height+150);
            [self changeCustomerType:strCustomerType];
            [dropDown showDropDownMenu:senderBtnReferenceForDropDown dropDownheight:&f dropDownarr:arrForCustomer dropDowndirection:@"down"];
            
        }
        self.scrollCustomerDetailList.scrollEnabled=false;
        if(IS_IPAD)
            tableheightConst.constant = 250;
        else
            tableheightConst.constant = 200;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark NiDropDown delegate*****************

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    @try{
        [dropDown hideDropDown:senderBtnReferenceForDropDown];
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height-150);
        NSString *strCustomerType = sender.btnSender.titleLabel.text;
        [self changeCustomerType:strCustomerType];
        self.scrollCustomerDetailList.scrollEnabled=true;
        tableheightConst.constant = 108;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(void)changeCustomerType:(NSString*)strCustomerType
{
    @try{
        if ([strCustomerType isEqualToString:@
             "Lost Customer"])
        {
            [dataDictionary setObject:@"Lost" forKey:@"sCustomerStatus"];
            [cell.btnCustomerType setTitle:@"Lost Customer" forState:UIControlStateNormal];
            cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-red"];
        }
        
        else if ([strCustomerType isEqualToString:@
                  "Sold Customer"])
        {
            [dataDictionary setObject:@"Sold" forKey:@"sCustomerStatus"];
            [cell.btnCustomerType setTitle:@"Sold Customer" forState:UIControlStateNormal];
            cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-yellow"];
        }
        else
        {
            [dataDictionary setObject:@"Working" forKey:@"sCustomerStatus"];
            [cell.btnCustomerType setTitle:@"Working Customer" forState:UIControlStateNormal];
            cell.imgCustomerImage.image=[UIImage imageNamed:@"ribbon-blue"];
        }
        [dropDown hideDropDown:senderBtnReferenceForDropDown];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


-(void)btnBrowerPressed
{
   
    @try{
         [self btnImagePressed];
        [dropDown hideDropDown:senderBtnReferenceForDropDown];
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
        self.scrollCustomerDetailList.scrollEnabled=true;
        tableheightConst.constant = 108;
        [self.view endEditing:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    //[dropDown hideDropDown:senderBtnReferenceForDropDown];
    //[self hideDropDown:dropDown.btnSender];
    //[UITextField resignFirstResponder];
    
}


#pragma mark UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.navigationBar.tintColor=[UIColor whiteColor];
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
}


#pragma mark UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSMutableDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
#ifdef DEV_ENVIRONMENT
    DLog (@"Image Size, %f, %f", originalImage.size.width, originalImage.size.height
          );
#endif
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self openCropEditor:originalImage];
    }];
}

- (IBAction)btnEditPressed:(id)sender {
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
        cell.btnCustomerType.enabled=true;
        cell.btnBrower.enabled=true;
        isEditBtnPressed=true;
        [self.view endEditing:false];
        txtCustomerType.enabled=true;
        [txtCustomerType becomeFirstResponder];
        [self enableAndDisableTextField:YES];
        [self.tblVehicleDetails reloadData];
        [self.tblDynamicViewCell reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }}];
}


- (IBAction)btnUpdatePressed:(id)sender {
    
    
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
        [self.view endEditing:true];
        DLog(@"dataDictionary.count %lu",(unsigned long)dataDictionary.count);
        localDataDictionary = [[NSMutableDictionary alloc] init];
        if(dataDictionary.count > 0)
            localDataDictionary = dataDictionary;
        NSString *strUserId = [[NSUserDefaults standardUserDefaults] objectForKey:UserId];
        [localDataDictionary setObject:[NSString stringWithFormat:@"%@",strUserId]  forKey:@"nUserId"];
        [localDataDictionary setObject:txtSecondaryVehicleOfInterest.text forKey:@"sSecondVehType"];
        [localDataDictionary setObject:txtPrimaryVehicleOfInterest.text forKey:@"sFirstVehType"];
        if([cell.btnCustomerType.titleLabel.text isEqualToString:@"Working Customer"])
            [localDataDictionary setObject:@"Working" forKey:@"sCustomerStatus"];
        else if([cell.btnCustomerType.titleLabel.text isEqualToString:@"Sold Customer"])
            [localDataDictionary setObject:@"Sold" forKey:@"sCustomerStatus"];
        else{
            [localDataDictionary setObject:@"Lost" forKey:@"sCustomerStatus"];
        }
        [localDataDictionary setObject:txtState.text forKey:@"sState"];
        [localDataDictionary setObject:txtPrimaryYer.text forKey:@"sFirstYear"];
        [localDataDictionary setObject:txtPrimaryStockNumber.text forKey:@"sFirstStockNumber"];
        
        [localDataDictionary setObject:txtPreferContcType.text forKey:@"sContactType"];
        id objTotalGross =  btnTotalGrossAmount.titleLabel.text;
        if(objTotalGross==nil)
            objTotalGross=@"";
        [localDataDictionary setObject:objTotalGross forKey:@"nTotalGrossAmount"];
        [localDataDictionary setObject:txtFrontGrossAmout.text forKey:@"nFrontGrossAmount"];
        [localDataDictionary setObject:txtBackGrossAmount.text forKey:@"nBackGrossAmount"];
        
        [localDataDictionary setObject:txtEmailAdd.text forKey:@"sEmail"];
        [localDataDictionary setObject:txtHomeNumber.text forKey:@"sHome"];
        [localDataDictionary setObject:txtMobile.text forKey:@"nMobile"];
        [localDataDictionary setObject:txtZip.text forKey:@"sZip"];
        [localDataDictionary setObject:txtWorkNumber.text forKey:@"sWork"];
        [localDataDictionary setObject:txtPrimaryMake.text forKey:@"sFirstMake"];
        [localDataDictionary setObject:txtPrimaryModel.text forKey:@"sFirstModel"];
        [localDataDictionary setObject:txtSecondaryYear.text forKey:@"sSecondYear"];
        [localDataDictionary setObject:txtSecondaryModel.text forKey:@"sSecondModel"];
        [localDataDictionary setObject:txtSecondaryMake.text forKey:@"sSecondMake"];
        [localDataDictionary setObject:txtSecStockNumber.text forKey:@"sSecondStockNumber"];
        [localDataDictionary setObject:txtCity.text forKey:@"sCity"];
        [localDataDictionary setObject:txtAddress.text forKey:@"sAddress"];
        [localDataDictionary setObject:txtLastName.text forKey:@"sLastName"];
        [localDataDictionary setObject:txtFirstName.text forKey:@"sFirstName"];
        [localDataDictionary setObject:txtHowDidYouHearAbtUs.text forKey:@"sHearAbout"];
        [localDataDictionary setObject:txtCustomerType.text forKey:@"sCustomerType"];
        [localDataDictionary setObject:txtAppointment.text forKey:@"sAppointment"];
        [localDataDictionary setObject:_tvNote.text forKey:@"sNote"];
        //  [localDataDictionary setObject:txtNote.text forKey:@"sNote"];
        NSMutableArray *aryVehicleDatas = [[NSMutableArray alloc] init];
        int totalvehicles = aryTotalVehicles.count;
        for(int i=0; i<totalvehicles;i++)
        {
            AddClientSectionTwoTVC *cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:i] valueForKey:@"cell"];
            NSMutableDictionary *dictVehicleDatas = [[NSMutableDictionary alloc] init];
            if (cellVehicleDetail) {
                [dictVehicleDatas setObject:cellVehicleDetail.txtYear.text forKey:@"sVinYear"];
                [dictVehicleDatas setObject:cellVehicleDetail.txtModel.text forKey:@"sVinModel"];
                [dictVehicleDatas setObject:cellVehicleDetail.txtVehicleMilaege.text forKey:@"sMiles"];
                [dictVehicleDatas setObject:cellVehicleDetail.txtMake.text forKey:@"sMake"];
            }
            else {
                [dictVehicleDatas setObject:[[aryTotalVehicles objectAtIndex:i]valueForKey:@"sVinYear"] forKey:@"sVinYear"];
                [dictVehicleDatas setObject:[[aryTotalVehicles objectAtIndex:i]valueForKey:@"sVinModel"] forKey:@"sVinModel"];
                [dictVehicleDatas setObject:[[aryTotalVehicles objectAtIndex:i]valueForKey:@"sMiles"] forKey:@"sMiles"];
                [dictVehicleDatas setObject:[[aryTotalVehicles objectAtIndex:i] valueForKey:@"sMake"] forKey:@"sMake"];
            }
            [aryVehicleDatas addObject:dictVehicleDatas];
        }
        NSMutableArray *aryAnsDatas = [[NSMutableArray alloc] init];
        int totalAns=aryQuesAns.count;
        
        for(int i=0; i<totalAns;i++)
        {
            NSMutableDictionary *dictDatas = [[NSMutableDictionary alloc] init];
            [dictDatas setObject:[[aryQuesAns objectAtIndex:i] valueForKey:@"sCorrectAns"] forKey:@"sCorrectAns"];
            //            DynamicDisplayCell *cellVehicleDetail=[DynamicDisplayCell new];
            //
            //            if (cellVehicleDetail) {
            //                [dictDatas setObject:cellVehicleDetail.txtAns.text forKey:@"sCorrectAns"];
            //
            //            }
            //            else {
            //
            //                [dictDatas setObject:[[aryQuesAns objectAtIndex:i] valueForKey:@"sCorrectAns"] forKey:@"sCorrectAns"];
            //            }
            [aryAnsDatas addObject:[dictDatas valueForKey:@"sCorrectAns"]];
        }
        NSData *jsonData =  [NSJSONSerialization dataWithJSONObject:aryVehicleDatas options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [localDataDictionary setObject:jsonString forKey:@"vin_data"];
        jsonData=[NSJSONSerialization dataWithJSONObject:aryAnsDatas options:NSJSONWritingPrettyPrinted error:nil];
        jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *unfilteredString =jsonString;
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,1234567890- /"] invertedSet];
        NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        NSLog (@"Result: %@", resultString);
        [localDataDictionary setObject:resultString forKey:@"sCorrectAns"];
        NSData *imageData;
        if(isImageChanged){
            if(!isClientOnline)
            {
                NSData *imageData = UIImageJPEGRepresentation([localDataDictionary valueForKey:@"sImage"], 0.5);
                NSString* strImageData1 = [Base64 encode:imageData];
                [dataDictionary setObject:strImageData1 forKey:@"sImage"];
                
                [localDataDictionary setObject:strImageData1 forKey:@"sImage"];
            }
            else
            {
                [localDataDictionary setObject:cell.imgView.image forKey:@"sImage"];
                imageData = UIImageJPEGRepresentation([localDataDictionary valueForKey:@"sImage"], 0.5);
                [dataDictionary setObject:[NSString stringWithFormat:@"%@",imageData] forKey:@"sImage"];
            }
        }
        else
        {
            if(isClientOnline && imageObj.image!=nil)
            {
                NSString *strImage =  [self.dictCustomerDetails valueForKey:@"sImage"];
                NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
                imageData=data;
                [localDataDictionary setObject:[NSString stringWithFormat:@"%@",data] forKey:@"sImage"];
            }
            else
            {
                imageObj = (AsyncImageView *)[cell.contentView viewWithTag:4567];
                
                [localDataDictionary setObject:cell.imgView.image forKey:@"sImage"];
                imageData = UIImageJPEGRepresentation([localDataDictionary valueForKey:@"sImage"], 0.5);
                [localDataDictionary setObject:[NSString stringWithFormat:@"%@",imageData] forKey:@"sImage"];
                
//                if(imageObj.image)
//                {     NSData *imageData = UIImageJPEGRepresentation(imageObj.image, 0.5);
//                    NSString* strImageData1 = [Base64 encode:imageData];
//                    [localDataDictionary setObject:strImageData1 forKey:@"sImage"];
//                }
//                else
//                    [localDataDictionary setObject:[UIImage imageNamed:@"no-image"] forKey:@"sImage"];
            }
            
        }
        
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        dataDictionary=localDataDictionary;
        
        if([appDelegateTemp checkInternetConnection]==true)
        {
            
            NSString *strClientId = [[NSUserDefaults standardUserDefaults] valueForKey:KClientId];
            [localDataDictionary setObject:strClientId forKey:KClientId];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
            [localDataDictionary setObject:@"edit" forKey:@"mode"];
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
            NSDictionary *parameters=localDataDictionary;
            
            // add params (all params are strings)
            for(NSString *param in parameters) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            NSString *FileParamConstant = @"sImage";
            // add image data
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            if(imageData)
                [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            [request setURL:[NSURL URLWithString:KAddClient]];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       
                                       [hud setHidden:YES];
                                       NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                       
                                       if ([httpResponse statusCode] == 200) {
                                           NSError *errorJson=nil;
                                           NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                                           
                                           DLog(@"responseDict=%@",responseDict);
                                           if([ [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"status"] ] isEqualToString:@"1" ])
                                           {
                                               [hud hide:YES];
                                               isClientProfileUpdated=true;
                                               if(localDataDictionary.count > 0)
                                                   dataDictionary = localDataDictionary;
                                               
                                               [self updateClientToLocalDatabase:true];
                                               
                                               UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Customer Details"  message:@"Customer updated successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               alertSuccess.tag = 1;
                                               [alertSuccess show];
                                           }
                                           else
                                           {
                                               [hud hide:YES];
                                               
                                               UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Alert"  message:@"Failed to update Customer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               alertSuccess.tag = 1;
                                               [alertSuccess show];
                                           }
                                           DLog(@"success");
                                       }
                                       else
                                       {
                                           [hud hide:YES];
                                           UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Alert"  message:@"Failed to update Customer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                           alertSuccess.tag = 1;
                                           [alertSuccess show];
                                       }
                                   }];
            
            
        }
        else
        {
            [self updateClientToLocalDatabase:false];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Customer Details"                                                    message:@"Customer data has been successfully added."
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
      }
     }];
}


- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    if(isClientProfileUpdated){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:nil];
        CustomerListViewController *second=(CustomerListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
        
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}

-(void)updateClientToLocalDatabase:(BOOL)isClientOnline1
{
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    
    isClientProfileUpdated=true;
    
    if(!isClientOnline)
    {
        [dataDictionary setValue:[NSString stringWithFormat:@"%d",2] forKey:@"IsClientOnline"];
    }
    
    if(isClientOnline){
        NSString *strImageData = [dataDictionary objectForKey:@"sImage"];
        NSData* data = [strImageData dataUsingEncoding:NSUTF8StringEncoding];
        NSString* strImageData1 = [Base64 encode:data];
        [dataDictionary setObject:strImageData1 forKey:@"sImage"];
    }
    
    DLog(@"%@",dataDictionary);
    [dbAccess updateclientData:dataDictionary];
    isClientProfileUpdated=true;
    
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try{
        NSString * frontgrossAmount = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if(textField ==txtFrontGrossAmout)
        {
            NSInteger backGrossInt = [txtBackGrossAmount.text integerValue];
            
            NSInteger totalGross = backGrossInt+[frontgrossAmount integerValue];
            
            [btnTotalGrossAmount setTitle:[NSString stringWithFormat:@"$ %ld",(long)totalGross] forState:UIControlStateNormal];
            
            return YES;
        }
        else if (textField == txtBackGrossAmount)
        {
            NSString * backgrossAmount = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            NSInteger frontGrossInt = [txtFrontGrossAmout.text integerValue];
            
            NSInteger totalGross = frontGrossInt+[backgrossAmount integerValue];
            [btnTotalGrossAmount setTitle:[NSString stringWithFormat:@"$ %ld",(long)totalGross] forState:UIControlStateNormal];
            return YES;
            
        }
        else if (textField.tag<=11000)
        {
            AddClientSectionTwoTVC *cellVehicleDetail;
            int value = textField.tag-11000;
            
            if (value>=100 && value<200) {
                value = value-100;
                //            cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:value]valueForKey:@"cell"];
                [[aryTotalVehicles objectAtIndex:value] setObject:frontgrossAmount forKey:@"sVinYear"];
            }
            else if (value>=200 && value<300) {
                value = value-200;
                //            cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:value]valueForKey:@"cell"];
                [[aryTotalVehicles objectAtIndex:value] setObject:frontgrossAmount forKey:@"sVinModel"];
                
            }
            else if (value>=300 && value<400) {
                value = value-300;
                //            cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:value]valueForKey:@"cell"];
                [[aryTotalVehicles objectAtIndex:value] setObject:frontgrossAmount forKey:@"sMiles"];
            }
            else if (value>400 && value<500) {
                value = value-400;
                //            cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:value]valueForKey:@"cell"];
                [[aryTotalVehicles objectAtIndex:value] setObject:frontgrossAmount forKey:@"sMake"];
                
            }
            //            else if (value>=500 ) {
            //                value = value-500;
            //                //            cellVehicleDetail = [(AddClientSectionTwoTVC *)[aryTotalVehicles objectAtIndex:value]valueForKey:@"cell"];
            //                [[aryQuesAns objectAtIndex:value] setObject:frontgrossAmount forKey:@"sCorrectAns"];
            //
            //            }
        }
        else if (textField.tag>=12000)
        {
            
            int value = textField.tag-12000;
            
            if (value>=500 )
            {
                value = value-500;
                
                
                [[aryQuesAns objectAtIndex:value] setObject:frontgrossAmount forKey:@"sCorrectAns"];
                
            }
        }
        return YES;
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
        [dropDown hideDropDown:senderBtnReferenceForDropDown];
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
        [[IQKeyboardManager sharedManager] setEnable:true];
        activeField = textField;
        self.scrollCustomerDetailList.scrollEnabled=true;
        tableheightConst.constant = 108;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}
//------------------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0 animations:^{
        [[IQKeyboardManager sharedManager] setEnable:YES];
    }];
    
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
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+70, 0.0);
        scrollCustomerDetailList.translatesAutoresizingMaskIntoConstraints = NO;
        
        scrollCustomerDetailList.contentInset = contentInsets;
        scrollCustomerDetailList.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
            [scrollCustomerDetailList setContentOffset:scrollPoint animated:YES];
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
    scrollCustomerDetailList.contentInset = contentInsets;
    scrollCustomerDetailList.scrollIndicatorInsets = contentInsets;
}



#pragma mark ************ INIT VIEW ************

-(void)initView
{
    @try{
        txtYear.delegate = self;
        txtAddress.delegate = self;
        txtCity.delegate = self;
        
        txtCurrntVehiclNum.delegate = self;
        txtCustomerType.delegate = self;
        
        txtEmailAdd.delegate = self;
        txtFirstName.delegate = self;
        txtHomeNumber.delegate = self;
        txtHowDidYouHearAbtUs.delegate = self;
        txtLastName.delegate = self;
        txtMake.delegate = self;
        txtMobile.delegate = self;
        txtModel.delegate = self;
        
        txtPreferContcType.delegate = self;
        txtPrimaryMake.delegate = self;
        txtPrimaryModel.delegate = self;
        txtPrimaryStockNumber.delegate = self;
        txtPrimaryVehicleOfInterest.delegate = self;
        txtPrimaryYer.delegate = self;
        txtSecondaryMake.delegate = self;
        txtSecondaryModel.delegate = self;
        txtSecondaryVehicleOfInterest.delegate = self;
        txtSecondaryYear.delegate = self;
        txtSecStockNumber.delegate = self;
        txtState.delegate = self;
        txtVehicleMilege.delegate = self;
        txtWorkNumber.delegate = self;
        txtZip.delegate = self;
        
        
        NSString *postString = [NSString stringWithFormat:@"%@",[self.dictCustomerDetails valueForKey:@"nClientId"]];
        
        [[NSUserDefaults standardUserDefaults] setValue:postString forKey:KClientId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        txtSecondaryVehicleOfInterest.text =[self.dictCustomerDetails objectForKey:@"sSecondVehType"];
        txtPrimaryVehicleOfInterest.text =[self.dictCustomerDetails objectForKey:@"sFirstVehType"];
        txtCurrntVehiclNum.text =[self.dictCustomerDetails objectForKey:@""];
        txtState.text =[self.dictCustomerDetails objectForKey:@"sState"];
        
        txtPrimaryYer.text =[self.dictCustomerDetails objectForKey:@"sFirstYear"];
        txtPrimaryStockNumber.text =[self.dictCustomerDetails objectForKey:@"sFirstStockNumber"];
        
        
        
        txtPreferContcType.text =[self.dictCustomerDetails objectForKey:@"sContactType"];
        txtEmailAdd.text =[self.dictCustomerDetails objectForKey:@"sEmail"];
        
        txtHomeNumber.text =[self.dictCustomerDetails objectForKey:@"sHome"];
        txtMobile.text =[self.dictCustomerDetails objectForKey:@"nMobile"];
        
        txtZip.text =[self.dictCustomerDetails objectForKey:@"sZip"];
        txtWorkNumber.text =[self.dictCustomerDetails objectForKey:@"sWork"];
        
        txtPrimaryMake.text =[self.dictCustomerDetails objectForKey:@"sFirstMake"];
        txtPrimaryModel.text =[self.dictCustomerDetails objectForKey:@"sFirstModel"];
        
        txtSecondaryYear.text =[self.dictCustomerDetails objectForKey:@"sSecondYear"];;
        txtSecondaryModel.text =[self.dictCustomerDetails objectForKey:@"sSecondModel"];
        txtSecondaryMake.text =[self.dictCustomerDetails objectForKey:@"sSecondMake"];
        
        
        [btnTotalGrossAmount setTitle:[NSString stringWithFormat:@"%@",[self.dictCustomerDetails objectForKey:@"nTotalGrossAmount"]] forState:UIControlStateNormal];
        txtFrontGrossAmout.text =[NSString stringWithFormat:@"%@",[self.dictCustomerDetails objectForKey:@"nFrontGrossAmount"]];
        txtBackGrossAmount.text =[NSString stringWithFormat:@"%@",[self.dictCustomerDetails objectForKey:@"nBackGrossAmount"]];
        
        txtCurrntVehiclNum.text =[NSString stringWithFormat:@"%@",[self.dictCustomerDetails objectForKey:@"nVIN"]];
        
        
        txtSecStockNumber.text =[self.dictCustomerDetails objectForKey:@"sSecondStockNumber"];
        txtCity.text =[self.dictCustomerDetails objectForKey:@"sCity"];
        txtAddress.text =[self.dictCustomerDetails objectForKey:@"sAddress"];
        txtLastName.text =[self.dictCustomerDetails objectForKey:@"sLastName"];
        txtFirstName.text =[self.dictCustomerDetails objectForKey:@"sFirstName"];
        txtHowDidYouHearAbtUs.text =[self.dictCustomerDetails objectForKey:@"sHearAbout"];
        txtCustomerType.text =[self.dictCustomerDetails objectForKey:@"sCustomerType"];
        txtStarttime.text=[self.dictCustomerDetails objectForKey:@"sStartTime"];
        txtEndtime.text=[self.dictCustomerDetails objectForKey:@"sEndTime"];
        // txtNote.text=[self.dictCustomerDetails objectForKey:@"sNote"];
        _tvNote.text=[self.dictCustomerDetails objectForKey:@"sNote"];
        
        txtAppointment.text=[self.dictCustomerDetails objectForKey:@"sAppointment"];
        
        dataDictionary = [[NSMutableDictionary alloc] init];
        dataDictionary = [NSMutableDictionary dictionaryWithDictionary:self.dictCustomerDetails];
        isImageChanged=false;
        
        NSArray *arrVinModel = [[self.dictCustomerDetails valueForKey:@"sVinModel"] componentsSeparatedByString:@","];
        NSArray *arrVinYear = [[self.dictCustomerDetails valueForKey:@"sVinYear"] componentsSeparatedByString:@","];
        
        NSArray *arrMake = [[self.dictCustomerDetails valueForKey:@"sMake"] componentsSeparatedByString:@","];
        
        NSArray *arrMiles = [[self.dictCustomerDetails valueForKey:@"sMiles"] componentsSeparatedByString:@","];
        NSArray *arrQues=[self.dictCustomerDetails valueForKey:@"nQueid"];
        NSArray *arrAns=[self.dictCustomerDetails valueForKey:@"sCorrectAns"];
        
        
        
        
        
        for (int i=0; i<arrVinModel.count;i++) {
            NSMutableDictionary *dictVehicle = [[NSMutableDictionary alloc] init];
            id objVinModel = [arrVinModel objectAtIndex:i];
            if(objVinModel==nil || objVinModel==NULL)
                [dictVehicle setObject:@"" forKey:@"sVinModel"];
            else
                [dictVehicle setObject:objVinModel forKey:@"sVinModel"];
            
            if(arrVinYear.count<i+1)
                [dictVehicle setObject:@"" forKey:@"sVinYear"];
            else{
                id objVinYear = [arrVinYear objectAtIndex:i];
                if(objVinYear==nil || objVinYear==NULL)
                    [dictVehicle setObject:@"" forKey:@"sVinYear"];
                else
                    [dictVehicle setObject:objVinYear forKey:@"sVinYear"];
            }
            
            if(arrMake.count<i+1)
                [dictVehicle setObject:@"" forKey:@"sMake"];
            else
            {
                id objMake = [arrMake objectAtIndex:i];
                if(objMake==nil || objMake==NULL)
                    [dictVehicle setObject:@"" forKey:@"sMake"];
                else
                    [dictVehicle setObject:objMake forKey:@"sMake"];
            }
            
            if(arrMiles.count<i+1)
                [dictVehicle setObject:@"" forKey:@"sMiles"];
            else
            {
                id objMiles = [arrMiles objectAtIndex:i];
                if(objMiles==nil || objMiles==NULL)
                    [dictVehicle setObject:@"" forKey:@"sMiles"];
                else
                    [dictVehicle setObject:objMiles forKey:@"sMiles"];
            }
            [aryTotalVehicles addObject:dictVehicle];
        }
        [tblVehicleDetails reloadData];
        for (int i=0; i<arrAns.count; i++) {
            NSMutableDictionary *dictQuesAns=[[NSMutableDictionary alloc]init];
            id objQues=[arrQues objectAtIndex:i];
            if (objQues == nil || objQues == NULL)
                [dictQuesAns setObject:@"" forKey:@"nQueid"];
            else
                [dictQuesAns setObject:objQues forKey:@"nQueid"];
            
            if(arrAns.count<i+1)
                [dictQuesAns setObject:@"" forKey:@"sCorrectAns"];
            else{
                id objAns = [arrAns objectAtIndex:i];
                if(objAns==nil || objAns==NULL)
                    [dictQuesAns setObject:@"" forKey:@"sCorrectAns"];
                else
                    [dictQuesAns setObject:objAns forKey:@"sCorrectAns"];
                
                
            }
            [aryQuesAns addObject:dictQuesAns];
        }
        CGFloat height;
        height = ([aryTotalVehicles count] *180);
        tblVehicleDetailsHeight.constant = height;
        
        if(IS_IPAD){
            heightConst.constant=2200;
            txtYear.font = [UIFont systemFontOfSize:16];
            txtAddress.font = [UIFont systemFontOfSize:16];
            txtCity.font = [UIFont systemFontOfSize:16];
            
            txtCurrntVehiclNum.font = [UIFont systemFontOfSize:16];
            txtCustomerType.font = [UIFont systemFontOfSize:16];
            
            txtEmailAdd.font = [UIFont systemFontOfSize:16];
            txtFirstName.font = [UIFont systemFontOfSize:16];
            txtHomeNumber.font = [UIFont systemFontOfSize:16];
            txtHowDidYouHearAbtUs.font = [UIFont systemFontOfSize:16];
            txtLastName.font = [UIFont systemFontOfSize:16];
            txtMake.font = [UIFont systemFontOfSize:16];
            txtMobile.font = [UIFont systemFontOfSize:16];
            txtModel.font = [UIFont systemFontOfSize:16];
            
            txtPreferContcType.font = [UIFont systemFontOfSize:16];
            txtPrimaryMake.font = [UIFont systemFontOfSize:16];
            txtPrimaryModel.font = [UIFont systemFontOfSize:16];
            txtPrimaryStockNumber.font = [UIFont systemFontOfSize:16];
            txtPrimaryVehicleOfInterest.font = [UIFont systemFontOfSize:16];
            txtPrimaryYer.font = [UIFont systemFontOfSize:16];
            txtSecondaryMake.font = [UIFont systemFontOfSize:16];
            txtSecondaryModel.font = [UIFont systemFontOfSize:16];
            txtSecondaryVehicleOfInterest.font = [UIFont systemFontOfSize:16];
            txtSecondaryYear.font = [UIFont systemFontOfSize:16];
            txtSecStockNumber.font = [UIFont systemFontOfSize:16];
            txtState.font = [UIFont systemFontOfSize:16];
            txtVehicleMilege.font = [UIFont systemFontOfSize:16];
            txtWorkNumber.font = [UIFont systemFontOfSize:16];
            txtZip.font = [UIFont systemFontOfSize:16];
            _tvNote.font=[UIFont systemFontOfSize:16];
            //txtNote.font=[UIFont systemFontOfSize:16];
            txtStarttime.font=[UIFont systemFontOfSize:16];
            txtEndtime.font=[UIFont systemFontOfSize:16];
            btnEdit.titleLabel.font = [UIFont systemFontOfSize:16];
            btnTotalGrossAmount.titleLabel.font = [UIFont systemFontOfSize:16];
            btnUpdate.titleLabel.font = [UIFont systemFontOfSize:16];
            txtAppointment.font = [UIFont systemFontOfSize:16];
            txtBackGrossAmount.font = [UIFont systemFontOfSize:16];
            txtFrontGrossAmout.font = [UIFont systemFontOfSize:16];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(void)enableAndDisableTextField:(BOOL)isTxtEnable
{
    @try{
        btnEdit.selected=!btnEdit.selected;
        txtYear.enabled=isTxtEnable;
        txtAddress.enabled=isTxtEnable;
        txtCity.enabled=isTxtEnable;
        txtCurrntVehiclNum.enabled=isTxtEnable;
        txtCustomerType.enabled=isTxtEnable;
        txtEmailAdd.enabled=isTxtEnable;
        txtFirstName.enabled=isTxtEnable;
        txtHomeNumber.enabled=isTxtEnable;
        txtHowDidYouHearAbtUs.enabled=isTxtEnable;
        txtLastName.enabled=isTxtEnable;
        txtMake.enabled=isTxtEnable;
        txtMobile.enabled=isTxtEnable;
        txtModel.enabled=isTxtEnable;
        txtPreferContcType.enabled=isTxtEnable;
        txtPrimaryMake.enabled=isTxtEnable;
        txtPrimaryModel.enabled=isTxtEnable;
        txtPrimaryStockNumber.enabled=isTxtEnable;
        txtPrimaryVehicleOfInterest.enabled=isTxtEnable;
        txtPrimaryYer.enabled=isTxtEnable;
        txtSecondaryMake.enabled=isTxtEnable;
        txtSecondaryModel.enabled=isTxtEnable;
        txtSecondaryVehicleOfInterest.enabled=isTxtEnable;
        txtSecondaryYear.enabled=isTxtEnable;
        txtSecStockNumber.enabled=isTxtEnable;
        txtState.enabled=isTxtEnable;
        txtVehicleMilege.enabled=isTxtEnable;
        txtWorkNumber.enabled=isTxtEnable;
        txtZip.enabled=isTxtEnable;
        btnTotalGrossAmount.enabled=isTxtEnable;
        btnUpdate.enabled=isTxtEnable;
        txtFrontGrossAmout.enabled=isTxtEnable;
        txtBackGrossAmount.enabled=isTxtEnable;
        txtNote.enabled=isTxtEnable;
        _tvNote.editable=isTxtEnable;
        btnTotalGrossAmount.enabled=isTxtEnable;
        txtAppointment.enabled=isTxtEnable;
       
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


#pragma mark photo cropper
-(void) openCropEditor:(UIImage *) image {
    @try{
        PECropViewController *controller = [[PECropViewController alloc] init];
        controller.delegate = self;
        controller.image = image;
        controller.cropAspectRatio = 1;
        
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
        isImageChanged=true;
        
        [dataDictionary setObject:croppedImage forKey:@"sImage"];
        
        CGSize newSize = CGSizeMake(cell.imgView.frame.size.width,cell.imgView.frame.size.height);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [croppedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageObj = (AsyncImageView *)[cell.contentView viewWithTag:4567];
        //        [imageObj.ai stopAnimating];
        imageObj.image = nil;
        [cell.imgView setImage:newImage];
        imageAfterCrop=newImage;
        CALayer *imageLayer = cell.imgView.layer;
        [imageLayer setCornerRadius:6];
        [imageLayer setBorderColor:(__bridge CGColorRef)([UIColor clearColor])];
        [imageLayer setMasksToBounds:YES];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

-(void) cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)btnLinkedIn:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    [self.view endEditing:YES];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    [dropDown hideDropDown:senderBtnReferenceForDropDown];
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
    self.scrollCustomerDetailList.scrollEnabled=true;
    tableheightConst.constant = 108;
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

- (IBAction)btnGoogle:(id)sender {
    ApplicationData *objappData = [[ApplicationData alloc]init];
    [self.view endEditing:YES];
    NSMutableDictionary *sendParamsContact = [[NSMutableDictionary alloc] init];
    [dropDown hideDropDown:senderBtnReferenceForDropDown];
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
    self.scrollCustomerDetailList.scrollEnabled=true;
    tableheightConst.constant = 108;
    sendParamsContact[@"userId"] =[[NSUserDefaults standardUserDefaults] objectForKey:UserId];
    sendParamsContact[@"CompanyId"] =[[NSUserDefaults standardUserDefaults]objectForKey:ComapnyCode];
     [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
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
         }}];
}

- (IBAction)btnTwitter:(id)sender {
    [dropDown hideDropDown:senderBtnReferenceForDropDown];
    [self.view endEditing:YES];
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
    self.scrollCustomerDetailList.scrollEnabled=true;
    tableheightConst.constant = 108;
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
        /* SLComposeViewController *controller = [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeTwitter];
         SLComposeViewControllerCompletionHandler myBlock =
         ^(SLComposeViewControllerResult result){
         if (result == SLComposeViewControllerResultCancelled)
         {
         NSLog(@"Cancelled");
         }
         else
         {
         NSLog(@"Done");
         }
         [controller dismissViewControllerAnimated:YES completion:nil];
         };
         controller.completionHandler =myBlock;
         //Adding the Text to the facebook post value from iOS
         [controller setInitialText:@"Propad"];
         //Adding the URL to the facebook post value from iOS
         // [controller addURL:[NSURL URLWithString:@"http://www.test.com"]];
         [controller addImage:[UIImage imageNamed:@"logo"]];
         
         //Adding the Text to the facebook post value from iOS
         [self presentViewController:controller animated:YES completion:nil];*/
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }}];
}

- (IBAction)btnFacebook:(id)sender {
    [dropDown hideDropDown:senderBtnReferenceForDropDown];
    [self.view endEditing:YES];
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, 108);
    self.scrollCustomerDetailList.scrollEnabled=true;
    tableheightConst.constant = 108;
    ApplicationData *objappData = [[ApplicationData alloc]init];
     [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
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
        SharePhotoAndCommentViewController *second=(SharePhotoAndCommentViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SharePhotoAndCommentViewController"];
        second.socialMediaStr = @"Facebook";
        
        [self.navigationController pushViewController:second animated:YES];
        /*SLComposeViewController *controller = [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeFacebook];
         SLComposeViewControllerCompletionHandler myBlock =
         ^(SLComposeViewControllerResult result){
         if (result == SLComposeViewControllerResultCancelled)
         {
         NSLog(@"Cancelled");
         }
         else
         {
         NSLog(@"Done");
         }
         [controller dismissViewControllerAnimated:YES completion:nil];
         };
         controller.completionHandler =myBlock;
         //Adding the Text to the facebook post value from iOS
         [controller setInitialText:@"Propad"];
         [controller addImage:[UIImage imageNamed:@"logo"]];
         
         
         
         //Adding the URL to the facebook post value from iOS
         // [controller addURL:[NSURL URLWithString:@"http://www.test.com"]];
         //Adding the Text to the facebook post value from iOS
         [self presentViewController:controller animated:YES completion:nil];*/
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
         }}];
    
}

@end
