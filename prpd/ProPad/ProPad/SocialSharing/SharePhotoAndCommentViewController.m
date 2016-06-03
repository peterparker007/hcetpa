//
//  SharePhotoAndCommentViewController.m
//  FacebookLogin
//
//  Created by Apple on 21/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "SharePhotoAndCommentViewController.h"
#import "Base64.h"
#import "ApplicationData.h"
#import "Cloudinary.h"
#import "ApplicationData.h"
#define CLOUD_API_SECRET @"afDiiECQeIlPaQ3746YRsK45vJM"
#define CLOUD_API_KEY @"349386123898962"
#define CLOUD_NAME @"dycqz5bgj"
#define CLOUD_URL @"cloudinary://349386123898962:afDiiECQeIlPaQ3746YRsK45vJM@dycqz5bgj"
@interface SharePhotoAndCommentViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    BOOL isImagePicked;
    NSString *strPictureUrl;
}
@property (strong, nonatomic) __block CLCloudinary *cloudinary;
@property (strong, nonatomic) __block CLUploader* cloudinaryUploader;
@property (strong, nonatomic) UIAlertView *sharingAlert;

@end

@implementation SharePhotoAndCommentViewController
@synthesize txtViewComment;
@synthesize  socialMediaStr;
@synthesize isSocialShareDone;
@synthesize shareItButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    @try{
    [super viewDidLoad];
        [[ApplicationData sharedInstance] hideLoader];
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.imageView addGestureRecognizer:singleTap];
    self.imageView.userInteractionEnabled=true;
    // Do any additional setup after loading the view.
    self.imageView.layer.cornerRadius = 20.0;
    self.imageView.layer.masksToBounds = YES;
    //    self.shareItButton.hidden = YES;
    txtViewComment.text = @"Add Comment";
    if([socialMediaStr isEqualToString:@"Facebook"]){
        txtViewComment.hidden=true;
    }
    //    self.imageView.image = [UIImage imageNamed:@"user_image_default"];
    self.imageView.image = [UIImage imageNamed:@"logo"];
    isImagePicked=false;
    isSocialShareDone=false;
    self.navigationItem.title = @"Social Share";
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkState) name:@"FBSDKAccessTokenDidChangeNotification" object:nil];
    
    FBSessionTokenCachingStrategy *token=[FBSessionTokenCachingStrategy nullCacheInstance];
    
    [token clearToken];
    

    
    FBSessionTokenCachingStrategy *token1=[FBSessionTokenCachingStrategy new];
    [token1 clearToken];

    
    FBSession *session=[FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    
//    session =NULL;
//    [FBSession setActiveSession:nil];
//    [FBSession renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
//        
//    }];
    ACAccountStore *store = [[ACAccountStore alloc] init];
    NSArray *fbAccounts = [store accountsWithAccountType:[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook]];
    for (ACAccount *fb in fbAccounts) {
        [store renewCredentialsForAccount:fb completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
            
        }];
    }
}

