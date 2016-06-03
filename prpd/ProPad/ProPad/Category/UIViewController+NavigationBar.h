//
//  UIViewController+NavigationBar.h
//  TOPCOD
//
//  Created by ashish on 24/06/15.
//  Copyright (c) 2015 ashish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBar)
- (void)setUpImageBackButton:(NSString *)imageName;
- (void)setUpImageRightButton:(NSString *)imageName;
- (void)setUpImageRightButtonWithText:(NSString *)imageName;
-(void) setMenuIconForSideBar:(NSString*)imageName;
@end
