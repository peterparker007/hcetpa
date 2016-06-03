//
//  AddClientSectionTwoTVC.h
//  ProPad
//
//  Created by pradip.r on 7/30/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClientSectionTwoTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtMake;
@property (weak, nonatomic) IBOutlet UITextField *txtModel;
@property (weak, nonatomic) IBOutlet UITextField *txtVehicleMilaege;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicle;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (weak, nonatomic) IBOutlet UILabel *lblVehicleMileage;
@property (weak, nonatomic) IBOutlet UILabel *lblYear;
@property (weak, nonatomic) IBOutlet UILabel *lblMake;
@property (weak, nonatomic) IBOutlet UILabel *lblModel;



@end