-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self SelectPhoto:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Add Comment"]||[textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}
#pragma mark - Selecting Images
- (IBAction)takePhoto:(id)sender
{
    @try{
        [self removeImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"No Camera with this device" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [notAvailable show];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}



- (IBAction)SelectPhoto:(id)sender
{
    @try{
        [self removeImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            UIAlertView *notAvailable = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"There are no images to pick" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [notAvailable show];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

#pragma mark - Sharing Images
- (IBAction)shareIt:(id)sender
{
   // [[ApplicationData sharedInstance] showLoader];
    @try{
    if([socialMediaStr isEqualToString:@"Twitter"]){
        [self twitterAction];
    }
    if([socialMediaStr isEqualToString:@"LinkedIn"]){
        [self linkedInAction];
    }
    if([socialMediaStr isEqualToString:@"GooglePlus"]){
        [self googlePlusAction];
    }
    if([socialMediaStr isEqualToString:@"Facebook"]){
        strPictureUrl = @"";
        [self facebookAction];
    }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    //    self.sharingAlert = [[UIAlertView alloc]initWithTitle:@"Social Share" message:@"Choose the Social site you need to share." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"FaceBook",@"Twitter",@"LinkedIn",@"GooglePlus", nil];
    //    [self.sharingAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isSocialShareDone==true){
        [self.navigationController popViewControllerAnimated:YES];
    }
    //    if (alertView == self.sharingAlert)
    //    {
    //        if (buttonIndex == 0)
    //        {
    //            NSLog(@"Sharing Canceled by user");
    //        }
    //        if (buttonIndex == 1)
    //        {
    //            [self facebookAction];
    //        }
    //        if (buttonIndex == 2)
    //        {
    //            [self twitterAction];
    //        }
    //        if (buttonIndex == 3)
    //        {
    //            [self linkedInAction];
    //        }
    //        if (buttonIndex == 4)
    //        {
    //            [self googlePlusAction];
    //        }
    //    }
}

#pragma mark -Social Sharing 
- (void)facebookAction
{
    if(isImagePicked){
[[ApplicationData sharedInstance] showLoader];

    CLUploader *uploader = [self cloudinaryUploader];
    CLTransformation *transformation = [CLTransformation transformation];
    [transformation setWidthWithInt: 200];
    [transformation setHeightWithInt: 200];
    [transformation setCrop: @"fill"];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    [uploader upload:pngFilePath options:@{@"sync": @YES}];
//    NSData *imageData;
//        imageData = [NSData dataWithContentsOfFile:pngFilePath];
//    
//        
//    [uploader upload:imageData options:@{@"transformation": transformation}];
        
        
        
        
    }
    else
    [self initiateFacebookShare];
    /*@try{
        SLComposeViewController *facebookShare = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock =
        ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
                [facebookShare dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            else
            {
                isSocialShareDone=true;
                [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Facebook comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
            }
            [facebookShare dismissViewControllerAnimated:YES completion:nil];
            
        };
        facebookShare.completionHandler =myBlock;
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [facebookShare removeAllImages];
        [facebookShare removeAllURLs];
        //Zaptech TODO
         NSString *strPropadUrl = @"https://itunes.apple.com/us/app/propad/id1068100273?mt=8";
      
        if([txtViewComment.text isEqualToString:@"Add Comment"])
            [facebookShare setInitialText: [NSString stringWithFormat:@"%@ \n %@",@"Shared via Propad",strPropadUrl]];
        
        else
            [facebookShare setInitialText:[NSString stringWithFormat:@"%@ \n %@ \n %@", txtViewComment.text,@"Shared via Propad",strPropadUrl]];
        if(isImagePicked){
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
            UIImage *imageToShare = [UIImage imageWithContentsOfFile:pngFilePath];
            //    if(imageToShare==nil || [self isNotNull:imageToShare])
            //        [facebookShare addImage:[UIImage imageNamed:@"logo"]];
            //    else
            
             [facebookShare setInitialText: [NSString stringWithFormat:@"%@ \n %@",@"Shared via Propad",strPropadUrl]];
            //[facebookShare addURL:[NSURL URLWithString:strPropadUrl]];
            [facebookShare addImage:imageToShare];
            // ;
        }
     
            // [facebookShare addURL:[NSURL URLWithString:strPropadUrl]];
        //Adding the Text to the facebook post value from iOS
        
        
        [self presentViewController:facebookShare animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }*/
    
    //    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *strPropadUrl = @"http://216.55.169.45/~propad/master/admin/login.php";
    //    UIImage *imageToShare;
    //    if(isImagePicked){
    //        NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    //        imageToShare = [UIImage imageWithContentsOfFile:pngFilePath];
    //    }
    //    strPropadUrl = [NSString stringWithFormat:@"%@ \n %@",txtViewComment.text,strPropadUrl];
    //    [[ApplicationData sharedInstance] ShareMessageON:SLServiceTypeFacebook image:imageToShare message:strPropadUrl from:self url:@""];
    [[FBSession activeSession ] closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];

    
}

- (void)twitterAction
{
    @try{
        SLComposeViewController *twitterShare = [SLComposeViewController
                                                 composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock =
        ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
                [twitterShare dismissViewControllerAnimated:YES completion:nil];
                return;
            }
            else
            {
                isSocialShareDone=true;
                [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Twitter comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            [twitterShare dismissViewControllerAnimated:YES completion:nil];
        };
        twitterShare.completionHandler =myBlock;
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        [twitterShare removeAllImages];
        [twitterShare removeAllURLs];
        //Zaptech TODO
        NSString *strPropadUrl = @"https://itunes.apple.com/us/app/propad/id1068100273?mt=8";
        if([txtViewComment.text isEqualToString:@"Add Comment"])
            [twitterShare setInitialText: [NSString stringWithFormat:@"%@ \n %@",@"Shared via Propad",strPropadUrl]];
        else
            [twitterShare setInitialText:[NSString stringWithFormat:@"%@ \n %@ \n %@", txtViewComment.text,@"Shared via Propad",strPropadUrl]];
        if(isImagePicked){
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
            UIImage *imageToShare = [UIImage imageWithContentsOfFile:pngFilePath];
            //    if(imageToShare==nil || [self isNotNull:imageToShare])
            //        [twitterShare addImage:[UIImage imageNamed:@"logo"]];
            //    else
            [twitterShare addImage:imageToShare];
        }
        //    [twitterShare addURL:[NSURL URLWithString:strPropadUrl]];
        //Adding the Text to the facebook post value from iOS
        [self presentViewController:twitterShare animated:YES completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    //    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *strPropadUrl = @"http://216.55.169.45/~propad/master/admin/login.php";
    //    UIImage *imageToShare;
    //    if(isImagePicked){
    //        NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    //        imageToShare = [UIImage imageWithContentsOfFile:pngFilePath];
    //    }
    //    strPropadUrl = [NSString stringWithFormat:@"%@ \n %@",txtViewComment.text,strPropadUrl];
    //    [[ApplicationData sharedInstance] ShareMessageON:SLServiceTypeFacebook image:imageToShare message:strPropadUrl from:self url:@""];
    
}

-(void)linkedInAction
{
    
    @try {
        
        NSLog(@"%s","sync pressed2");
        [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, LISDK_W_SHARE_PERMISSION, nil]
                                             state:@"some state"
                            showGoToAppStoreDialog:YES
                                      successBlock:^(NSString *returnState) {
                                          [[ApplicationData sharedInstance] showLoader];
                                          
            CLUploader *uploader = [self cloudinaryUploader];
        CLTransformation *transformation = [CLTransformation transformation];
        [transformation setWidthWithInt: 200];
                [transformation setHeightWithInt: 200];
                                          [transformation setCrop: @"fill"];
                                          
                                          NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                          NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
                                          
                                          NSData *imageData;
                                          if(isImagePicked){
                                              imageData = [NSData dataWithContentsOfFile:pngFilePath];
                                          }
                                          else{
                                              imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);
                                          }
                                          
                                          [uploader upload:imageData options:@{@"transformation": transformation}];
                                          
                                      }
                                        errorBlock:^(NSError *error) {
                                            [[ApplicationData sharedInstance] hideLoader];
                                            
                                            NSLog(@"%s %@","error called! ", [error description]);
                                            //  _responseLabel.text = [error description];
                                        }
         ];
        NSLog(@"%s","sync pressed3");
        return;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}

-(void)googlePlusAction
{
    @try{
        // Code that creates autoreleased objects.
        
        //Zaptech TODO
        NSString *strPropadUrl = @"https://itunes.apple.com/us/app/propad/id1068100273?mt=8";
        NSString *addCommentStr;
        if([txtViewComment.text isEqualToString:@"Add Comment"])
            addCommentStr=  [NSString stringWithFormat:@"%@ \n %@",@"Shared via Propad",strPropadUrl];
        
        else
            addCommentStr = [NSString stringWithFormat:@"%@ \n %@ \n %@", txtViewComment.text,@"Shared via Propad",strPropadUrl];
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *ary;
        
        if(isImagePicked){
            NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
            UIImage *imageToShare = [UIImage imageWithContentsOfFile:pngFilePath];
            
            ary =[[NSArray alloc]initWithObjects:addCommentStr,imageToShare,nil];
        }
        else{
            ary =[[NSArray alloc]initWithObjects:addCommentStr,nil];
            
        }
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:ary applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeMessage,
                                       UIActivityTypeMail,
                                       UIActivityTypePrint,
                                       UIActivityTypeCopyToPasteboard,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo,
                                       UIActivityTypePostToTencentWeibo,
                                       UIActivityTypeAirDrop,
                                       ];
        [activityViewController setValue:addCommentStr forKey:@"subject"];
        activityViewController.excludedActivityTypes = excludeActivities;
        [activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
            NSLog(@"completed");
            isSocialShareDone=true;
            [self.navigationController popViewControllerAnimated:YES];
//             [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Google+" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        //if iPad
        else {
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            // Change Rect to position Popover
            //            UIPopoverPresentationController *popPC = activityViewController.popoverPresentationController;
            //            popPC.barButtonItem = self.navigationItem.rightBarButtonItem;
            //            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            //            [self presentViewController:activityViewController animated:YES completion:nil];
        }
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

#pragma mark - Saving and Removing Images
- (void)saveImage
{
    //NSInteger index = [self.SliderView indexOfItemViewOrSubview:sender];
    // Get an image from the URL below
    UIImage *image =self.imageView.image;
    //NSLog(@"%f,%f",image.size.width,image.size.height);
    // Let's save the file into Document folder.
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    // If you go to the folder below, you will find those pictures
    //NSLog(@"%@",docDir);
    //NSLog(@"saving png");
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data1 writeToFile:pngFilePath atomically:YES];
    NSLog(@"saving image to %@",pngFilePath);
}

- (void)removeImage
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [NSString stringWithFormat:@"%@/UploadingImage.png",docDir];
    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error])
    {
        NSLog(@"Delete failed:%@", error);
    }
    else
    {
        NSLog(@"image removed: %@", fullPath);
    }
}

#pragma mark Cloudinay Methods

- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    [[ApplicationData sharedInstance] hideLoader];
    @try{
        NSString* secure_urlStr = [result objectForKey:@"secure_url"];
        NSLog(@"image url %@",secure_urlStr);

        if([socialMediaStr isEqualToString:@"Facebook"]){
            strPictureUrl = secure_urlStr;
            [[ApplicationData sharedInstance] hideLoader];
            [self initiateFacebookShare];
        }
        else {

        NSLog(@"%s","success called!");
        LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
        NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
        NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
        [text appendString:[NSString stringWithFormat:@",state=\"%@\"",@"some state"]];
        NSLog(@"Response label text %@",text);
        
        NSDictionary *link=[[NSDictionary alloc] initWithObjects:@[@"anyone"] forKeys:@[@"code"] ];
        
        NSDictionary *imageDict =[NSDictionary dictionaryWithObjectsAndKeys:@"Shared via Propad",@"title",@"https://itunes.apple.com/us/app/propad/id1068100273?mt=8",@"submitted-url",@"https://itunes.apple.com/us/app/propad/id1068100273?mt=8",@"description",secure_urlStr,@"submitted-image-url", nil];
        //    [[NSDictionary alloc] initWithObjects:@[secure_urlStr] forKeys:@[@"submitted-image-url"] ];
        
        //Post data to the linkedIn
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //Zaptech TODO
        NSString *strPropadUrl = @"https://itunes.apple.com/us/app/propad/id1068100273?mt=8";
        NSString *addCommentStr;
        if([txtViewComment.text isEqualToString:@"Add Comment"])
            addCommentStr=  [NSString stringWithFormat:@"%@ \n %@",@"Shared via Propad",strPropadUrl];
        
        else
            addCommentStr = [NSString stringWithFormat:@"%@ \n %@ \n %@", txtViewComment.text,@"Shared via Propad",strPropadUrl];
        NSDictionary *post;
        
        post=[[NSDictionary alloc] initWithObjects:@[addCommentStr,imageDict,link] forKeys:@[@"comment",@"content",@"visibility"]];
        
        
        BOOL prettyPrint=YES;
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:post
                                                           options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                             error:&error];
        [[LISDKAPIHelper sharedInstance] apiRequest:@"https://api.linkedin.com/v1/people/~/shares?format=json"
                                             method:@"POST"
                                               body:jsonData
                                            success:^(LISDKAPIResponse *response) {
                                                NSLog(@"success called %@", response.data);
                                                [[ApplicationData sharedInstance] hideLoader];
                                                isSocialShareDone=true;
                                                [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"LinkedIn comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                return ;
                                                
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  [[ApplicationData sharedInstance] hideLoader];
                                                  
                                                  NSLog(@"error called %@", apiError.description);
                                                  dispatch_sync(dispatch_get_main_queue(), ^{
                                                      LISDKAPIResponse *response = [apiError errorResponse];
                                                      NSString *errorText;
                                                      if (response) {
                                                          errorText = response.data;
                                                      }
                                                      else {
                                                          errorText = apiError.description;
                                                      }
                                                  });
                                              }];
        }
        return ;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
    
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
    [[ApplicationData sharedInstance]hideLoader];
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

-(CLCloudinary*) cloudinary {
    if (!_cloudinary) {
        _cloudinary = [[CLCloudinary alloc] init];//WithUrl:@"cloudinary://134456249416914:R7jQYMFDzd3GMN2-VILALNZrcGE@wisethapa"];
        
        [_cloudinary.config setValue:@"dycqz5bgj" forKey:@"cloud_name"];
        [_cloudinary.config setValue:@"349386123898962" forKey:@"api_key"];
        [_cloudinary.config setValue:@"afDiiECQeIlPaQ3746YRsK45vJM" forKey:@"api_secret"];
    }
    return _cloudinary;
}

-(CLUploader*) cloudinaryUploader {
    if(!_cloudinaryUploader) {
        _cloudinaryUploader = [[CLUploader alloc] init:self.cloudinary delegate:self];
    }
    return _cloudinaryUploader;
}


#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isImagePicked=true;
    
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image =selectedImage;
    //    self.shareItButton.hidden = NO;
    [self saveImage];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FB

- (void)initiateFacebookShare {
    
    
    // Create an action
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    
    // Link the object to the action
    FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
    params.action = action;
    
    // If the Facebook app is installed and we can present the share dialog
    if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]){
        
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:[self prepareFBDict:@""]
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
     if (!error) {
        if (result == FBWebDialogResultDialogCompleted) {
                                                              // Handle the publish feed callback
NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
            if ([urlParams valueForKey:@"post_id"]) {
                isSocialShareDone=true;
                [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Facebook comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
                                                              }
                                                          }
                                                      }
                                                  }];
    }
    else{
        
        
        id<FBGraphObject> object = [FBGraphObject graphObjectWrappingDictionary:[self prepareBranchDict]];
        
        // Create an action
        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
        
        // Link the object to the action
        [action setObject:object forKey:@"Share Via Propad"];
        [action setObject:@"true" forKey:@"fb:explicitly_shared"];
        
        FBOpenGraphActionParams *params = [[FBOpenGraphActionParams alloc] init];
        params.action = action;
        params.actionType = @"branchmetrics:create";
        
        // If the Facebook app is installed and we can present the share dialog
        if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
            // Show the share dialog
            [FBDialogs presentShareDialogWithOpenGraphAction:action
                                                  actionType:@"branchmetrics:create"
                                         previewPropertyName:@"Propad"
                                                     handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                         if (!error) {
                                                             isSocialShareDone=true;
                                                             [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Facebook comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                                         }
                                                     }];
        } else {
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:[self prepareFBDict:@""]
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
    if (!error) {
    if (result == FBWebDialogResultDialogCompleted) {
                                                                  // Handle the publish feed callback
        NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                if ([urlParams valueForKey:@"post_id"]) {
                    isSocialShareDone=true;
                    [[[UIAlertView alloc]initWithTitle:@"Posted" message:@"Facebook comment" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    }
    
    
    
}
- (NSDictionary *)prepareFBDict:(NSString *)url {
    
    
    
    
    
    return [[NSDictionary alloc] initWithObjects:@[
                                                   @"https://itunes.apple.com/us/app/propad/id1068100273?mt=8",strPictureUrl
                                                   
                                                   ]
                                         forKeys:@[
                                                   @"link",
                                                   @"picture"
                                                   ]];
    
}
#pragma mark - Facebook

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    switch (state)
    {   case FBSessionStateOpen:
            [self initiateFacebookShare];
            break;
        case FBSessionStateClosed:
            //            [self.progressBar hide];
            break;
        case FBSessionStateClosedLoginFailed:
        {
            UIAlertView *alert_Dialog = [[UIAlertView alloc] initWithTitle:@"Facebook Alert" message:@"Please login again and than try to share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert_Dialog show];
        }
            break;
        default:
            //            [self.progressBar hide];
            break;
    }
}
-(void) checkState{
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"publish_actions"] != NSNotFound) {
        [self initiateFacebookShare];
    } else {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions",
                                nil];
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
        }];
    }
}
- (NSDictionary *)prepareBranchDict {
    return [[NSDictionary alloc] initWithObjects:@[
                                                   @"hii",
                                                   @"hello",
                                                   @"how are you?"
                                                   ]
                                         forKeys:@[
                                                   @"id",
                                                   @"videoId",
                                                   @"link"
                                                   ]];
}

#pragma mark - Helper methods

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

@end
