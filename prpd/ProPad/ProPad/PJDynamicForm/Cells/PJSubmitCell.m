//
//  PJSubmitCell.m
//  DynamicForm
//
//  Created by Bhumesh on 8/21/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "PJSubmitCell.h"
@interface PJSubmitCell ()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@end
@implementation PJSubmitCell


- (void)awakeFromNib {
//    self.submitButton.layer.cornerRadius = 3.0f;
//    self.submitButton.clipsToBounds  = YES;
    self.submitButton.backgroundColor = PJColorBackground;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitAction:(id)sender {
    
    [self.delegate submitAction:self];
}
@end
