//
//  PJRadioCell.h
//  DynamicForm
//
//  Created by Bhumesh on 22/01/16.
//  Copyright © 2016 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldTableViewCell.h"
@interface PJRadioCell : FieldTableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *requiredLabel;
@property (strong,nonatomic) NSString *nQueid;
@property (strong,nonatomic) NSNumber *count;
@property (strong,nonatomic)NSMutableArray *arrOptions;
@property (strong,nonatomic)NSMutableArray *selectedOption;
@property (strong,nonatomic)NSString *Type;
- (void)setupRequiredLabelVisibilityIfIsRequired:(BOOL)isRequired;
@property (nonatomic) PJListSelectionOption selectionOption;
@property BOOL isSelected;
@end
