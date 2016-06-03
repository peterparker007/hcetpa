//
//  CustomerListViewController.m
//  ProPad
//
//  Created by Bhumesh on 27/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "CustomerListViewController.h"
#import "DEMOLeftMenuViewController.h"
#import "RESideMenu.h"
#import "UIViewController+NavigationBar.h"

#import "ClientTableViewCell.h"
#import "FMDBDataAccess.h"
#import "HTTPManager.h"
#import "ApplicationData.h"
#import  "AppConstant.h"
#import "CustomerDeatilVC.h"
#import "Constant.h"
#import "Base64.h"
@interface CustomerListViewController ()<RESideMenuDelegate,UITextFieldDelegate>
{
    NSIndexPath *deletedIndexPath;
    BOOL isClientOnline;
    int sortByDateTappedCount;
    int sortByMonthTappedCount;
}
@end

@implementation CustomerListViewController
{
    NSMutableArray *aryClientList;
    NSMutableArray *aryUnsortClientList;
    NSMutableArray *arrCurrentMonth;
    NSArray *searchResults;
    NSString *nUserId;
}
@synthesize imageObj,lblSearchByCustomer;
#pragma mark View life cycle
- (void)viewDidLoad {
    @try{
    [super viewDidLoad];
    self.navigationItem.title =@"Customer List";
        
    nUserId = [[NSUserDefaults standardUserDefaults]
               stringForKey:UserId];
            [self companyServiceForIsPay];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self setMenuIconForSideBar:@"menu"];
    sortByDateTappedCount=0;
    sortByMonthTappedCount=0;
    [_txtSearchVehicleType setUserInteractionEnabled:true];
    [_txtSearchName setUserInteractionEnabled:true];
    
    _txtSearchVehicleType.delegate=self;
    _txtSearchName.delegate=self;
    if(IS_IPAD){
        _txtSearchVehicleType.font = [UIFont systemFontOfSize:16];
        _txtSearchName.font = [UIFont systemFontOfSize:16];
        lblSearchByCustomer.font = [UIFont systemFontOfSize:20];
        btnCurrentMonth.titleLabel.font = [UIFont systemFontOfSize:20];
        btnSortbyDate.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title=@"";
}
-(void)viewWillAppear:(BOOL)animated {
    @try{
        btnSortbyDate.selected=false;
        btnCurrentMonth.selected=false;
        self.navigationItem.title =@"Customer List";
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"IsAddClient"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        aryClientList = [[NSMutableArray alloc] init];
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true)
        {self.navigationItem.leftBarButtonItem.enabled = NO;
            [self showProgressHud];
//        [NSThread detachNewThreadSelector:@selector(showProgressHud) toTarget:self withObject:nil];
          
            [[ApplicationData sharedInstance] showLoader];
            isClientOnline=true;
            
            NSString *postString = [NSString stringWithFormat:@"nUserId=%@",nUserId];
            
            HTTPManager *manager = [HTTPManager managerWithURL:KGetClientList];
            
            [manager setPostString:postString];
            manager.requestType = HTTPRequestTypeGeneral;
            [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
                DLog(@"%@",bodyDict);
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    [self hideProgressHud];
                    NSArray *clientArr = [bodyDict valueForKey:@"clientdetails"];
                    //                aryClientList=(NSMutableArray *)[bodyDict valueForKey:@"clientdetails"];
                    aryClientList = [NSMutableArray arrayWithArray:clientArr];
                    aryUnsortClientList=aryClientList;
                    [dbAccess deleteAllclientDataByUserId:nUserId];
                    @try {
                        [aryClientList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            if ([obj isKindOfClass:[NSMutableDictionary class]]) {
                                
                                if(aryClientList.count>0)
                                {
                                    NSString *strImgObj = [NSString stringWithFormat:@"%@",[obj valueForKey:@"sImage"]];
                                    if(strImgObj.length==0){
                                    }
                                    else{
                                        
                                        dispatch_async(dispatch_get_global_queue(0,0), ^{
                                            NSString *strImage =  (NSString*)strImgObj;
                                            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:strImage]];
                                            
                                            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                                            NSDictionary *oldDict = (NSDictionary *)obj;
                                            if(!(data==nil)){
                                                [newDict addEntriesFromDictionary:oldDict];
                                                
                                                NSString *strImageData = [Base64 encode:data];
                                                [newDict setObject:strImageData forKey:@"sImage"];
                                                [dbAccess insertclientData:newDict];
                                            }
                                            else{
                                                [dbAccess insertclientData:(NSMutableDictionary*)obj];
                                            }
                                        });
                                        
                                        
                                    }
                                }
                                
                            }
                        }];
                    }
                    @catch (NSException *exception) {
              NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
                    }
                    @finally {
                        
                    }
                    
                    
                    [[ApplicationData sharedInstance] hideLoader];
                    [self.tableView reloadData];
                    [NSTimer scheduledTimerWithTimeInterval:0.4 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:FALSE];
                    
                }
                else {
                    self.navigationItem.leftBarButtonItem.enabled = YES;
                     [self hideProgressHud];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Customer List"                                                 message:[bodyDict valueForKey:@"msg"] delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                    [alert show];
                }
               self.navigationItem.leftBarButtonItem.enabled = YES;
            } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                 [self hideProgressHud];
