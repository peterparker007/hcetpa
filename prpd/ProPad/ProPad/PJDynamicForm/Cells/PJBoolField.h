//
//  PJBoolField.h
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FieldTableViewCell.h"

@interface PJBoolField : FieldTableViewCell
@property (nonatomic) id valueWhenOn;
@property (nonatomic) id valueWhenOff;
@property (nonatomic) NSString *textValue;
@end
