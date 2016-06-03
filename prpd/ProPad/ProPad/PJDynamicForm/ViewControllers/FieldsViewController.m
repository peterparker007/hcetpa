//
//  FieldsViewController.m
//  DynamicForm
//
//  Created by Bhumesh on 8/19/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "DescriptionViewController.h"
#import "PJListViewController.h"
#import "FieldsViewController.h"
#import "PJDynamicForm.h"
#import "PJRadioCell.h"
#import "DropDowncell.h"
#import "AddClientSectionFourViewController.h"
#import "UsersData.h"
#import "Constant.h"
#import "Head.h"
#import "AppDelegate.h"

@interface FieldsViewController ()<FieldTableViewCell,DescriptionViewControllerDelegate,PJListViewControllerDelegate,SearchDelegate> {
    BOOL needsShowConfirmation;
    NSMutableArray *cellObjects;
    //NSMutableDictionary *dataDictionary1;
    UsersData *objcUser;
    NSString *radio,*textField,*dropDown,*datePicker;
    NSInteger pos,Newtags;
    NSString *ansRadio,*ansTextField, *ansDropDown, *ansDatePicker;
    NSArray *data1, *data2,*data3;
    NSMutableArray *arrdropDownStr;
    NSMutableArray *checkBoxTag;
    NSMutableDictionary *pickedDict;
    NSMutableArray *pickedArray;
    NSMutableDictionary *dataDictionary;
    NSMutableArray *arrRadioData;
    NSInteger count1;
    NSInteger countDrop;
    NSInteger countDate;
    NSUserDefaults *defaults;
    
}
@property (nonatomic) NSString *selectedDate;
@property (nonatomic,copy)NSString *dropDownstr;

@end

@implementation FieldsViewController{
    NSMutableArray *optionbtn;
    NSMutableArray *checkbtn;
    UIButton *senderBtnReferenceForDropDown;
    
}
@synthesize cellDefinition,aryQuestionsData;

