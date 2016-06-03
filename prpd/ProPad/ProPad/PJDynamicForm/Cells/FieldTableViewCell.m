//
//  FieldTableViewCell.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "FieldTableViewCell.h"
#import "Constant.h"
@implementation FieldTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)addBorders {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         static UIView *view = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            view = [UIView new];
            view.frame = self.bounds;
            if(IS_IPAD)
            {
                 view.frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height+1,self.bounds.size.width, 0.5);
            }
            else{
                view.frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height-0.5,self.bounds.size.width, 0.5);
            }
           
            view.backgroundColor = PJColorFieldTitle;
            [self.contentView addSubview:view];
        });
    });
                                                                    
}

- (void)setUp {
    
}

@end
