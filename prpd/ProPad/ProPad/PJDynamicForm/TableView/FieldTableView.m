//
//  FieldTableView.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FieldTableView.h"
@implementation FieldTableView


- (void)awakeFromNib {
    [self registerNib:[UINib nibWithNibName:kPJTextField bundle:nil] forCellReuseIdentifier:kPJTextField];
    [self registerNib:[UINib nibWithNibName:kPJDescription bundle:nil] forCellReuseIdentifier:kPJDescription];
    [self registerNib:[UINib nibWithNibName:kPJDatePicker bundle:nil] forCellReuseIdentifier:kPJDatePicker];
    [self registerNib:[UINib nibWithNibName:kPJBoolField bundle:nil] forCellReuseIdentifier:kPJBoolField];
    [self registerNib:[UINib nibWithNibName:kPJListField bundle:nil] forCellReuseIdentifier:kPJListField];
    [self registerNib:[UINib nibWithNibName:kPJSubmitCell bundle:nil] forCellReuseIdentifier:kPJSubmitCell];
    [self registerNib:[UINib nibWithNibName:kPJRadioCell bundle:nil] forCellReuseIdentifier:kPJRadioCell ];
    [self registerNib:[UINib nibWithNibName:kPJDropDownCell bundle:nil] forCellReuseIdentifier:kPJDropDownCell];
    
    [self registerNib:[UINib nibWithNibName:kPJHeader bundle:nil] forCellReuseIdentifier:kPJHeader];
    [self registerNib:[UINib nibWithNibName:kPJHead bundle:nil] forCellReuseIdentifier:kPJHead];
    
    
   
}

@end

