//
//  PopUpTableViewController.m
//  SearchTableSample
//
//  Created by Manish on 14/11/13.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import "PopUpTableViewController.h"

@interface PopUpTableViewController ()

@end

@implementation PopUpTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.tableView.tableHeaderView = ({
    //
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 800, 80)];
    //        UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [sampleButton setFrame:CGRectMake(140, 30, 120, 30)];
    //        [sampleButton setTitle:@"Done" forState:UIControlStateNormal];
    //        [sampleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [sampleButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    //         sampleButton.layer.masksToBounds = YES;
    //         sampleButton.layer.cornerRadius = 5.0;
    //        [sampleButton setBackgroundColor:[UIColor blackColor]];
    //        [view addSubview:sampleButton];
    //
    //        view;
    //    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)buttonPressed
{
    UITableViewCell *cell =  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = [self.dataSource[0] objectForKey:@"description"];
    
    [self toggleHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithSource:(NSArray *)sourceArray{
    self.dataSource = sourceArray;
    [self.tableView reloadData];
}

-(void)toggleHidden:(BOOL)toggle{
    int alpha = toggle?0:1;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.alpha = alpha;
    }];
}
-(void)HiddenOnReTapped
{
    int alpha =  !self.tableView.alpha;
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.alpha = alpha;
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.row==0)
        cell.imageView.image=[UIImage imageNamed:@"facebook"];
    else if (indexPath.row==1)
        cell.imageView.image=[UIImage imageNamed:@"twitter-bird"];
    else if (indexPath.row==2)
        cell.imageView.image=[UIImage imageNamed:@"google"];
    else if (indexPath.row==3)
        cell.imageView.image=[UIImage imageNamed:@"copy_link"];

    cell.textLabel.text = self.dataSource[indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectSearchedString:self.dataSource[indexPath.row]];
    
}



@end