- (instancetype)init
{
    self = [super init];
    pos=0;
    if (self) {
        self = [self initWithNibName:@"FieldsViewController" bundle:[NSBundle mainBundle]];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    // NSMutableArray *data1 =[[NSMutableArray alloc]init];
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
  //  NSLog(@"%@",appdel.arrBackupData);
    NSLog(@"%@",[appdel.checkBoxTag description]);
    NSLog(@"%@",[appdel.dataDictionary description]);
    
    NSString *temp=[appdel.dataDictionary objectForKey:@"nQueid"];
    NSString *temp1=[appdel.dataDictionary objectForKey:@"sCorrectAns"];
    IsDropDownSelected=false;
    NSString *temp2=[appdel.dataDictionary objectForKey:@"sType"];
    data1 = [[NSArray alloc]init];
    data2 = [[NSArray alloc]init];
    data3 = [[NSArray alloc]init];
    data1 = [temp componentsSeparatedByString:@","];
    data2 = [temp1 componentsSeparatedByString:@","];
    data3 = [temp2 componentsSeparatedByString:@","];
    if(data2.count>0)
        [self SetArryQuestionsData];
    NSLog(@"%@",data1);
    NSLog(@"%@",data2);
    NSLog(@"%@",data3);
    self.title = self.titleString;
    // AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //appdel.isBack=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    arrDrop=[[NSMutableArray alloc]init];
    dicDrop=[[NSMutableDictionary alloc]init];
    arrRadioData=[[NSMutableArray alloc]init];
    pickedArray=[[NSMutableArray alloc]init];
    pickedDict=[[NSMutableDictionary alloc]init];
    countDropDown=0;
    countDate=0;
    countDrop=0;
    Newtags=0;
    //dataDictionary1=[[NSMutableDictionary alloc]init];
    arrdropDownStr=[[NSMutableArray alloc]init];
    
    objcUser=[UsersData sharedManager];
    checkBoxTag=[[NSMutableArray alloc]init];
    UIImageView *teAsyncImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [teAsyncImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = teAsyncImageView;
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    optionbtn=[[NSMutableArray alloc]init];
    checkbtn=[[NSMutableArray alloc]init];
    rc=[[PJRadioCell alloc]init];
    dc=[[DropDowncell alloc]init];
    dc.dropDown=[[UIButton alloc]init];
    rc.selectedOption=[[NSMutableArray alloc]init];
    dc.arrOptions=[[NSMutableArray alloc]init];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    cellObjects               = [NSMutableArray new];
    needsShowConfirmation     = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Helvetica Neue" size:28],NSFontAttributeName, nil]];
    self.title = self.titleString;
    // self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: PJColorFieldTitle};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self loadPopUpTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hidePopUps)
                                                 name:@"hidePopUp"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SaveDateVal:)
                                                 name:@"callSaveData"
                                               object:nil];
    
    
}
-(void)SetArryQuestionsData
{
    for (int i=0;i<aryQuestionsData.count;i++){
        FieldTableViewCell *cell = [[aryQuestionsData objectAtIndex:i]objectForKey:@"cellDefinitions"];
        
        if([cell isKindOfClass:[PJDatePicker class]])
        {
            //PJDatePicker *textCell = [cell subviews];
            
            if ([[[aryQuestionsData objectAtIndex:i]valueForKey:@"sAnsType"]isEqualToString:@"CalendarDate"] && [data1[i-1] isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
                
                [[aryQuestionsData objectAtIndex:i]setObject:data2[i-1] forKey:@"textValue"];
                }
            
            
            
           
                
        }
            
        
        if([cell isKindOfClass:[PJTextField class]])
        {
          //  PJTextField *textCell = (PJTextField *)notification.object;
            
            if ([[[aryQuestionsData objectAtIndex:i]valueForKey:@"sAnsType"]isEqualToString:@"text"] && [data1[i-1] isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
                [[aryQuestionsData objectAtIndex:i]setObject:data2[i-1] forKey:@"textValue"];
            }
            
        }
        
        if([cell isKindOfClass:[DropDowncell class]])
        {
            //  PJTextField *textCell = (PJTextField *)notification.object;
            
            if ([[[aryQuestionsData objectAtIndex:i]valueForKey:@"sAnsType"]isEqualToString:@"DropDown"] && [data1[i-1] isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
                [[aryQuestionsData objectAtIndex:i]setObject:data2[i-1] forKey:@"textValue"];
            }
            
        }
    }
    NSLog(@"%@",aryQuestionsData);
}
-(void) SaveDateVal :(NSNotification *) notification{
    PJDatePicker *cellPicker = (PJDatePicker *)notification.object;
    for (int i=0;i<aryQuestionsData.count;i++){
        FieldTableViewCell *cell = [[aryQuestionsData objectAtIndex:i]objectForKey:@"cellDefinitions"];
        
    if([cell isKindOfClass:[PJDatePicker class]])
    {
        PJDatePicker *textCell = cellPicker;
        
        NSLog(@"%@", textCell.textField.text);
       // textCell.textField.text
        if ([[[aryQuestionsData objectAtIndex:i]valueForKey:@"sAnsType"]isEqualToString:@"CalendarDate"] && [textCell.nQueid isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
            if (![textCell.textField.text isEqualToString:@""] && ![textCell.textField.text isEqualToString:@"(null)"]) {
                [[aryQuestionsData objectAtIndex:i]setObject:textCell.textField.text forKey:@"textValue"];
            }
            if (pickedArray.count>0 && pickedArray.count-1>=[textCell.nQueid intValue]) {
            [pickedArray replaceObjectAtIndex:[textCell.nQueid intValue] withObject:textCell.textField.text];
            }else
                [pickedArray addObject:textCell.textField.text];
            
        }
        
    }
        if([cell isKindOfClass:[PJTextField class]])
        {
            PJTextField *textCell = (PJTextField *)notification.object;

            NSLog(@"%@", textCell.textField.text);
            // textCell.textField.text
            if ([textCell.nQueid isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
                if (![textCell.textField.text isEqualToString:@""] && ![textCell.textField.text isEqualToString:@"(null)"]) {
                    [[aryQuestionsData objectAtIndex:i]setObject:textCell.textField.text forKey:@"textValue"];
                }
                
            }

        }

    }
    [self saveData];
}

-(void) hidePopUps{
    [self.objPopUpTableController toggleHidden:YES];
    IsDropDownSelected=false;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self saveData];
     AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdel.arrBackupData =  aryQuestionsData;
    self.navigationItem.title=@"";
    [super viewDidAppear:animated];
    UsersData *dataCheak=[UsersData sharedManager];
    dataCheak.strCheak=@"YES";
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    UsersData *dataCheak=[UsersData sharedManager];
    
    
    
    
    self.navigationItem.title  = @"New Customer";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sections.count > 0) {
        PJSection *sectionElement = self.sections[section];
        return sectionElement.elements.count;
    } else {
        return cellDefinition.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sections.count > 0) {
        return self.sections.count;
    } else {
        return 1;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.sections.count > 0) {
        PJSection *sectionElement = self.sections[section];
        PJHeader *header          = [PJHeader new];
        // header.title.text         = sectionElement.name;
        return header;
    } else {
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.objPopUpTableController)
    {
        [self.objPopUpTableController toggleHidden:YES];
        IsDropDownSelected=false;
    }
    
    
    FieldTableViewCell *cell = (FieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.view endEditing:YES];
    if ([cell isKindOfClass:[PJListField class]]) {
        PJListViewController *vc   = [[PJListViewController alloc]init];
        PJListField *modelListCell = (PJListField *)cell;
        vc.titleString             = modelListCell.titleText;
        vc.delegate                = self;
        vc.indexPath               = modelListCell.indexPath;
        vc.listItems               = modelListCell.listItems;
        vc.selectionOption         = modelListCell.selectionOption;
        if (modelListCell.userSelectedRows != nil) {
            vc.userSelectedRows        = [modelListCell.userSelectedRows mutableCopy];
        }
        
        [self showViewController:vc sender:nil];
        
    } else if ([cell isKindOfClass:[PJDescription class]]) {
        
        DescriptionViewController *vc = [[DescriptionViewController alloc]init];
        vc.titleString                = cell.titleText;
        vc.delegate                   = self;
        vc.initialValue               = cell.value;
        vc.indexPath                  = cell.indexPath;
        [self showViewController:vc sender:nil];
    }
    else if ([cell isKindOfClass:[DropDowncell class]]) {
        
        
        //        vc.titleString                = cell.titleText;
        //        vc.delegate                   = self;
        //        vc.initialValue               = cell.value;
        //        vc.indexPath                  = cell.indexPath;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellTypeForIndexPath:indexPath forTableView:tableView];
    
    UIButton *btn;
    if([cell isKindOfClass:[PJRadioCell class]])
    {
        PJRadioCell *textCell          = (PJRadioCell *)cell;
        if(!textCell)
            textCell   = [[PJRadioCell alloc] init];
        PJRadioCell *modelListCell = (PJRadioCell *)cell;
        textCell.selectedOption=rc.selectedOption;
        [self Radiobtnselect];
        
        NSLog(@"%@",  textCell.selectedOption);
        
        
        //    cell.isSelected = [textCell.selectedOption containsObject:modelListCell.titleText]? YES : NO;
        //    if (cell.isSelected) {
        //        [btn setImage:[UIImage imageNamed:@"check"] ];
        //        // set image of selected
        //    }
        //    else{
        //        [cell.btnSelection setImage:[UIImage imageNamed:@"uncheck"] ];
        //        // set unselected image
        //    }
    }
    return cell;
}


#pragma mark - TableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(IS_IPAD)
    {
        return PJFieldHeight+50;
    }
    return PJFieldHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sections.count > 0) {
        return 0;
    } else {
        return 0;
    }
}

#pragma mark - Private Method
- (UITableViewCell *)cellTypeForIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView {
    FieldTableViewCell *definition;
    if (self.sections.count > 0) {
        PJSection *sectionElement = self.sections[indexPath.section];
        definition                = sectionElement.elements[indexPath.row];
    } else {
        definition                = cellDefinition[indexPath.row];
    }
    
    NSString *cellType             = [self cellTypeForDefinitionClass:[definition class]];
    //Initialize common properties of all Cells
    
    FieldTableViewCell *cell       = [tableView dequeueReusableCellWithIdentifier:cellType];
    cell.key                       = definition.key;
    cell.titleText                 = definition.titleText;
    cell.isRequired                = definition.isRequired;
    cell.indexPath                 = indexPath;
    cell.delegate                  = self;
    cell.defaultValue              = definition.defaultValue;
    cell.backgroundColor = PJColorBackground;
    
    [self segragateValuesByTypeInCell:cell forDefinition:definition];
   // [self pushCellInArray:cell];
    return cell;
}

- (void)pushCellInArray:(FieldTableViewCell *)cell {
    //Check if cell is already inserted. The cell is unique by it's indexPath
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"indexPath == %@", cell.indexPath];
    NSArray *filteredArray = [cellObjects filteredArrayUsingPredicate:predicate];
    id firstFoundObject    = nil;
    firstFoundObject       = filteredArray.count > 0 ? filteredArray.firstObject : nil;
    //If there the cellObjects array has no cell of indexPath then insert the cell into array
    if (firstFoundObject == nil) {
        [cellObjects addObject:cell];
    }
}

- (void)segragateValuesByTypeInCell:(id)cell forDefinition:(id)definition {
    Class class = [cell class];
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    // NSLog(@"%@",[appdel.dataDictionary1 description]);
    
    if (class == [PJTextField class] ) {
        PJTextField *modelTextField    = (PJTextField *)definition;
        PJTextField *textCell          = (PJTextField *)cell;
        textCell.nQueid=modelTextField.nQueid;
        
        for (int i=0; i<data1.count; i++) {
            if ([textCell.nQueid isEqualToString: data1[i]]) {
                if([textCell.textField.text isEqualToString:@""])
                    textCell.textField.text=data2[i];
            }
        }
        textCell.placeholderText       = modelTextField.placeholderText;
        textCell.inputType             = modelTextField.inputType;
        
        [textCell setUp];
        
    } else if (class == [PJBoolField class]) {
        
        PJBoolField *boolField = (PJBoolField *)cell;
        PJBoolField *modelBoolField = (PJBoolField *)definition;
        boolField.nQueid=modelBoolField.nQueid;
        boolField.valueWhenOn       = modelBoolField.valueWhenOn;
        boolField.valueWhenOff      = modelBoolField.valueWhenOff;
        [boolField setUp];
        
    } else if (class == [PJDescription class]) {
        
        PJDescription *descriptionCell  = (PJDescription *)cell;
        PJDescription *modelDescriptionCell = (PJDescription *)definition;
        descriptionCell.placeholderText = modelDescriptionCell.placeholderText;
        [descriptionCell setUp];
        
    } else if (class == [PJDatePicker class]) {
        
        PJDatePicker *datePicker1   = (PJDatePicker *)cell;
        PJDatePicker *modelDatePicker = (PJDatePicker *)definition;
        datePicker1.nQueid=modelDatePicker.nQueid;
        datePicker1.tag=[datePicker1.nQueid intValue];
        datePicker1.PickedDate=modelDatePicker.PickedDate;
        datePicker1.titleText=modelDatePicker.titleText;
        //datePicker1.textField.text=[objcUser.dataDictionary1 valueForKey:@"1"];
//        if(![datePicker1.textField.text isEqualToString:@""])
//            datePicker1.textField.text=@"";
        datePicker1.datePickerMode  = modelDatePicker.datePickerMode;
        datePicker1.placeholderText = modelDatePicker.placeholderText;
        [datePicker1 setUp];

        for (int i=0; i<aryQuestionsData.count; i++) {
            if (i==0) {
                continue;
            }
            if ([[[aryQuestionsData objectAtIndex:i]valueForKey:@"sAnsType"]isEqualToString:@"CalendarDate"] && [datePicker1.nQueid isEqualToString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"nQueid"]]) {
                    datePicker1.textField.text = [[aryQuestionsData objectAtIndex:i]valueForKey:@"textValue"];
                
            }

            
        }
        
    } else if (class == [PJListField class]) {
        
        PJListField *listField      = (PJListField *)cell;
        PJListField *modelListField = (PJListField *)definition;
        listField.listItems         = modelListField.listItems;
        listField.selectionOption   = modelListField.selectionOption;
        listField.defaultValue      = modelListField.defaultValue;
        [listField setUp];
        
    } else if (class == [PJSubmitCell class]) {
        
    } else if(class == [PJRadioCell class]) {
        
        Newtags=Newtags+1000;
        
        PJRadioCell *modelTextField    = (PJRadioCell *)definition;
        PJRadioCell *textCell          = (PJRadioCell *)cell;
        textCell.count= modelTextField.count;
        textCell.nQueid=modelTextField.nQueid;
        
        textCell.arrOptions=modelTextField.arrOptions;
        textCell.Type=modelTextField.Type;
        for(int i=0;i<[textCell.count intValue];i++)
        {
            [self setbutton:i pjtableviewcell:cell];
        }
        // textCell.inputType             = modelTextField.inputType;
        [textCell setUp];
        for (int i=0; i<data1.count; i++) {
            if ([textCell.nQueid isEqualToString: data1[i] ]) {
                if ([data3[i] isEqualToString:@"radio"]) {
                    [self Radiobtnselect];
                    
                }
            }
            
        }
        for (int i=0; i<data1.count; i++) {
            if ([textCell.nQueid isEqualToString: data1[i] ]) {
                if ([data3[i] isEqualToString:@"checkBox"]) {
                    [self Checkboxselect];
                    if(![rc.selectedOption containsObject:data2[i]])
                        [rc.selectedOption addObject:data2[i]];
                }
            }
            
        }
    }
    else if(class == [DropDowncell class])
    {
        
        DropDowncell *modelTextField    = (DropDowncell *)definition;
        DropDowncell *textCell          = (DropDowncell *)cell;
        NSLog(@"%ld",(long)textCell.indexPath.row);
        
        textCell.arrOptions=modelTextField.arrOptions;
        textCell.nQueid=modelTextField.nQueid;
     //   textCell.dropDown.tag=(int)textCell.indexPath.row;
       // dc.dropDown.tag=(int)textCell.indexPath.row;
        textCell.dropDown.tag=[textCell.nQueid intValue] ;
        dc.dropDown.tag= [textCell.nQueid intValue];
        
        [dc.dropDown addTarget:self action:@selector(ClickOn:) forControlEvents:UIControlEventTouchUpInside];
        dc.arrOptions=textCell.arrOptions;
        self.objPopUpTableController.dataSource =dc.arrOptions;
        self.objPopUpTableController.tableView.frame = CGRectMake(0,self.view.frame.size.height-100, self.tableView.frame.size.width, dc.frame.size.height+50);
        [textCell setUp];
        [textCell.dropDown setTitle:@"select" forState:UIControlStateNormal];
        for (int i=0; i<data2.count; i++) {
            if ([textCell.nQueid isEqualToString:data1[i] ])  {
                AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
                NSString *str=[appdel.dicDropDown valueForKey:textCell.nQueid];
                if([str length]>0)
                {
                    [textCell.dropDown setTitle:str forState:UIControlStateNormal];
                    _dropDownstr=str;
                   // [arrdropDownStr addObject:str];
                    [dicDrop setObject:str forKey:[NSString stringWithFormat:@"%ld",dc.dropDown.tag]];
                }
                //                [textCell.dropDown setTitle:data2[i] forState:UIControlStateNormal];
            }
            
        }
        
    }
    else if(class == [PJHeader class])
    {
        PJHeader *modelTextField    = (PJHeader *)definition;
        PJHeader *textCell          = (PJHeader *)cell;
        textCell.title.text=modelTextField.title.text;
    }
    else if(class ==[Head class])
    {
        
    }
    
    
}
-(void)setbutton:(int)xpos pjtableviewcell:(PJRadioCell *)tblcell
{
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    PJRadioCell *textCell          = (PJRadioCell *)tblcell;
    UIButton *btn;
    btn=[[UIButton alloc]initWithFrame:CGRectMake(xpos*95, 30, 95, 25)];
    
    //   btn.tag=2000+xpos;
    btn.tag=Newtags+pos;
    pos=pos+1;
    
    [btn setTitle:[@" " stringByAppendingString:textCell.arrOptions[xpos]] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont: [UIFont boldSystemFontOfSize:PJSizeFieldValue]];
    if([textCell.Type isEqualToString:@"Checkbox"])
    {
        
        [checkbtn addObject:btn];
        NSString *strTag=[NSString stringWithFormat:@"%ld",btn.tag];
        if ([appdel.checkBoxTag containsObject:strTag]) {
            [btn setSelected:YES];
        }
        else
        {
            [btn setSelected:NO];
        }
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if([rc.selectedOption containsObject:btn.titleLabel.text])
        {
            btn.selected=YES;
        }
        [btn setImage:[UIImage imageNamed:@"unSelect"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Select"] forState:UIControlStateSelected];
    }
    else if([textCell.Type isEqualToString:@"Radio"])
    {
        [optionbtn addObject:btn];
        [btn addTarget:self action:@selector(RadiobtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setImage:[UIImage imageNamed:@"RadiounSelect"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"RadioSelect"] forState:UIControlStateSelected];
    }
    [textCell.contentView addSubview:btn];
    // [appdel.checkBoxTag removeAllObjects];
}
- (void)RadiobtnClicked:(id)sender
{
    [self.view endEditing:YES];
    UIButton *btn = (UIButton*)sender;
    NSInteger temp=btn.tag/1000;
    for  (id BtnSelect in optionbtn   ) {
        UIButton *btnComp = (UIButton*)BtnSelect;
        NSInteger temp2=btnComp.tag/1000;
        if(temp == temp2)
        {
            if (btn.tag==btnComp.tag) {
                
                btnComp.selected=YES;
                _seletedStr=btnComp.titleLabel.text;
                if(![arrRadioData containsObject:_seletedStr])
                {
                    [arrRadioData addObject:btnComp.titleLabel.text];
                }
                
            }else {
                btnComp.selected=NO;
                if([arrRadioData containsObject:btnComp.titleLabel.text])
                {
                    [arrRadioData removeObject:btnComp.titleLabel.text];
                    // [arrRadioData addObject:btnComp.titleLabel.text];
                }
            }
        }
        
    }
     [self saveData];
    
    
}
- (void)Radiobtnselect
{
    // UIButton *btn = (UIButton*);
    
    for (int i=0; i<data2.count; i++) {
        for  (id BtnSelect in optionbtn   ) {
            UIButton *btnComp = (UIButton*)BtnSelect;
            
            if ([btnComp.titleLabel.text isEqualToString:data2[i]]) {
                btnComp.selected=YES;
                btnComp.enabled=YES;
                if(![arrRadioData containsObject:btnComp.titleLabel.text])
                {
                    [arrRadioData addObject:btnComp.titleLabel.text];
                }
                _seletedStr=btnComp.titleLabel.text;
            }
        }
    }
    
}

-(void)Checkboxselect
{
    
    for  (id BtnSelect in checkbtn   ) {
        UIButton *btnComp = (UIButton*)BtnSelect;
        for (int i=0; i<data2.count; i++) {
            if (btnComp.titleLabel.text == data2[i]) {
                
                btnComp.selected=YES;
                btnComp.enabled=YES;
                if(![rc.selectedOption containsObject:data2[i]])
                    [rc.selectedOption addObject:data2[i]];
            }
            
        }
    }
    
    //     AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //    for  (id BtnSelect in checkbtn   ) {
    //        UIButton *btnComp = (UIButton*)BtnSelect;
    //    for (int i=0; i<(int)appdel.checkBoxTag; i++) {
    //
    //
    //        btnComp.selected=YES;
    //        btnComp.enabled=YES;
    //        [rc.selectedOption addObject:data2[i]];
    //    }
    //    }
}
- (void)btnClicked:(id)sender
{
    [self.view endEditing:YES];
    //[checkBoxTag addObject:sender];
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    UIButton *btn = (UIButton*)sender;
    btn.selected=!btn.selected;
    if (btn.selected) {
        [appdel.checkBoxTag addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    else
    {
        [appdel.checkBoxTag removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag]];
    }
    if(btn.isSelected==TRUE)
    {
        if(![rc.selectedOption containsObject:[btn.titleLabel text]])
            [rc.selectedOption addObject:[btn.titleLabel text]];
        else
        [rc.selectedOption removeObject:[btn.titleLabel text]];
    }
      [self saveData];
    
}
- (NSString *)cellTypeForDefinitionClass:(Class)class {
    NSString *cellType;
    if (class == [PJTextField class] ) {
        cellType = kPJTextField;
        return cellType;
    } else if (class == [PJBoolField class]) {
        cellType = kPJBoolField;
        return cellType;
    } else if (class == [PJDatePicker class]) {
        cellType = kPJDatePicker;
        return cellType;
    } else if (class == [PJDescription class]) {
        cellType = kPJDescription;
        return cellType;
    } else if (class == [PJListField class]) {
        cellType = kPJListField;
        return cellType;
    } else if (class == [PJSubmitCell class]) {
        cellType = kPJSubmitCell;
        return cellType;
    }else if(class == [PJRadioCell class])
    {
        cellType= kPJRadioCell;
        return cellType;
    }
    else if(class ==[DropDowncell class])
    {
        cellType= kPJDropDownCell;
        return cellType;
    }
    else if(class ==[PJHeader class]) {
        cellType= kPJHeader;
        return cellType;
    }
    else if(class ==[Head class])
    {
        cellType=@"Head";
        return cellType;
    }
    else
    {
        return nil;
    }
    
}

#pragma mark - FieldTableViewCellDelegate

- (void)submitAction:(id)sender {
    [self.view endEditing:YES];
    
    //[self saveData];
    
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    //    if ((appdel.isNext==NO)) {
    //        [self nextBtn];
    //    }
    //else{
    
    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:NULL];
    AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
    fourth.dataDictionary = [[NSMutableDictionary alloc] init];
    fourth.dataDictionary = appdel.dataDictionary ;
    [self.navigationController pushViewController:fourth animated:NO];
    
    // }
    
}

#pragma mark POPUP Delegate
#pragma mark - Delegate

-(void)loadPopUpTable{
    //    UIEdgeInsets buttonEdges = UIEdgeInsetsMake(0, 5, 0, -5);
    self.objPopUpTableController = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
    if(IS_IPAD)
    {
        self.objPopUpTableController.tableView.frame = CGRectMake(0, dc.frame.origin.y, self.view.frame.size.width, 200);
    }
    else
        self.objPopUpTableController.tableView.frame = dc.frame;
    // CGRectMake(0, 0, dc.frame.size.width+150, dc.frame.size.height);
    self.objPopUpTableController.delegate=self;
    self.objPopUpTableController.view.layer.zPosition = 100;
    
    //    self.objPopUpTableController.delegate = self;
    [self.view addSubview:self.objPopUpTableController.tableView];
    [self.objPopUpTableController toggleHidden:YES];
    
    self.objPopUpTableController.tableView.layer.borderWidth = 2;
    self.objPopUpTableController.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
}
-(void)hiddenToggle
{
    [self.objPopUpTableController toggleHidden:YES];
    
}
-(void)ClickOn:(UIButton*)btn
{
    
    selectBtn = btn;
    strSelectedDrop=[NSString stringWithFormat:@"%ld",(long)btn.tag];
    DropDowncell *textCell = (DropDowncell *)[[btn superview] superview] ;
    if([textCell isKindOfClass:[DropDowncell class]])
        NSLog(@"%@",textCell.arrOptions);
    [self.objPopUpTableController reloadDataWithSource:textCell.arrOptions];
    
    // UIButton *btn=(UIButton*)sender;
    if(!IsDropDownSelected)
    {
        [self.objPopUpTableController toggleHidden:NO];
        IsDropDownSelected=true;
    }
    else
    {
        [self.objPopUpTableController toggleHidden:true];
        IsDropDownSelected=false;
    }
    
    
    [self.view endEditing:YES];
    
    //CGRectMake(0, btn.frame.origin.y+300, 100, 100);
    
    
    //CGRectMake(btn.frame.origin.x, btn.frame.origin.y, dc.frame.size.width+150, dc.frame.size.height+100);
    
    //    UIButton *btn;
    //    btn=nil;
    //    if(dropDown)
    //    {
    //        [dropDown removeFromSuperview];
    //    }
    //    senderBtnReferenceForDropDown=nil;
    //    senderBtnReferenceForDropDown = (UIButton*)sender;
    //    CGFloat f = 70;
    //    dropDown=[[NIDropDown alloc]showDropDownMenu:senderBtnReferenceForDropDown dropDownheight:&f dropDownarr:dc.arrOptions dropDowndirection:@"down"];
    //    dropDown.delegate=self;
    //
    //
    //    dc.frame = CGRectMake(0, 0, dc.frame.size.width+150, dc.frame.size.height+450);
}

#pragma mark - Search Delegate
-(void)didSelectSearchedString:(NSString *)selectedString{
    
    UIButton *btn= (UIButton *)dc.dropDown;
    [self.objPopUpTableController toggleHidden:YES];
    [selectBtn setTitle:selectedString forState:UIControlStateNormal];
    IsDropDownSelected=false;
    [dicDrop setObject:selectedString forKey:strSelectedDrop];
   
    
    //    dc.dropDown.backgroundColor = [UIColor redColor];
    //    dc.dropDown.layer.zPosition=10000;
    //    [dc.dropDown setTitle:selectedString forState:UIControlStateNormal];
    //senderBtnReferenceForDropDown.titleLabel.text=selectedString
    
    _dropDownstr=selectedString;
    for (int i=0;i<aryQuestionsData.count;i++){
        FieldTableViewCell *cell = [[aryQuestionsData objectAtIndex:i]objectForKey:@"cellDefinitions"];
        if ([cell isKindOfClass:[DropDowncell class]])
        {
            DropDowncell *textCell          = (DropDowncell *)cell;
            if ([textCell.nQueid isEqualToString:strSelectedDrop]) {
                    [[aryQuestionsData objectAtIndex:i]setObject:selectedString forKey:@"textValue"];
                }
        }
        
    }
    
    [arrdropDownStr addObject:selectedString];
     [self saveData];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //  [self.delegate controlActivated:self];
    
}
#pragma mark - DescriptionViewControllerDelegate
- (void)passValue:(id)value forIndexPath:(NSIndexPath *)indexPath {
    FieldTableViewCell *definition = cellObjects[indexPath.row];
    definition.value = value;
    
    NSLog(@"definition value %@",definition.value);
    [definition setUp];
}

#pragma mark - PJListViewControllerDelegate
- (void)selectedValuesFromList:(NSArray *)selectedListItems fromIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"SELECTED %@",selectedListItems);
    if (selectedListItems != nil && selectedListItems.count != 0) {
        PJListField *cell     = (PJListField *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSMutableArray *valueOfObjects = [NSMutableArray new];
        
        for (NSNumber *number in selectedListItems) {
            [valueOfObjects addObject:cell.listItems[number.integerValue]];
        }
        
        cell.value            = valueOfObjects;
        cell.userSelectedRows = selectedListItems;
        [cell setUp];
    } else {
        PJListField *cell     = (PJListField *)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.value            = nil;
        cell.userSelectedRows = selectedListItems;
        [cell setUp];
    }
    
}


#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        needsShowConfirmation = NO;
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        needsShowConfirmation = YES;
    }
}

