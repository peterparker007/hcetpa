//
//  DynamicDisplayCell.h
//  ProPad
//
//  Created by Bhumesh on 11/02/16.
//  Copyright © 2016 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicDisplayCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblQuestion;
@property (strong, nonatomic) IBOutlet UITextField *txtAns;

@end
