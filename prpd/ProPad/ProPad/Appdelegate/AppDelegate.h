//
//  AppDelegate.h
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableDictionary *dataDictionary1;
    
 
 
}
@property (nonatomic,assign) BOOL NewcustomerClick;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *databaseName;
@property (nonatomic,strong) NSString *databasePath;
@property (nonatomic,strong) NSMutableDictionary *dataDictionary1;
@property (nonatomic,strong)NSMutableDictionary *dicDropDown;
@property (nonatomic,strong)NSMutableArray  *checkBoxTag;
@property (nonatomic,strong)NSMutableArray  *arrBackupData;
@property (nonatomic,strong)NSMutableDictionary *dataDictionary;
@property (nonatomic,assign)   BOOL isBack;
@property (nonatomic,assign) BOOL isNext;
@property (nonatomic,assign) int selectionCount;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,assign) int CurQuid;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void) createAndCheckDatabase;

-(NSString *)databasePath;
-(BOOL)checkInternetConnection;

@end

