//
//  PopUpTableViewController.h
//  SearchTableSample
//
//  Created by Vivek on 14/11/15.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

-(void)didSelectSearchedString:(NSString *)selectedString;

@end

@interface PopUpTableViewController : UITableViewController{
    id <SearchDelegate> delegate;
}
@property (nonatomic, weak) id <SearchDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
-(void)reloadDataWithSource:(NSArray *)sourceArray;
-(void)toggleHidden:(BOOL)toggle;
-(void)HiddenOnReTapped;
@end