#pragma mark -Saving Data

-(void)saveData
{
    count1=0;
    countDrop=0;
    countDate=0;
    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"%d",appdel.isBack);
    //    if (appdel.isBack==NO) {
    
    
    NSString *resNquid;
    __block NSString *resAns;
    NSString *type;
    resNquid=@"";
    
    resAns=@"";
    type=@"";
    NSLog(@"%@",_seletedStr);
    
    NSLog(@"%@",[dicDrop description]);
    
    NSMutableArray *formValues = [NSMutableArray new];
    
    for (int i=0;i<aryQuestionsData.count;i++){
        FieldTableViewCell *cell = [[aryQuestionsData objectAtIndex:i]objectForKey:@"cellDefinitions"];
        
        if (![cell isKindOfClass:[PJSubmitCell class]]) {
            if ([cell isKindOfClass:[DropDowncell class]])
            {
                DropDowncell *textCell          = (DropDowncell *)cell;
                
                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
                type = [type stringByAppendingString:@"dropDown"];
                type = [type stringByAppendingString:@","];
                resNquid = [resNquid stringByAppendingString:@","];
                
                if([_dropDownstr length]>0)
                {
                    resAns=[resAns stringByAppendingString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"textValue"]];
                }
                else{
                    resAns=[resAns stringByAppendingString:@""];}
                resAns=[resAns stringByAppendingString:@","];
                countDrop=countDrop+1;
            }
            else if([cell isKindOfClass:[PJRadioCell class]])
            {
                
                PJRadioCell *textCell          = (PJRadioCell *)cell;
                
                
                if([textCell.Type isEqualToString:@"Radio"])
                {
                    
                    resNquid = [resNquid stringByAppendingString:textCell.nQueid];
                    type = [type stringByAppendingString:@"radio"];
                    type = [type stringByAppendingString:@","];
                    resNquid = [resNquid stringByAppendingString:@","];
                    if(_seletedStr.length>0)
                    {
                        if(arrRadioData.count>count1)
                        {
                            resAns=[resAns stringByAppendingString:arrRadioData[count1]];
                            
                        }
                    }
                    else
                        resAns=[resAns stringByAppendingString:@""];
                    resAns=[resAns stringByAppendingString:@","];
                    count1=count1+1;
                }
                else
                {
                    resNquid = [resNquid stringByAppendingString:textCell.nQueid];
                    NSLog(@"%@",textCell.arrOptions);
                    type = [type stringByAppendingString:@"checkBox"];
                    type = [type stringByAppendingString:@","];
                    resNquid = [resNquid stringByAppendingString:@","];
                    
                  
                    
                    
                    
                    
                    
                    for(id obj  in rc.selectedOption)
                    {
                        NSString *strData = [NSString stringWithFormat:@"%@",obj];
                        NSString *trimmedString =[strData stringByTrimmingCharactersInSet:
                                                  [NSCharacterSet whitespaceCharacterSet]];
                        NSArray *items = [trimmedString componentsSeparatedByString:@" "];
                        if([textCell.arrOptions containsObject:items[0]])
                        {
                        
                            resAns=[resAns stringByAppendingString:obj];
                        }
                        //resAns=[resAns stringByAppendingString:@" "];
                    }
                    resAns=[resAns stringByAppendingString:@","];
                }
            }
            else if([cell isKindOfClass:[PJTextField class]])
            {
                PJTextField *textCell          = (PJTextField *)cell;
                
                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
                type = [type stringByAppendingString:@"textField"];
                type = [type stringByAppendingString:@","];
                resNquid = [resNquid stringByAppendingString:@","];
                if([[[aryQuestionsData objectAtIndex:i]valueForKey:@"textValue"] length]>0)
                    resAns=[resAns stringByAppendingString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"textValue"]];
                else
                    resAns=[resAns stringByAppendingString:@""];
                resAns=[resAns stringByAppendingString:@","];
            }
            else if([cell isKindOfClass:[PJDatePicker class]])
            {
                
                PJDatePicker *textCell          = (PJDatePicker *)cell;
                
                
              
                
                
                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
                type = [type stringByAppendingString:@"datePicker"];
                type = [type stringByAppendingString:@","];
                resNquid = [resNquid stringByAppendingString:@","];
                resAns=[resAns stringByAppendingString:[[aryQuestionsData objectAtIndex:i]valueForKey:@"textValue"]];
                
                //resAns=[resAns stringByAppendingString:textCell.textField.text];
                //                if([cell.value length]>0)
                //                    resAns=[resAns stringByAppendingString:cell.value];
                //                else
                //                    resAns=[resAns stringByAppendingString:@""];
                resAns=[resAns stringByAppendingString:@","];
                countDate=countDate+1;
            }
            
        }
    }
    NSLog(@"%@",resNquid);
    NSLog(@"%@",resAns);
    if ([resNquid length] > 0) {
        resNquid = [resNquid substringToIndex:[resNquid length] - 1];
    }
    if ([resAns length] > 0) {
        resAns = [resAns substringToIndex:[resAns length] - 1];
    }
    if ([type length] > 0) {
        type = [type substringToIndex:[type length] - 1];
    }
    
    
    dataDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                    [NSString  stringWithFormat:@"%@",resNquid], @"nQueid",
                    [NSString stringWithFormat:@"%@",resAns], @"sCorrectAns",
                    [NSString stringWithFormat:@"%@",type], @"sType",nil];
    NSLog(@"%@",dataDictionary);
    
    
    // AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    appdel.dataDictionary
    =[NSMutableDictionary dictionaryWithObjectsAndKeys:
      [NSString  stringWithFormat:@"%@",resNquid], @"nQueid",
      [NSString stringWithFormat:@"%@",resAns], @"sCorrectAns",
      [NSString stringWithFormat:@"%@",type], @"sType",nil];
    appdel.dicDropDown=dicDrop;
    NSLog(@"%@",appdel.dataDictionary);
    
    NSString *temp=[appdel.dataDictionary objectForKey:@"nQueid"];
    NSString *temp1=[appdel.dataDictionary objectForKey:@"sCorrectAns"];
    IsDropDownSelected=false;
    NSString *temp2=[appdel.dataDictionary objectForKey:@"sType"];
    
    data1 = [[NSArray alloc]init];
    data2 = [[NSArray alloc]init];
    data3 = [[NSArray alloc]init];
    data1 = [temp componentsSeparatedByString:@","];
    data2 = [temp1 componentsSeparatedByString:@","];
    data3 = [temp2 componentsSeparatedByString:@","];
    
    
    
    // appdel.isBack=YES;
    //}
    // isNext=YES;
    
}




