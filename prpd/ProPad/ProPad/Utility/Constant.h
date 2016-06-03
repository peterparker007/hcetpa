#import <UIKit/UIKit.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define DEVICE_FRAME [[ UIScreen mainScreen ] bounds ]
#define OS_VER [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define URL_LOGIN           SERVER_URL@"userlogin.php"

#define URL_REGISTER        SERVER_URL@"registeruser.php"
#define URL_NEWSLIST        SERVER_URL@"newslist.php"
#define URL_CONTESTLIST     SERVER_URL@"contestlist.php"
#define URL_EDITUSER        SERVER_URL@"edituser.php"
#define URL_GETNEWSLIST     SERVER_URL@"newslist.php"
#define URL_VIDEOLIST       SERVER_URL@"videolist.php"
#define URL_SUBMITVIDEO     SERVER_URL@"addvideo.php"
#define URL_ADDVOTE         SERVER_URL@"addvotes.php"
#define URL_GETVOTEHISTORY  SERVER_URL@"votelist.php"
#define URL_USERVIDEOLIST   SERVER_URL@"uservideolist.php"
//#define URL_EmailFromUserID SERVER_URL@"newemail.php"

//http://216.55.169.45/~topcod/master/webservices/uservideolist.php
#define kUserid @"image-id"

#define RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BG_COLOR        RGB(33,60,136)

#define RECT(x,y,w,h)  CGRectMake(x, y, w, h)
#define POINT(x,y)     CGPointMake(x, y) 
#define SIZE(w,h)      CGSizeMake(w, h)
#define RANGE(loc,len) NSMakeRange(loc, len)

#define UDSetObject(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetValue(value, key) [[NSUserDefaults standardUserDefaults] setValue:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetBool(value, key) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetInt(value, key) [[NSUserDefaults standardUserDefaults] setFloat:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetFloat(value, key) [[NSUserDefaults standardUserDefaults] setBool:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]

#define UDGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define UDGetValue(key) [[NSUserDefaults standardUserDefaults] valueForKey:(key)]
#define UDGetInt(key) [[NSUserDefaults standardUserDefaults] integerForKey:(key)]
#define UDGetFloat(key) [[NSUserDefaults standardUserDefaults] floatForKey:(key)]
#define UDGetBool(key) [[NSUserDefaults standardUserDefaults] boolForKey:(key)]

#define topDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#define FB_ID @"517480821615042"
#define THUMB_IMAGE_SIZE 100
#define KEYBORAD_HEIGHT_IPHONE 216
#define CELL_HEIGHT 96

#define dt_time_formatter @"MM-dd-yyyy HH:mm:ss"
#define dt_formatter @"mm-dd-yyyy"
#define time_formatter @"HH:mm:ss"
#define Padding 20


#define ComapnyCode @"sCode"
#define UserId @"nUserId"
#define CompanyId @"nCompanyId"
#define EmailId @"sEmail"
#define FirstName @"sFirstName"
#define LastName @"sLastName"
#define Password @"sPassword"
#define YoutubeId @"sYoutubeId"
#define ProfileImage @"sProfileImage"
#define ThumbImageURL @"ThumbImageURL"

#define dictUserInfo @"userInfo"
#define dictGoogleUserInfo @"dictGoogleUserInfo"
#define isRemember  @"isRemember"


#define ContestId   @"nContestId"
#define ContentRule @"sContentRule"
#define ContestDesc @"sContestDesc"
#define ContestImage @"sContestImage"
#define ContestName @"sContestName"
#define ContestPrice @"sContestPrice"
#define Contest_thumbImage @"thumb_sContestImage"

#define arrSponsorDetails @"SponsorDetails"
#define SponsorId @"nSponsorId"
#define SponsorName @"sSponsorName"
#define SponsorUrl @"sSponsorUrl"
#define SponsorDesc @"sSponsorDesc"
#define arrSponsorImages @"sSponsorImages"
#define SponsorImageId @"nSponsorImageId"
#define SponsorImage @"sImage"
#define Sponsor_thumbImage @"thumb_sImage"
#define dDate @"dDate"
typedef enum {
    HTTPRequestTypeGeneral,
    HTTPRequestTypeLogin,
    HTTPRequestTypeForgotPassword,
    HTTPManagerTypeGetContestList,
    HTTPRequestTypeGetVideoList,
    HTTPRequestTypeSignUp,

} HTTPRequestType;

typedef enum {
    jServerError = 0,
	jSuccess,
    jInvalidResponse,
    jNetworkError,
}ErrorCode;
