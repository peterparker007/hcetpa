//
//  CustomerDetailTVC.h
//  ProPad
//
//  Created by pradip.r on 7/30/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CustomerDetailTVC : UITableViewCell
@property (nonatomic,retain) IBOutlet AsyncImageView *imgView;
@property (nonatomic,retain) IBOutlet UIButton *btnBrower;
@property (nonatomic,retain) IBOutlet UIButton *btnCustomerType;
@property (weak, nonatomic) IBOutlet UIImageView *imgCustomerImage;

@end
