//
//  DropDowncell.h
//  DynamicForm
//
//  Created by Bhumesh on 27/01/16.
//  Copyright © 2016 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldTableViewCell.h"
@interface DropDowncell : FieldTableViewCell
- (IBAction)ClickOn:(id)sender;
@property (strong,nonatomic)NSMutableArray *arrOptions;
@property (strong,nonatomic) NSString *nQueid;
@property (strong, nonatomic) IBOutlet UIButton *dropDown;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic)  NSMutableArray *arrQuestionIndex;
@property (strong, nonatomic) IBOutlet UILabel *requiredLabel;




@end
