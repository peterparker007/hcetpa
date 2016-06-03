//
//  DropDowncell.m
//  DynamicForm
//
//  Created by Bhumesh on 27/01/16.
//  Copyright © 2016 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "DropDowncell.h"
@interface DropDowncell ()<UIActionSheetDelegate>






@end
@implementation DropDowncell
@synthesize dropDown;
- (void)awakeFromNib {
    // Initialization code
    self.title.textColor     = PJColorFieldTitle;
    self.title.font          = [UIFont systemFontOfSize:PJSizeFieldTitle];
}
- (void)layoutSubviews {
   // [super addBorders];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUp {
    
//    [super addBorders];
    
    self.title.text            = self.titleText;
    self.arrQuestionIndex=self.arrQuestionIndex;
    [self setupRequiredLabelVisibilityIfIsRequired:self.isRequired];
    
    
}
- (void)setupRequiredLabelVisibilityIfIsRequired:(BOOL)isRequired {
    if (isRequired) {
        self.requiredLabel.hidden = NO;
    } else {
        self.requiredLabel.hidden = YES;
    }
}
- (IBAction)ClickOn:(id)sender {
    
    UIButton*btn = (UIButton*)sender;
  [self.delegate ClickOn:btn];
    
}
@end
