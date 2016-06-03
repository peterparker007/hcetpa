

#import "ApplicationData.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "AppDelegate.h"
//#import "JImage.h"
#import "FMDBDataAccess.h"
#import "Base64.h"


@implementation UINavigationController (SafePushing)

- (id)navigationLock
{
    return self.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        [self pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToRootViewControllerAnimated:animated];
    return @[];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToViewController:viewController animated:animated];
    return @[];
}

@end


static ApplicationData *applicationData = nil;

@implementation ApplicationData
{
    BOOL userUpdateRemain;
    
}

@synthesize aryVideoList;

- (id)init {
    if(self == [super init]) {
    }
    return self;
}

- (void)initialize {
    // Initilize Default Values Here
    userUpdateRemain=true;
    
    
    
}
//-(JImage *)getJImage:(NSString *)imgName andFrame:(CGRect)frame {
//    JImage *photoImage=[[JImage alloc] init];
//    photoImage.backgroundColor = [UIColor clearColor];
//    photoImage.layer.cornerRadius=6;
//    photoImage.layer.masksToBounds = YES;
//    [photoImage setFrame:frame];
//
//    [photoImage setContentMode:UIViewContentModeScaleToFill];
//
//    [photoImage initWithImageAtURL:[NSURL URLWithString:imgName]];
//
//    return photoImage;
//
//}
+ (ApplicationData*)sharedInstance {
    if (applicationData == nil) {
        applicationData = [[super allocWithZone:NULL] init];
        [applicationData initialize];
        
    }
    return applicationData;
}

#pragma mark - ProgresLoader

- (void)showLoader {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)showLoaderWith:(MBProgressHUDMode)mode {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    hud.mode = mode;
}

- (void)hideLoader {
    if([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [hud removeFromSuperview];
}

#pragma mark DateFormatter
- (NSString *)getFormattedStringFrom:(NSDate *)date formatter:(NSString *)format {
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:format];
    return [dtFormatter stringFromDate:date];
}

- (NSDate *)getFormattedDateFrom:(NSString *)string formatter:(NSString *)format {
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:format];
    return [dtFormatter dateFromString:string];
}

- (void)ShareMessageON:(NSString *)service image:(UIImage *)_image message:(NSString *)_message  from:(UIViewController *)controller url:(NSString *)_url {
    SLComposeViewController *fbController =
    [SLComposeViewController
     composeViewControllerForServiceType:service];
    
    // if([SLComposeViewController isAvailableForServiceType:service])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=
        ^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default: {
                    
                }
                    break;
                case SLComposeViewControllerResultDone: {
                    [self ShowAlertWithTitle:@"Posted" Message:nil];
                }
                    break;
            }};
        
        [fbController addImage:_image];
        [fbController setInitialText:_message];
        //        [fbController addURL:[NSURL URLWithString:_url]];
        [fbController setCompletionHandler:completionHandler];
        [controller presentViewController:fbController animated:YES completion:nil];
    }
    //    else {
    //        [ApplicationData ShowAlertWithTitle:@"Alert" Message:@"Please Login From Settings"];
    //    }
}

- (void)setBorderFor:(UIView *)aView {
    aView.layer.borderWidth = 3;
    aView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width {
    CGSize  textSize = { width, 10000.0 };
    
    //    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]}];
    //
    //    // Values are fractional -- you should take the ceilf to get equivalent values
    //    CGSize adjustedSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    
    /*Change it's Deprecated
     CGSize size = [string sizeWithFont:aFont
     constrainedToSize:textSize
     lineBreakMode:NSLineBreakByWordWrapping];*/
    CGRect textRect = [string boundingRectWithSize:textSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:aFont}
                                           context:nil];
    CGSize size = textRect.size;
    return size.height;
}

- (void)playYouTubeVideoInWebView:(UIWebView*)webview youTubeURL:(NSString*)url {
    url = [url stringByReplacingOccurrencesOfString:@"watch?" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"=" withString:@"/"];
    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0px\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, url,webview.frame.size.width,webview.frame.size.height];
    
    [webview loadHTMLString:html baseURL:nil];
    //http://www.youtube.com/watch?v=betzZgt81ko
}

