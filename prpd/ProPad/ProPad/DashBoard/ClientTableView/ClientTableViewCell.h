//
//  ClientTableViewCell.h
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"


@interface ClientTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgCustomerStatus;
@property (strong, nonatomic) IBOutlet AsyncImageView *imgCustomerImage;
@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblModelNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgContentBackground;
@end
