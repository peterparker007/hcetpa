//
//  DescriptionViewController.m
//  DynamicForm
//
//  Created by Bhumesh on 8/20/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [self initWithNibName:@"DescriptionViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.initialValue != nil) {
    self.textView.text      = self.initialValue;
    }
    self.textView.textColor = PJColorFieldValue;
    self.title = self.titleString;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.delegate passValue:self.textView.text forIndexPath:self.indexPath ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