- (void)setTextFieldLeftView:(UITextField *)txtField {
    txtField.leftViewMode = UITextFieldViewModeAlways;
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    aView.backgroundColor = [UIColor clearColor];
    txtField.leftView = aView;
}

- (void)setButtonUnderLine:(UIButton *)button {
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:[button titleForState:UIControlStateNormal]];
    
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [commentString addAttribute:NSForegroundColorAttributeName value:[button titleColorForState:UIControlStateNormal] range:NSMakeRange(0, [commentString length])];
    [button setAttributedTitle:commentString forState:UIControlStateNormal];
}

#pragma mark Internet Connection
- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
    if (!isconnected) {
        //[self ShowAlertWithTitle:@"Alert" Message:@"Please check internet connection in this device!"];
    }
    return isconnected;
}
// For checking the online Sync
-(void)insertClientDataWhenOnline
{
    
    @try{
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        NSArray *arrRemainingData =[dbAccess CheckRemainingDataForClient];
        __block  NSString *mode;
        
        NSMutableDictionary *dictClientData = [[NSMutableDictionary alloc] init];
        
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection]==true)
            
        {
            //        [[ApplicationData sharedInstance] showLoader];
            
            [arrRemainingData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                
                NSString *strIsAdded = [[arrRemainingData objectAtIndex:idx ] valueForKey:@"IsAdded"];
                if([strIsAdded isEqualToString:[NSString stringWithFormat:@"%d",1]])
                {
                    mode=@"add";
                }
                else if ([strIsAdded isEqualToString:[NSString stringWithFormat:@"%d",2]])
                {
                    mode=@"edit";
                }
                [dictClientData setObject:mode forKey:@"mode"];
                
                
                
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"nMobile"]forKey:@"nMobile"];
                
                [dictClientData setObject: [[NSUserDefaults standardUserDefaults]
                                            stringForKey:@"nUserId"]  forKey:@"nUserId"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sAddress"]  forKey:@"sAddress"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sCity"]  forKey:@"sCity"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sContactType"]  forKey:@"sContactType"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sCurrentlyFinance"]  forKey:@"sCurrentlyFinance"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sCurrentMonthly"]  forKey:@"sCurrentMonthly"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sCustomerStatus"]  forKey:@"sCustomerStatus"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sCustomerType"]  forKey:@"sCustomerType"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sDescisionMaker"]  forKey:@"sDescisionMaker"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sDesireMonthly"]  forKey:@"sDesireMonthly"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sEmail"]  forKey:@"sEmail"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstMake"]  forKey:@"sFirstMake"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstModel"]  forKey:@"sFirstModel"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstName"]  forKey:@"sFirstName"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstStockNumber"]  forKey:@"sFirstStockNumber"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstVehType"]  forKey:@"sFirstVehType"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sFirstYear"]  forKey:@"sFirstYear"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sHearAbout"]  forKey:@"sHearAbout"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sHome"]  forKey:@"sHome"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sImage"]  forKey:@"sImage"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sLastName"]  forKey:@"sLastName"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sMake"]  forKey:@"sMake"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sMiles"]  forKey:@"sMiles"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sNextPayment"]  forKey:@"sNextPayment"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sSecondMake"]  forKey:@"sSecondMake"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sSecondModel"]  forKey:@"sSecondModel"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sSecondStockNumber"]  forKey:@"sSecondStockNumber"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sSecondVehType"]  forKey:@"sSecondVehType"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sSecondYear"]  forKey:@"sSecondYear"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sState"]  forKey:@"sState"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sVinModel"]  forKey:@"sVinModel"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sVinYear"]  forKey:@"sVinYear"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sWork"]  forKey:@"sWork"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"sZip"]  forKey:@"sZip"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"dDate"]  forKey:@"dDate"];
                [dictClientData setObject:[[arrRemainingData objectAtIndex:idx] valueForKey:@"nClientId"]  forKey:@"nClientId"];
                
                NSString *strImage = [NSString stringWithFormat:@"%@",[[arrRemainingData objectAtIndex:idx] valueForKey:@"sImage"]];
                
                
                
                NSData *imageData = [Base64 decode:strImage];
                //  imageObja.image = [UIImage imageWithData:data];
                
                //   NSData *imageData = [dictClientData valueForKey:@"sImage"];
                NSDictionary *parameters=dictClientData;
                
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
                NSString *FileParamConstant = @"sImage";
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
                                           
                                           [hud setHidden:YES];
                                           NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                           
                                           if ([httpResponse statusCode] == 200) {
                                               NSError *errorJson=nil;
                                               NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                                               DLog("%@",responseDict);
                                               //  NSLog(@"responseDict=%@",responseDict);
                                               if([ [NSString stringWithFormat:@"%@", [responseDict valueForKey:@"status"] ] isEqualToString:@"1" ])
                                               {
                                                   [dictClientData setObject:[NSString stringWithFormat:@"%d",0] forKey:@"IsAdded"];
                                                   
                                                   [dbAccess updateclientData:dictClientData];
                                                   //                                           UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Client added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   //                                           alertSuccess.tag = 1;
                                                   //                                           [alertSuccess show];
                                               }
                                               else
                                               {
                                                   
                                                   //                                           UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed to add client" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                   //                                           alertSuccess.tag = 1;
                                                   //                                           [alertSuccess show];
                                               }
                                               DLog("%s","success");
                                               
                                           }
                                           else
                                           {
                                               //                                       UIAlertView *alertSuccess = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Image was not uploaded try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               //                                       alertSuccess.tag = 1;
                                               //                                       [alertSuccess show];
                                           }
                                       }];
                
            }];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}
