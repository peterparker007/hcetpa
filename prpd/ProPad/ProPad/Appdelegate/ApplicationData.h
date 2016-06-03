

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import "HTTPManager.h"
//#import "zObjects.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
//#import "Contest.h"
//#import "Sponsor.h"
#import "AppConstant.h"


//#import "JImage.h"

@interface UINavigationController (SafePushing)

- (id)navigationLock; ///< Obtain "lock" for pushing onto the navigation controller

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Uses a horizontal slide transition. Has no effect if the view controller is already in the stack. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops view controllers until the one specified is on top. Returns the popped controllers. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops until there's only a single view controller left on the stack. Returns the popped controllers. Has no effect if navigationLock is not the current lock.

@end

@interface ApplicationData : NSObject<UIActionSheetDelegate,MFMailComposeViewControllerDelegate> {
    MBProgressHUD *hud;
    // Share
    NSInteger userIdInt;
    BOOL NewcustomerClick;
}
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property (nonatomic, strong) NSMutableArray *aryVideoList;

+ (ApplicationData *)sharedInstance;
- (BOOL) validateEmail: (NSString *)candidate;
- (BOOL) validateWebURL : (NSString *) weburl;

typedef void (^objectHandler_Completion_Block)(NSMutableDictionary *bodyDict ,int status);

- (void)showLoaderWith:(MBProgressHUDMode)mode;
- (void)showLoader;
- (void)hideLoader;
//- (void) setBackButtonLogo;
- (NSString *)getFormattedStringFrom:(NSDate *)date formatter:(NSString *)format;
- (NSDate *)getFormattedDateFrom:(NSString *)string formatter:(NSString *)format;
-(void)insertUserDataWhenOnline;
-(void)insertClientDataWhenOnline;


- (UIImage *)getThumbImage:(UIImage *)image;

- (void)setTextFieldLeftView:(UITextField *)txtField;

- (void)setButtonUnderLine:(UIButton *)button;

- (BOOL)connectedToNetwork;

- (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width;

- (void)ShareMessageON:(NSString *)service image:(UIImage *)_image message:(NSString *)_message  from:(UIViewController *)controller url:(NSString *)_url;

- (void)setBorderFor:(UIView *)aView;

-(void)getIspayList:(NSDictionary *)dictUserList withcomplitionblock: (objectHandler_Completion_Block)completion;

- (void)playYouTubeVideoInWebView:(UIWebView*)webview youTubeURL:(NSString*)url;

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size;
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;
-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text;
//-(JImage *)getJImage:(NSString *)imgName andFrame:(CGRect)frame;
@end
