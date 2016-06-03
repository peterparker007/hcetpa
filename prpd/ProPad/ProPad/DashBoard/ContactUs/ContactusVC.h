//
//  ContactusVC.h
//  ProPad
//
//  Created by Bhumesh on 25/03/16.
//  Copyright © 2016 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface ContactusVC : UIViewController
- (IBAction)EmailTapped:(id)sender;
- (IBAction)CallTapped:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *ContactNo;


@end
