//
//  PJConstants.h
//  DynamicForm
//
//  Created by Bhumesh on 8/20/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PJConfig.h"

#pragma mark - Cell Type
extern NSString *const kPJDescription;
extern NSString *const kPJTextField;
extern NSString *const kPJBoolField;
extern NSString *const kPJDatePicker;
extern NSString *const kPJListField;
extern NSString *const kPJSubmitCell;
extern NSString *const kPJRadioCell;
extern NSString *const kPJDropDownCell;
extern NSString *const kPJHeader;
extern NSString *const kPJHead;



typedef enum PJListSelectionOption {
    PJListSingleSelection,
    PJListMultipleSelection
}PJListSelectionOption;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