-(void)insertUserDataWhenOnline
{
    @try{
        FMDBDataAccess *dbAccess = [FMDBDataAccess new];
        NSArray *arrRemainingData=[dbAccess CheckRemainingDataForUser];
        __block  NSString *mode;
        
        AppDelegate *appDelegateTemp = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if([appDelegateTemp checkInternetConnection])
        {
            
            [arrRemainingData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                //     NSString *tempnUserId=[[arrRemainingData objectAtIndex:idx ] valueForKey:@"nUserId"];
                if([[[arrRemainingData objectAtIndex:idx ] valueForKey:@"IsAdded"] isEqualToString:[NSString stringWithFormat:@"%d",1]]  || [[[arrRemainingData objectAtIndex:idx ] valueForKey:@"IsAdded"] isEqualToString:[NSString stringWithFormat:@"%d",0]] )
                {
                    mode=@"add";
                }
                else if ([[[arrRemainingData objectAtIndex:idx ] valueForKey:@"IsAdded"] isEqualToString:[NSString stringWithFormat:@"%d",2]])
                {
                    mode=@"edit";
                }
                NSString *postString = [NSString stringWithFormat:@"sEmail=%@&sPassword=%@&sCode=%@&sFirstName=%@&sLastName=%@&mode=%@&sNewVehicalSales=%@&sUsedVehicalSales=%@",
                                        [[arrRemainingData objectAtIndex:idx ] valueForKey:@"sEmail"],
                                        [[arrRemainingData objectAtIndex:idx ] valueForKey:@"password"],
                                        [[arrRemainingData objectAtIndex:idx ] valueForKey:@"nCompanyId"],
                                        [[arrRemainingData objectAtIndex:idx ] valueForKey:@"sFirstName"],
                                        [[arrRemainingData objectAtIndex:idx ] valueForKey:@"sLastName"],mode,[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sNewVehicalSales"],[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sUsedVehicalSales"]];
                //            [[ApplicationData sharedInstance] showLoaderWith:MBProgressHUDModeIndeterminate];
                HTTPManager *manager = [HTTPManager managerWithURL:KRegisterNewUser];
                [manager setPostString:postString];
                manager.requestType = HTTPRequestTypeSignUp;
                [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict)
                 {
                     NSLog(@"%@",bodyDict);
                     if(bodyDict.count>0)
                         if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                             NSArray *userDetailArr = [bodyDict valueForKey:@"userdetails"];
                             NSDictionary *userDetailDict = [userDetailArr  objectAtIndex:0];
                             userIdInt = [[userDetailDict valueForKey:@"nUserId"] integerValue];
                             NSString *strId = [NSString stringWithFormat:@"%ld",(long)userIdInt];
                             
                             UDSetObject(strId, UserId);
                             FMDBDataAccess *dbAccess = [FMDBDataAccess new];
                             NSMutableDictionary *dict = [NSMutableDictionary new];
                             
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sEmail"]forKey:@"sEmail"];
                             
                             [dict setValue:strId forKey:@"nUserId"];
                             //update nUserId in local Database
                             [dbAccess updateUsernUserId:dict];
                             
                             [dict setValue: [[arrRemainingData objectAtIndex:idx ] valueForKey:@"sFirstName"] forKey:@"sFirstName"];
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sLastName"] forKey:@"sLastName"];
                             
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"password"] forKey:@"password"];
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"nCompanyId"]forKey:@"nCompanyId"];
                             [dict setValue:[NSString stringWithFormat:@"%d",0] forKey:@"IsAdded"];
                             
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sNewVehicalSales"]forKey:@"sNewVehicalSales"];
                             [dict setValue:[[arrRemainingData objectAtIndex:idx ] valueForKey:@"sUsedVehicalSales"]forKey:@"sUsedVehicalSales"];
                             //Update Userdata(Isadded) Local Database
                             userUpdateRemain=false;
                             [dbAccess updateUserData:dict];
                         }
                 }failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
                     //                     [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
                     
                 } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
                     
                 }];
                
            }];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}
