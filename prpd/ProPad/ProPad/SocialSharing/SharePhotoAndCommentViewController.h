//
//  SharePhotoAndCommentViewController.h
//  FacebookLogin
//
//  Created by Apple on 21/11/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <linkedin-sdk/LISDK.h>

@interface SharePhotoAndCommentViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *shareItButton;
@property (weak, nonatomic) IBOutlet UITextView *txtViewComment;
@property (weak, nonatomic) NSString *socialMediaStr;
@property (nonatomic) BOOL isSocialShareDone;

- (IBAction)shareIt:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)SelectPhoto:(id)sender;

@end
