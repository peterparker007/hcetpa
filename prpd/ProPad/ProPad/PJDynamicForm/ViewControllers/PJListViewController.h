//
//  PJListViewController.h
//  DynamicForm
//
//  Created by Bhumesh on 8/21/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PJListViewControllerDelegate <NSObject>
@optional
- (void)selectedValuesFromList:(NSArray *)selectedListItems fromIndexPath:(NSIndexPath *)indexPath;
@end

@interface PJListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id <PJListViewControllerDelegate> delegate;
@property (nonatomic) NSArray               *listItems;
@property (nonatomic) NSIndexPath           *indexPath;
@property (nonatomic) NSString              *titleString;
@property (nonatomic) PJListSelectionOption selectionOption;
@property (nonatomic) NSMutableArray        *userSelectedRows;

@end