#pragma mark Alert
- (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message {
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark Validation Methods

- (BOOL) validateEmail: (NSString *) candidate {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}
- (BOOL) validateWebURL : (NSString *) weburl {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:weburl];
}

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


- (UIImage *)getThumbImage:(UIImage *)image {
    float ratio;
    float delta;
    float px = 100; // Double the pixels of the UIImageView (to render on Retina)
    CGPoint offset;
    CGSize size = image.size;
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContext(CGSizeMake(px, px));
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgThumb;
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView.image;
}



//- (void)zoomToFitMapAnnotations:(MKMapView*)mapView {
//    if([mapView.annotations count] == 0)
//        return;
//    CLLocationCoordinate2D topLeftCoord;
//    topLeftCoord.latitude = -90;
//    topLeftCoord.longitude = 180;
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = 90;
//    bottomRightCoord.longitude = -180;
//
//    for(MapViewAnnotation* annotation in mapView.annotations){
//        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude  );
//        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude -    topLeftCoord.longitude) * 0.5;
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
//    region = [mapView regionThatFits:region];
//    [mapView setRegion:region animated:YES];
//}

-(void)cycleTheGlobalMailComposer
{
    // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}


-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text{
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:label.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){label.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    return ceil(rect.size.height);
}

-(void)getIspayList:(NSDictionary *)dictUserList withcomplitionblock:(objectHandler_Completion_Block)completion

{
    NSString *postString= [NSString stringWithFormat:@"nUserId=%@&nCompanyId=%@",[dictUserList valueForKey:@"userId"],[dictUserList valueForKey:@"CompanyId"]];
    HTTPManager *manager = [HTTPManager managerWithURL:URL_ISpay];
    [manager setPostString:postString];
    manager.requestType = HTTPRequestTypeGeneral;
    [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict)
     {
         
         NSLog(@"%@",bodyDict);
         if(completion)
         {
             completion(bodyDict,1);
             
         }
     }
    failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error)
     {
         [[ApplicationData sharedInstance] hideLoader];
     }
     didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite)
     {
         
     }];
    
    
}

//-(void)starTimeForBanner{
// self.timer =  [NSTimer scheduledTimerWithTimeInterval:[kSponserChangeTime floatValue] target:self selector:@selector(getUserPermissions) userInfo:nil repeats:YES];
//}
//-(void) stopTimer {
//    [self.timer invalidate];
//}
//- (void) getUserPermissions {
//
//    NSString *strUserName = UDGetObject(USERNAME);
//    NSString *strPasword = UDGetObject(PASSWRD);
//    NSString *postString = [NSString stringWithFormat:@"sUserName=%@&sPassword=%@",strUserName,strPasword];
//    HTTPManager *manager = [HTTPManager managerWithURL:URL_LOGIN];
//    [manager setPostString:postString];
//    manager.requestType= HTTPRequestTypeLogin;
//        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
//
//        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
//
//        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//
//        }];
//
//}
@end
