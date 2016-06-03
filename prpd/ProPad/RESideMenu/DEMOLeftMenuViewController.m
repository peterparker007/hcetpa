//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "CustomerListViewController.h"
#import "DashboardViewController.h"
#import "AddClientSectionOneViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UpdateUserProfileVC.h"
#import "Constant.h"
#import "FMDatabase.h"
#import "FMDBDataAccess.h"
#import "Base64.h"
#import "ContactusVC.h"
#import <FacebookSDK/FacebookSDK.h>
@interface DEMOLeftMenuViewController ()
{
    NSArray *arrTitles;
    NSArray *arrImages;
    BOOL isProfileImageSet;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMOLeftMenuViewController

+(DEMOLeftMenuViewController *)shareInstance {
    static DEMOLeftMenuViewController *objLeftMenu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objLeftMenu = [[self alloc] init];
        // Do any other initialisation stuff here
    });
    return objLeftMenu;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isProfileImageSet=false;
    arrTitles = @[@"DashBoard", @"Customer List", @"New Customer", @"Profile", @"Contact Us",@"Logout"];
    arrImages = @[@"Dashboard", @"customerlist-menu", @"newcustomer-menu", @"Profile",@"about-us",@"log-out"];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
}
-(void)viewWillAppear:(BOOL)animated
{
    FMDBDataAccess *dbAccess = [FMDBDataAccess new];
    isProfileImageSet=true;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 172, 115)];
  //  UIImageView *imageView=[[UIImageView alloc]init];
    AsyncImageView *imageView=[[AsyncImageView alloc]init];
    if(IS_IPAD)
    {
        imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(110, 25, 90 , 90)];
    }
    else
    {
        imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(50, 25, 80, 80)];
    }

   
    dispatch_async(dispatch_get_global_queue(0,0), ^{
         NSURL *url;
        NSString *strImage = [[NSUserDefaults standardUserDefaults] objectForKey:@"CompanyImage"];
        url = [NSURL URLWithString:strImage];
       // imageView.image
        //imageView.imageURL = url;
       
        
        
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImage]];
        dispatch_async(dispatch_get_main_queue(), ^{
//            imageView.image = [UIImage imageWithData:imageData];
             imageView.imageURL = url;
        });
        imageView.showActivityIndicator=true;
        
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView.imageURL];
    });
    imageView.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:imageView];

    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:self.tableView];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setLeftmenuItems:indexPath.row];
}

-(void) setLeftmenuItems:(NSInteger)tag
{
    if(self.sideMenuViewController==nil)
    {
        return;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                @"Main" bundle:nil];
    
    switch (tag) {
        case 0: {
            
            DashboardViewController *objDashboardViewController=(DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objDashboardViewController]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 1: {
            CustomerListViewController *second=(CustomerListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }
            break;
        case 2: {
            AddClientSectionOneViewController *second=(AddClientSectionOneViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionOneViewController"];
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 3: {
            UpdateUserProfileVC *second=(UpdateUserProfileVC *)[storyboard instantiateViewControllerWithIdentifier:@"UpdateUserProfileVC"];
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 4: {
            ContactusVC *second=(ContactusVC *)[storyboard instantiateViewControllerWithIdentifier:@"ContactusVC"];
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:second]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
            
            
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact Us"                                                   message:@"Coming soon." delegate:self
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles: nil, nil];
//            [alert show];
        }
            break;
        case 5: {
            AppDelegate *appSharedObj = (AppDelegate *)[[UIApplication sharedApplication]delegate];
           [appSharedObj.checkBoxTag removeAllObjects];
        [appSharedObj.dataDictionary removeAllObjects];
        [appSharedObj.dataDictionary1 removeAllObjects];
            
            
             objUser = [UsersData sharedManager];
            [objUser.dictUsersData removeAllObjects];
            NSLog(@"Logged out of facebook");
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                NSString* domainName = [cookie domain];
                NSRange domainRange = [domainName rangeOfString:@"facebook"];
                if(domainRange.length > 0)
                {
                    [storage deleteCookie:cookie];
                }
            }
            appSharedObj.NewcustomerClick=true;
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isUserLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            LoginViewController *second=(LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:second];
            
            appSharedObj.window.rootViewController=navVC;
        }
            break;
            
            
        default:
            break;
    }
}



#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPAD)
        return 70;
    else
        return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        if(IS_IPAD)
        {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.textLabel.text = arrTitles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:arrImages[indexPath.row]];
    
    if(indexPath.row>0)
    {
        
        UIView *whiteDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 1, cell.bounds.size.width, 1)];
        whiteDivider.backgroundColor = [UIColor whiteColor];
        whiteDivider.alpha=0.5;
        [cell.contentView addSubview:whiteDivider];
    }
    if (indexPath.row==arrImages.count-1) {
        UIView *whiteDivider;
        if(IS_IPAD)
        {
            whiteDivider = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height+20, cell.bounds.size.width, 1)];
        }
        else
        {
            whiteDivider = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-2, cell.bounds.size.width, 1)];
        }
        whiteDivider.backgroundColor = [UIColor whiteColor];
        whiteDivider.alpha=0.5;
        [cell.contentView addSubview:whiteDivider];
        
    }
    
    //    UIView *whiteDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 5, cell.bounds.size.width, 1)];
    //    whiteDivider.backgroundColor = [UIColor whiteColor];
    //    [cell.contentView addSubview:whiteDivider];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


//- (UIView *)tableView : (UITableView *)tableView viewForHeaderInSection : (NSInteger) section {
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    imgView.image = [UIImage imageNamed:@"sponsor"];
//
//    return imgView;
//}
@end
