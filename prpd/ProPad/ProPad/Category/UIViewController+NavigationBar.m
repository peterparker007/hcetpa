//
//  UIViewController+NavigationBar.m
//  TOPCOD
//
//  Created by ashish on 24/06/15.
//  Copyright (c) 2015 ashish. All rights reserved.
//

#import "UIViewController+NavigationBar.h"
#import "AppDelegate.h"
#import "RESideMenu.h"
@implementation UIViewController (NavigationBar)
- (void)setUpImageBackButton:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [backButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = NO;
}

- (void)setMenuIconForSideBar:(NSString *)imageName
{
    UIImage *img=[UIImage imageNamed:imageName];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [backButton setBackgroundImage:img forState:UIControlStateNormal];
    backButton.showsTouchWhenHighlighted = YES;
    
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)setUpImageRightButton:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 34, 26)];
    [backButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(rightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barBackButtonItem;
}

- (void)setUpImageRightButtonWithText:(NSString *)imageName
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
    [backButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(-35.0, 0.0, 0.0,-90)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [backButton setTitle:@"Log Out" forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(OnbtnLogOutTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barBackButtonItem;
}

-(void)OnbtnLogOutTapped {
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SignInVC"];
    UINavigationController *naviCtrl = [[UINavigationController alloc]initWithRootViewController:rootController];
    naviCtrl.navigationBar.barTintColor = [UIColor clearColor];
    naviCtrl.navigationBar.translucent = NO;
    
    AppDelegate *appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appdel.window.rootViewController = naviCtrl;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClicked
{
}



@end
