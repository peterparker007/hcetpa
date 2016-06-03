//
//  FieldsViewController.h
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//
#import "PJConstants.h"
#import "PJRadioCell.h"
#import "DropDowncell.h"
#import <UIKit/UIKit.h>
#import "PopUpTableViewController.h"

@interface FieldsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    PJRadioCell *rc;
    DropDowncell *dc;
    
    NSInteger radioTag,count;
    UIButton *selectBtn;
    BOOL IsDropDownSelected;
    int countDropDown;
    NSString *strSelectedDrop;
    NSMutableArray *arrDrop;
    NSMutableDictionary *dicDrop;
    NSMutableArray *aryQuestionsData;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray  *cellDefinition;
@property (nonatomic) NSString *titleString;
@property (nonatomic) NSArray  *sections;
@property (nonatomic) NSMutableArray *aryQuestionsData;

@property (nonatomic)NSNumber *maxRadio;
@property (nonatomic,copy) NSString *seletedStr;
@property (nonatomic, strong) PopUpTableViewController *objPopUpTableController;
-(void)hiddenToggle;


@end
