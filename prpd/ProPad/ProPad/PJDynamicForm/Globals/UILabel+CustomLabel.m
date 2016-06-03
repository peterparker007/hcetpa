//
//  UILabel+CustomLabel.m
//  ProPad
//
//  Created by nirzar on 2/19/16.
//  Copyright © 2016 Zaptech. All rights reserved.
//

#import "UILabel+CustomLabel.h"

@implementation UILabel (CustomLabel)

-(void)adjustLableHeightWithFont:(UIFont *)font
{
    self.text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    CGSize constraintSize = CGSizeMake(236, MAXFLOAT);
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: font}];
    CGRect rectSize = [attributedText boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y,rectSize.size.width,rectSize.size.height);
    
    // set the font to the minimum size anyway
    [self setNeedsLayout];
}

@end
