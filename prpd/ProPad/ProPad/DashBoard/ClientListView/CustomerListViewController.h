//
//  CustomerListViewController.h
//  ProPad
//
//  Created by Bhumesh on 27/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface CustomerListViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *btnSortbyDate;
    IBOutlet UIButton *btnCurrentMonth;
}
@property (nonatomic) BOOL isSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITextField *txtSearchName;
@property (nonatomic,retain) IBOutlet UITextField *txtSearchVehicleType;
@property (nonatomic,retain) NSString *strSearchName;
@property (nonatomic,retain) NSString *strSearchVehicleType;
@property (nonatomic,retain) NSMutableArray *arySearchClientList;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchByCustomer;

@property (nonatomic,retain) AsyncImageView *imageObj;
- (IBAction)onSortByDateTapped:(id)sender;
- (IBAction)onbtnSearchTapped:(id)sender;
- (IBAction)onCurrentMonthOnlyTapped:(id)sender;
-(int)getmonth:(NSDate*)date1;
@end
