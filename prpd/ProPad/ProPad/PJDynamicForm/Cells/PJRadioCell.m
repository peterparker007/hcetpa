//
//  PJRadioCell.m
//  DynamicForm
//
//  Created by Bhumesh on 22/01/16.
//  Copyright © 2016 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "PJRadioCell.h"
#import "UILabel+CustomLabel.h"
@implementation PJRadioCell

- (void)awakeFromNib {
    // Initialization code
   
    self.title.textColor     = PJColorFieldTitle;
    self.title.font          = [UIFont systemFontOfSize:PJSizeFieldTitle];
   // self.selectedOption=[[NSMutableArray alloc]init];
    [self.title adjustLableHeightWithFont:[UIFont systemFontOfSize:17]];
    //self.title.numberOfLines=2;
    


}
- (void)setUp {
   
  //  [super addBorders];
    
    self.title.text            = self.titleText;
        [self setupRequiredLabelVisibilityIfIsRequired:self.isRequired];
    
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Public
- (void)setupRequiredLabelVisibilityIfIsRequired:(BOOL)isRequired {
    if (isRequired) {
        self.requiredLabel.hidden = NO;
    } else {
        self.requiredLabel.hidden = YES;
    }
}
@end