//-(void)nextBtn
//{
//    NSString *resNquid;
//    NSString *resAns;
//    NSString *type;
//    resNquid=@"";
//    resAns=@"";
//    type=@"";
//    NSLog(@"%@",_seletedStr);
//    NSLog(@"%@",[dicDrop description]);
//    NSMutableArray *formValues = [NSMutableArray new];
//    for (FieldTableViewCell *cell in cellObjects){
//        if (![cell isKindOfClass:[PJSubmitCell class]]) {
//            if ([cell isKindOfClass:[DropDowncell class]])
//            {
//                DropDowncell *textCell          = (DropDowncell *)cell;
//                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
//                type = [type stringByAppendingString:@"dropDown"];
//                type = [type stringByAppendingString:@","];
//                resNquid = [resNquid stringByAppendingString:@","];
//                if([_dropDownstr length]>0)
//                    resAns=[resAns stringByAppendingString:arrdropDownStr[countDrop]];
//                else
//                    resAns=[resAns stringByAppendingString:@""];
//                resAns=[resAns stringByAppendingString:@","];
//                countDrop=countDrop+1;
//            }
//            else if([cell isKindOfClass:[PJRadioCell class]])
//            {
//
//                PJRadioCell *textCell          = (PJRadioCell *)cell;
//                if([textCell.Type isEqualToString:@"Radio"])
//                {
//
//                    resNquid = [resNquid stringByAppendingString:textCell.nQueid];
//                    type = [type stringByAppendingString:@"radio"];
//                    type = [type stringByAppendingString:@","];
//                    resNquid = [resNquid stringByAppendingString:@","];
//                    if(_seletedStr.length>0)
//                        resAns=[resAns stringByAppendingString:arrRadioData[count1]];
//                    else
//                        resAns=[resAns stringByAppendingString:@""];
//                    resAns=[resAns stringByAppendingString:@","];
//                    count1=count1+1;
//                }
//                else
//                {
//                    resNquid = [resNquid stringByAppendingString:textCell.nQueid];
//                    type = [type stringByAppendingString:@"checkBox"];
//                    type = [type stringByAppendingString:@","];
//                    resNquid = [resNquid stringByAppendingString:@","];
//                    for(id obj  in rc.selectedOption)
//                    {
//                        resAns=[resAns stringByAppendingString:obj];
//                        //resAns=[resAns stringByAppendingString:@" "];
//                    }
//                    resAns=[resAns stringByAppendingString:@","];
//                }
//            }
//            else if([cell isKindOfClass:[PJTextField class]])
//            {
//                PJTextField *textCell= (PJTextField *)cell;
//
//                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
//
//                type = [type stringByAppendingString:@"textField"];
//
//                type = [type stringByAppendingString:@","];
//
//                resNquid = [resNquid stringByAppendingString:@","];
//
//                if([cell.value length]>0)
//                    resAns=[resAns stringByAppendingString:cell.value];
//                else
//                    resAns=[resAns stringByAppendingString:@""];
//                resAns=[resAns stringByAppendingString:@","];
//            }
//            else if([cell isKindOfClass:[PJDatePicker class]])
//            {
//
//                PJDatePicker *textCell          = (PJDatePicker *)cell;
//
//                resNquid = [resNquid stringByAppendingString:textCell.nQueid];
//                type = [type stringByAppendingString:@"datePicker"];
//                type = [type stringByAppendingString:@","];
//                resNquid = [resNquid stringByAppendingString:@","];
//                if([cell.value length]>0)
//                    resAns=[resAns stringByAppendingString:cell.value];
//                else
//                    resAns=[resAns stringByAppendingString:@""];
//                resAns=[resAns stringByAppendingString:@","];
//            }
//
//
//            //        FormValues *value = [FormValues new];
//            //            value.key             = cell.key;
//            //            value.value           = cell.value;
//            //
//            //            [formValues addObject:value];
//
//
//
//        }
//    }
//    NSLog(@"%@",resNquid);
//    NSLog(@"%@",resAns);
//    if ([resNquid length] > 0) {
//        resNquid = [resNquid substringToIndex:[resNquid length] - 1];
//    }
//    if ([resAns length] > 0) {
//        resAns = [resAns substringToIndex:[resAns length] - 1];
//    }
//    if ([type length] > 0) {
//        type = [type substringToIndex:[type length] - 1];
//    }
//    //    EKToast *toast = [[EKToast alloc]initWithMessage:[NSString stringWithFormat:@"%@",formValues]];
//    //    toast.position           = ToastPositionBottom;
//    //    toast.delay              = 3.0f;
//    //    toast.shouldAutoDestruct = NO;
//    //    [toast show:nil];
//    UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:NULL];
//
//
//
//       dataDictionary=[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                      [NSString  stringWithFormat:@"%@",resNquid], @"nQueid",
//                                      [NSString stringWithFormat:@"%@",resAns], @"sCorrectAns",
//                                    [NSString stringWithFormat:@"%@",type], @"sType",nil];
//        NSLog(@"%@",dataDictionary);
//
//
////    [defaults setObject:dataDictionary forKey:@"thirdViewController"];
////    [defaults synchronize];
//
////    if (isNext==NO) {
////        AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
////        appdel.dataDictionary
////        =[NSMutableDictionary dictionaryWithObjectsAndKeys:
////          [NSString  stringWithFormat:@"%@",resNquid], @"nQueid",
////          [NSString stringWithFormat:@"%@",resAns], @"sCorrectAns",
////          [NSString stringWithFormat:@"%@",type], @"sType",nil];
////        NSLog(@"%@",appdel.dataDictionary);
////      //  AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
////         appdel.dicDropDown=dicDrop;
////        //[appdel.dicDropDown removeAllObjects];
////
////        AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
////        fourth.dataDictionary = [[NSMutableDictionary alloc] init];
////        fourth.dataDictionary =appdel.dataDictionary;
////
////        [self.navigationController pushViewController:fourth animated:NO];
////
////    }
////    else {
//        AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//        appdel.dataDictionary1
//
//        =[NSMutableDictionary dictionaryWithObjectsAndKeys:
//          [NSString  stringWithFormat:@"%@",resNquid], @"nQueid",
//          [NSString stringWithFormat:@"%@",resAns], @"sCorrectAns",
//          [NSString stringWithFormat:@"%@",type], @"sType",nil];
//         appdel.dicDropDown=dicDrop;
//        NSLog(@"%@",appdel.dataDictionary1);
//
//
//
////    if (isNext) {
////        isNext=NO;
////        AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
////        appdel.dicDropDown=dicDrop;
////
////        //  appdel.dataDictionary=dataDictionary;
////        //        [appdel.dataDictionary1 setObject:arrdropDownStr forKey:@"sCorrectAns"];
////        //        NSLog(@"AppDict:%@",appdel.dataDictionary1);
////    }
////    else
////    {
//
////        NSMutableDictionary *defaultData = [defaults objectForKey:@"thirdViewController"];
////        NSLog(@"%@",defaultData);
//
//            //}
//
////    NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
////    [userDefault setObject:dataDictionary forKey:@"isNext"];
////    [userDefault synchronize];
////    NSLog(@"%@",[userDefault valueForKey:@"isNext"]);
//
//       //AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (appdel.isBack==NO) {
//        AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
//        fourth.dataDictionary = [[NSMutableDictionary alloc] init];
//        fourth.dataDictionary = appdel.dataDictionary1;
//        appdel.isBack=YES;
//        appdel.dataDictionary=dataDictionary;
//        [self.navigationController pushViewController:fourth animated:NO];
//    }
//   else
//    {
//    AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
//            fourth.dataDictionary = [[NSMutableDictionary alloc] init];
//            fourth.dataDictionary = appdel.dataDictionary ;
//        [self.navigationController pushViewController:fourth animated:NO];
//
//
//    }
//   // [appdel.dataDictionary removeAllObjects];
//
////    AddClientSectionFourViewController *fourth=(AddClientSectionFourViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionFourViewController"];
////    fourth.dataDictionary = [[NSMutableDictionary alloc] init];
////    fourth.dataDictionary = [userDefault valueForKey:@"isNext"];
////    //appdel.isBack=YES;
////    [self.navigationController pushViewController:fourth animated:NO];
////    
////    AppDelegate *appdel=(AppDelegate*)[[UIApplication sharedApplication] delegate];
//   // appdel.isBack=YES;
//}

@end