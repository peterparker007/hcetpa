//
//  PJListField.h
//  DynamicForm
//
//  Created by Bhumesh on 8/21/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldTableViewCell.h"
#import "PJListViewController.h"

@interface PJListField : FieldTableViewCell

@property (nonatomic) NSArray               *listItems;
@property (nonatomic) PJListSelectionOption selectionOption;
@property (nonatomic) NSArray               *userSelectedRows;

- (void)setupRequiredLabelVisibility;
@end
