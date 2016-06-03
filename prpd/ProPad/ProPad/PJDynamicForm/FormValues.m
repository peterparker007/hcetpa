//
//  FormValues.m
//  DynamicForm
//
//  Created by Bhumesh on 8/26/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FormValues.h"

@implementation FormValues
- (NSString *)description {
    NSString *description = [NSString stringWithFormat:@"Key:%@, Value:%@, ValidityMessage:%@, isValid:%d",self.key,self.value,self.validityMessage,(int)self.isValid];
    return description;
}
@end
