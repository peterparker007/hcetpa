//
//  CustomView.m
//  DynamicForm
//
//  Created by Bhumesh on 8/26/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "CustomView.h"
#import "PJDynamicForm.h"

@implementation CustomView

- (void)awakeFromNib {
    self.layer.borderWidth  = 0.5f;
    self.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    self.layer.cornerRadius = 3.0f;
    self.clipsToBounds      = YES;
    self.backgroundColor    = [UIColor clearColor];//UIColorFromRGB(0xFFFFFB);
    self.hidden = YES;
}

@end