//                [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Customer List" Message:[error localizedDescription]];
                [self hideProgressHud];
                
            } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                
            }];
            //[self hideProgressHud];
        }
        else
        {
            isClientOnline=false;
            aryClientList = [NSMutableArray arrayWithArray:[dbAccess getClient:nUserId]];
            
            aryUnsortClientList=aryClientList;
            if(aryUnsortClientList.count==0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Customer List"                                                 message:@"No record found" delegate:self                                                      cancelButtonTitle:@"Ok"                                                      otherButtonTitles: nil, nil];
                [alert show];
            }
            
            DLog(@"%@",aryClientList);
            [self.tableView reloadData];
            [NSTimer scheduledTimerWithTimeInterval:0.4 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:FALSE];
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

#pragma mark Texfield Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    @try{
        if(textField==_txtSearchName)
        {
            if(_txtSearchName.text.length==0)
            {
                DLog(@"_txtSearchName       done");
                [self onbtnSearchTapped:nil];
                self.isSearch = NO;
            }
        }
        else if (textField==_txtSearchVehicleType)
        {
            if(_txtSearchVehicleType.text.length==0)
            {
                DLog(@"_txtSearchName       done");
                
                [self onbtnSearchTapped:nil];
                self.isSearch = NO;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    @try{
        if(textField==_txtSearchName && self.isSearch)
        {
            
            NSUInteger oldLength = [textField.text length];
            NSUInteger replacementLength = [string length];
            NSUInteger rangeLength = range.length;
            
            NSUInteger newLength = oldLength - rangeLength + replacementLength;
            
            //        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
            if(newLength>0){
                
            }
            else {
                if(self.txtSearchVehicleType.text.length==0){
                    DLog(@"_txtSearchName       done");
                    self.isSearch = NO;
                    [self.tableView reloadData];
                    return YES;
                }
            }
        }
        else if (textField==_txtSearchVehicleType && self.isSearch)
        {
            NSUInteger oldLength = [textField.text length];
            NSUInteger replacementLength = [string length];
            NSUInteger rangeLength = range.length;
            
            NSUInteger newLength = oldLength - rangeLength + replacementLength;
            
            //        BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
            if(newLength>0){
                
            }
            else {
                if(self.txtSearchName.text.length==0){
                    
                    DLog(@"_txtSearchName       done");
                    self.isSearch = NO;
                    [self.tableView reloadData];
                    return YES;
                }
            }
        }
        return YES;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark onsortByDateAction
- (IBAction)onSortByDateTapped:(id)sender {
    @try{
        btnSortbyDate.selected=!btnSortbyDate.selected;
        if(btnSortbyDate.isSelected)
        {
//            NSSortDescriptor *Descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dDate" ascending:NO];
//            
//            aryClientList = (NSMutableArray*)[aryClientList sortedArrayUsingDescriptors:@[Descriptor]];
//            sortByDateTappedCount=1;
//            [self.tableView reloadData];
           
            
        NSMutableArray *SortDateTime = [[aryClientList reverseObjectEnumerator] allObjects];
            aryClientList=SortDateTime;
            
          //  aryClientList =[self sortArrayBasedOndate:aryClientList];
            sortByDateTappedCount=1;
            [self.tableView reloadData];
            
            
        }
        else
        {
            sortByDateTappedCount=2;
            aryClientList=aryUnsortClientList;
            if(btnCurrentMonth.isSelected)
            {
                aryClientList=arrCurrentMonth;
                sortByMonthTappedCount=1;
                
            }
            [self.tableView reloadData];
            
        }   } @catch (NSException *exception) {
            NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
        }
    @finally {
    }
    
}





-(NSMutableArray *)sortArrayBasedOndate:(NSMutableArray *)arraytoSort
{
    NSDateFormatter *fmtDate = [[NSDateFormatter alloc] init];
    [fmtDate setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setDateFormat:@"HH:mm"];
    
    NSComparator compareDates = ^(id string1, id string2)
    {
        NSDate *date1 = [fmtDate dateFromString:string1];
        NSDate *date2 = [fmtDate dateFromString:string2];
        
        return [date1 compare:date2];
    };
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        NSDate *time1 = [fmtTime dateFromString:string1];
        NSDate *time2 = [fmtTime dateFromString:string2];
        
        return [time1 compare:time2];
    };
    
    
   
    
    
    NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"start_date" ascending:YES comparator:compareDates];
    NSSortDescriptor * sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"starts" ascending:YES comparator:compareTimes];
    [arraytoSort sortUsingDescriptors:@[sortDesc1, sortDesc2]];
    
    return arraytoSort;
}
-(NSArray *)descriptorWithArray:(NSArray *)data andKey:(NSString *)key

{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    
    [(NSMutableArray*)data sortUsingDescriptors:sortDescriptors];
    
    return data;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}


#pragma mark table delegate method


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPAD)
    {
        return 120;
    }
    else
    {
        return 90;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomerDeatilVC *detailViewController=(CustomerDeatilVC *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomerDeatilVC"];
    if(aryClientList.count>0)
    {
    detailViewController.dictCustomerDetails=[aryClientList objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else
    {
        [tableView reloadData];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        
        //static NSString *simpleTableIdentifier = @"ClientTableViewCell";
        if(aryClientList.count==0)
            return nil;
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"%ld %ld",(long)indexPath.section,(long)indexPath.row];
        ClientTableViewCell *cell = (ClientTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ClientTableViewCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        
        [self setImageOnCell:cell indexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(void)setImageOnCell:(ClientTableViewCell*)cell indexPath:(NSIndexPath*)indexPath {
    @try{
        if (self.isSearch == YES) {
            NSString *strFirstName= [[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"sFirstName"];
            NSString *strLastName = [[self.arySearchClientList objectAtIndex:indexPath.row] valueForKey:@"sLastName"];
            
            NSString  *strName = [NSString stringWithFormat:@"%@ %@",strFirstName,strLastName];
            cell.lblClientName.text=strName;
            cell.lblModelNumber.text=[[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"sVinModel"];
            cell.lblDate.text=[[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"dDate"];
            
            
//            AsyncImageView *imageObja = (AsyncImageView *)[cell.contentView viewWithTag:indexPath.row+5000];
            
//            if([cell.contentView viewWithTag:indexPath.row+1000]){
//                [imageObja removeFromSuperview];
//                imageObja=nil;
//            }
            
            if(sortByDateTappedCount==1 || sortByDateTappedCount==2){
                if(sortByDateTappedCount==2 && indexPath.row==aryClientList.count)
                    sortByDateTappedCount=0;
                
            }
            if(sortByMonthTappedCount==1 || sortByMonthTappedCount==2){
                if(sortByMonthTappedCount==2 && indexPath.row==aryClientList.count)
                    sortByMonthTappedCount=0;
                
            }
//            if (!imageObja) {
//                
//                AsyncImageView *cell.imgCustomerImage;
                NSURL *url;
                NSString *strImage = [NSString stringWithFormat:@"%@",[[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"sImage"]];
                
                if (isClientOnline) {
                    
                    url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    
                    if([strImage isEqualToString:@""])
                    {
                        cell.imgCustomerImage.image=[UIImage imageNamed:@"no-image"];
//                        [cell.contentView addSubview:cell.imgCustomerImage];
                        //                    [imageObja.ai stopAnimating];
                    }else{
                        cell.imgCustomerImage.imageURL = url;
                        cell.imgCustomerImage.showActivityIndicator=true;
                        
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgCustomerImage.imageURL];
                    }
//                    [imageObja setImageAtURL:url];
                }
                else{
                    /* NSData* data = [[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sImage"];*/
                    NSData* data = [Base64 decode:strImage];
                    cell.imgCustomerImage.image = [UIImage imageWithData:data];
                }
//                cell.imgCustomerImage.frame=cell.imgCustomerImage.frame;
                [cell.imgCustomerImage setTag:indexPath.row+5000];
                //  [cell.contentView addSubview:imageObja];
                if([strImage isEqualToString:@""])
                {
                    cell.imgCustomerImage.image=[UIImage imageNamed:@"no-image"];
//                    [cell.contentView addSubview:cell.imgCustomerImage];
//                    [imageObja.ai stopAnimating];
                }
                else
                {
//                    [cell.contentView addSubview:cell.imgCustomerImage];
//                    [imageObja.ai stopAnimating];
                    //cell.imgCustomerImage.image=imageObja.image;
                }
                CALayer *imageLayer = cell.imgCustomerImage.layer;
                [imageLayer setCornerRadius:6];
                [imageLayer setBorderColor:(__bridge CGColorRef)([UIColor clearColor])];
                [imageLayer setMasksToBounds:YES];
                
//            }
//            else
//            {
//                imageObja.frame = cell.imgCustomerImage.frame;
//            }
//            
        
            
            if ([[[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"sCustomerStatus"]isEqualToString:@
                 "Lost"])
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-red"];
            else if ([[[self.arySearchClientList objectAtIndex:indexPath.row]valueForKey:@"sCustomerStatus"]isEqualToString:@
                      "Sold"])
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-yellow"];
            else
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-blue"];
            
        }
        else {
            // cell.textLabel.text = [Items objectAtIndex:indexPath.row];
            NSString *strFirstName= [[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sFirstName"];
            NSString *strLastName = [[aryClientList objectAtIndex:indexPath.row] valueForKey:@"sLastName"];
            
            NSString  *strName = [NSString stringWithFormat:@"%@ %@",strFirstName,strLastName];
            if(IS_IPAD){
                cell.lblClientName.font = [UIFont systemFontOfSize:18];
                cell.lblModelNumber.font = [UIFont systemFontOfSize:18];
                cell.lblDate.font = [UIFont systemFontOfSize:18];
            }
            cell.lblClientName.text=strName;
            cell.lblModelNumber.text=[[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sVinModel"];
            cell.lblDate.text=[[aryClientList objectAtIndex:indexPath.row]valueForKey:@"dDate"];
            
            
//            AsyncImageView *imageObja = (AsyncImageView *)[cell.contentView viewWithTag:indexPath.row+1000];
//            if([cell.contentView viewWithTag:indexPath.row+5000]){
//                [imageObja removeFromSuperview];
//                imageObja=nil;
//            }
//            if(sortByDateTappedCount==1 || sortByDateTappedCount==2){
//                if(sortByDateTappedCount==2 && indexPath.row==aryClientList.count)
//                    sortByDateTappedCount=0;
//                [imageObja removeFromSuperview];
//                imageObja=nil;
//                
//            }
//            if(sortByMonthTappedCount==1 || sortByMonthTappedCount==2){
//                if(sortByMonthTappedCount==2 && indexPath.row==aryClientList.count)
//                    sortByMonthTappedCount=0;
//                [imageObja removeFromSuperview];
//                imageObja=nil;
//                
//            }
//            if (!imageObja) {
//                AsyncImageView *cell.imgCustomerImage = cell.imgCustomerImage;
                //            AsyncImageView *imageObja = [[AsyncImageView alloc] initWithFrame:CGRectMake(78, 69, 15, 10)];
                NSURL *url;
                NSString *strImage = [NSString stringWithFormat:@"%@",[[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sImage"]];
                
                if (isClientOnline) {
                    url = [NSURL URLWithString:[strImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                   
                    if([strImage isEqualToString:@""])
                    {
                        cell.imgCustomerImage.image=[UIImage imageNamed:@"no-image"];
                        [cell.contentView addSubview:cell.imgCustomerImage];
                        //                    [imageObja.ai stopAnimating];
                    }else{
                        cell.imgCustomerImage.imageURL = url;
                        cell.imgCustomerImage.showActivityIndicator=true;
                        
                        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgCustomerImage.imageURL];
                    }
//                    [imageObja setImageAtURL:url];
                }
                else{
                    NSData* data = [Base64 decode:strImage];
                    cell.imgCustomerImage.image = [UIImage imageWithData:data];
                }
//                imageObja.frame=cell.imgCustomerImage.frame;
                [cell.imgCustomerImage setTag:indexPath.row+1000];
//                [cell.contentView addSubview:imageObja];
                //[imageObja.ai stopAnimating];
                CALayer *imageLayer = cell.imgCustomerImage.layer;
                [imageLayer setCornerRadius:6];
                [imageLayer setBorderColor:(__bridge CGColorRef)([UIColor clearColor])];
                
                [imageLayer setMasksToBounds:YES];
//            }
//            else
//                imageObja.frame = cell.imgCustomerImage.frame;
            
            if ([[[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sCustomerStatus"]isEqualToString:@
                 "Lost"])
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-red"];
            else if ([[[aryClientList objectAtIndex:indexPath.row]valueForKey:@"sCustomerStatus"]isEqualToString:@
                      "Sold"])
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-yellow"];
            else
                cell.imgCustomerStatus.image=[UIImage imageNamed:@"ribbon-blue"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}


//* Removing White space at starting. */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true)
        {
            
            FMDBDataAccess *dbAccess = [FMDBDataAccess new];
            NSString *emailString=[[aryClientList objectAtIndex:indexPath.row] valueForKey:@"sEmail"];
            if([dbAccess deleteclientData:emailString]==true)
            {
                
            }
            
            
            
            //        HTTPManager *manager = [HTTPManager managerWithURL:KDeleteSingleClient delegate:self];
            //        [manager setPostString:postString];
            //
            //        manager.requestType = HTTPRequestTypeDeleteClient;
            //        manager.delegate = self;
            //        ;
            //        [manager startDownload];
            deletedIndexPath = indexPath;
            
        }else
        {
            FMDBDataAccess *dbAccess = [FMDBDataAccess new];
            NSString *emailString=[[aryClientList objectAtIndex:indexPath.row] valueForKey:@"Email"];
            if([dbAccess deleteclientData:emailString])
            {
                [aryClientList removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            [tableView reloadData];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
/*- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
 {
 searchResults = [aryClientList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FirstName contains[cd] %@ OR LastName contains[cd] %@ OR PrimaryChoice contains[cd] %@)",searchText,searchText,searchText]];
 }
 
 -(BOOL)searchDisplayController:(UISearchDisplayController *)controller
 shouldReloadTableForSearchString:(NSString *)searchString
 {
 [self filterContentForSearchText:searchString
 scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
 objectAtIndex:[self.searchDisplayController.searchBar
 selectedScopeButtonIndex]]];
 
 return YES;
 }*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch == YES) {
        return [self.arySearchClientList count];
        
    } else {
        return [aryClientList count];
        
    }
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation

#pragma mark btnAction
- (IBAction)onbtnSearchTapped:(id)sender {
    @try{
        self.strSearchName = self.txtSearchName.text;
        self.strSearchVehicleType = self.txtSearchVehicleType.text;
        
        if ([self.strSearchName isEqualToString:@""] &&
            [self.strSearchVehicleType isEqualToString:@""] ) {
            self.isSearch = NO;
        }
        else {
            self.isSearch = YES;
            NSString* filter = @"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@ || %K CONTAINS[cd] %@";
            
            NSMutableArray *args=[[NSMutableArray alloc]initWithObjects:@"sFirstName",self.strSearchName,@"sLastName",self.strSearchName,@"sMake",self.strSearchVehicleType,@"sVinModel",self.strSearchVehicleType,@"sVinYear",self.strSearchVehicleType,nil];
            
            NSArray *arrSearch=[NSArray arrayWithArray:args];
            self.arySearchClientList =[NSMutableArray arrayWithArray:[aryClientList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:filter argumentArray:arrSearch]]];
            
            DLog(@"%@",self.arySearchClientList);
            self.strSearchName = @"";
            self.strSearchVehicleType = @"";
        }
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}
-(int)getmonth:(NSDate*)date1
{
    NSDate           *today           = date1;
    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *yearComponents  = [currentCalendar components:NSMonthCalendarUnit  fromDate:today];
    int currentMonth  = [yearComponents month];
    NSLog(@"%d",currentMonth);
    return currentMonth;
}
-(NSMutableArray*)getCurrentMonthData
{
    @try{
        NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
        int currentMonth= [self getmonth:[NSDate date]];
        for (int i=0; i<aryClientList.count; i++)
        {
            
            
            NSString *finalDate=[[aryClientList objectAtIndex:i]valueForKey:@"dDate"];
            
            // Prepare an NSDateFormatter to convert to and from the string representation
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            // ...using a date format corresponding to your date
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            // Parse the string representation of the date
            NSDate *date = [dateFormatter dateFromString:finalDate];
            int tempMonth=[self getmonth:date];
            
            
            if(currentMonth==tempMonth)
            {
                [arrTemp addObject:[aryClientList objectAtIndex:i] ];
            }
            
            
        }
        return arrTemp;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(NSString *)getTime:(NSDate*)date1
{
//    NSDate           *today           = date1;
//    NSCalendar       *currentCalendar = [NSCalendar currentCalendar];
//    NSDateComponents *yearComponents  = [currentCalendar components:NSMonthCalendarUnit  fromDate:today];
//    int currentMonth  = [yearComponents month];
//    NSLog(@"%d",currentMonth);
//    return currentMonth;
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss"];
    NSDate *date = date1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *str=[NSString stringWithFormat:@"%ld,%ld",hour,minute];
    return str;
    
    
}
-(NSMutableArray*)getDateTime
{
    @try{
        NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
        int currentMonth= [self getmonth:[NSDate date]];
        for (int i=0; i<aryClientList.count; i++)
        {
            
            
            NSString *finalDate=[[aryClientList objectAtIndex:i]valueForKey:@"dDate"];
            
            // Prepare an NSDateFormatter to convert to and from the string representation
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            // ...using a date format corresponding to your date
            [dateFormatter setDateFormat:@"MM-dd-yyyy"];
            
            // Parse the string representation of the date
            NSDate *date = [dateFormatter dateFromString:finalDate];
            NSString *str=[self getTime:date];
           // int tempMonth=[self getmonth:date];
            [arrTemp addObject:str ];
            
//            if(currentMonth==tempMonth)
//            {
//                [arrTemp addObject:str ];
//            }
            
            
        }
        return arrTemp;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}





- (IBAction)onCurrentMonthOnlyTapped:(id)sender {
    @try{
        btnCurrentMonth.selected=!btnCurrentMonth.selected;
        arrCurrentMonth=[self getCurrentMonthData];
        
        if(btnCurrentMonth.isSelected)
        {
            aryClientList=arrCurrentMonth;
            sortByMonthTappedCount=1;
            [self.tableView reloadData];
        }
        else
        {
            sortByMonthTappedCount=2;
            aryClientList=aryUnsortClientList;
            if(btnSortbyDate.isSelected)
            {
                NSSortDescriptor *Descriptor = [NSSortDescriptor sortDescriptorWithKey:@"dDate" ascending:NO];
                aryClientList = (NSMutableArray*)[aryClientList sortedArrayUsingDescriptors:@[Descriptor]];
                sortByDateTappedCount=1;
            }
            [self.tableView reloadData];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
- (void) showProgressHud
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
}

- (void) hideProgressHud
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
@end
