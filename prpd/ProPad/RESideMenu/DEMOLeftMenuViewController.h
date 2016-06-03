//
//  DEMOMenuViewController.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "UsersData.h"
@interface DEMOLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
     UsersData *objUser;
}
+(DEMOLeftMenuViewController *)shareInstance;
-(void) setLeftmenuItems:(NSInteger)tag;
@end
