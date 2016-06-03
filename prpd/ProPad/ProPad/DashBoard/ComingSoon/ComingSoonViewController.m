//
//  ComingSoonViewController.m
//  ProPad
//
//  Created by Bhumesh on 02/07/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "ComingSoonViewController.h"
#import "AddClientSectionTwoViewController.h"
#import "UIView+Toast.h"
#import "ActionSheetStringPicker.h"
#import "FMDBDataAccess.h"
#import "UIView+Toast.h"
#import "ValidationViewController.h"
#import "IQDropDownTextField.h"
@interface ComingSoonViewController ()<UIAlertViewDelegate,UIGestureRecognizerDelegate,IQDropDownTextFieldDelegate>
{
    BOOL isPhoneChecked;
    BOOL isTextChecked;
    BOOL isEmailChecked;
    NSArray *custTypeArray;
    NSArray *referenceArray;
    BOOL isCustType;
    BOOL isRefernce;
}


@end

@implementation ComingSoonViewController

//@synthesize  txtDesirePayment;
//@synthesize txtNotesForSecondSec;
@synthesize scrlView;
//@synthesize txtMakeModel;
@synthesize txtAddress;
@synthesize btnPhone;
@synthesize btnEmail;
@synthesize btnText;
@synthesize  txtCustType;
@synthesize  txtReference;
//@synthesize  txtSecondaryChoice;
//@synthesize  txtCurrentPayment;
//@synthesize  txtPrimaryChoice;
@synthesize  txtNotesForFirstSec;
@synthesize txtFirstName;
@synthesize txtLastName;
@synthesize txtCity;
@synthesize txtMobile;
@synthesize txtHome;
@synthesize txtWork;
@synthesize txtEmail;
@synthesize pickerView;
//@synthesize txtCurrentMile;

@synthesize txtCityCode;

- (void)viewDidLoad {
    [super viewDidLoad];
    isPhoneChecked = false;
    isEmailChecked =  false;
    isTextChecked = false;
    
    isCustType=false;
    isRefernce=false;
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-200, self.view.frame.size.width, 100)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    pickerView.hidden=true;
    
    [self.pickerView reloadAllComponents];
    
    [scrlView setContentOffset:CGPointMake(0, 0) animated:NO];
    [scrlView setContentSize:CGSizeMake(420, 1000)];
    
    [[txtAddress layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[txtAddress layer] setBorderWidth:2.3];
    [[txtAddress layer] setCornerRadius:15];
    
    [[txtNotesForFirstSec layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[txtNotesForFirstSec layer] setBorderWidth:2.3];
    [[txtNotesForFirstSec layer] setCornerRadius:15];
    txtCustType.delegate=self;
    custTypeArray = [NSArray arrayWithObjects:@"1st Time Customer ",
                     @"Be Back",
                     @"Previous Customer",
                     @"Appointment", nil];
    
    referenceArray = [NSArray arrayWithObjects:@"Internet",
                      @"Walk In",
                      @"Referral",
                      @"Mailer",
                      @"3rd Party Website", nil];
    
    [txtCustType setItemList:[NSArray arrayWithObjects:@"1st Time Customer ",
                              @"Be Back",
                              @"Previous Customer",
                              @"Appointment", nil]];
    [txtReference setItemList:[NSArray arrayWithObjects:@"Internet",
                               @"Walk In",
                               @"Referral",
                               @"Mailer",
                               @"3rd Party Website", nil]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.title = @"Back";
 
}
- (void)viewDidAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"IsAddClient"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //    txtCustType.text=@"";
    //    txtReference.text=@"";
    //    txtFirstName.text=@"";
    //    txtLastName.text=@"";
    //    txtCity.text=@"";
    //    txtCityCode.text=@"";
    //    txtMobile.text=@"";
    //    txtHome.text=@"";
    //    txtWork.text=@"";
    //    txtEmail.text=@"";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)itemWasSelected:(NSNumber *)selectedIndex element:(id)element {
    
    NSLog(@"%@",selectedIndex);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)Selectcust_type:(id)sender {
    pickerView.hidden=false;
    
    isCustType=true;
    isRefernce=false;
    [self.pickerView reloadAllComponents];
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Address"]||[textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}
- (IBAction)SelectAboutus:(id)sender {
    pickerView.hidden=false;
    isCustType=false;
    isRefernce=true;
    [self.pickerView reloadAllComponents];
    
}

#pragma mark pickerview function

//返回有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回指定列的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (isCustType) {
        return  [custTypeArray count];
    } else if(isRefernce){
        return  [referenceArray count];
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 20.0f;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return  self.view.frame.size.width/3;
    } else if(component==1){
        return  self.view.frame.size.width/3;
    }
    return  self.view.frame.size.width/3;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3, 20)];
    text.textAlignment = NSTextAlignmentCenter;
    if (isRefernce)
        text.text = [referenceArray objectAtIndex:row];
    else if (isCustType)
        text.text = [custTypeArray objectAtIndex:row];
    
    [view addSubview:text];
    
    return view;
}
//显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if (isRefernce)
        str = [referenceArray objectAtIndex:row];
    else if (isCustType)
        str = [custTypeArray objectAtIndex:row];
    return str;
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *str;
    if (isRefernce)
        str = [referenceArray objectAtIndex:row];
    else if (isCustType)
        str = [custTypeArray objectAtIndex:row];
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedString addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [AttributedString  length])];
    
    return AttributedString;
}//NS_AVAILABLE_IOS(6_0);

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (isRefernce){
        NSLog(@"HANG%@",[referenceArray objectAtIndex:row]);
        self.pickerView.hidden=true;
        txtReference.text = [referenceArray objectAtIndex:row];
        
    }
    else if (isCustType){
        NSLog(@"HANG%@",[custTypeArray objectAtIndex:row]);
        self.pickerView.hidden=true;
        txtCustType.text = [custTypeArray objectAtIndex:row];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // dismiss the keyboard
    self.pickerView.hidden=true;
    
    [super touchesBegan:touches withEvent:event];
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    txtCustType.text= @"1st Time Customer";
                    break;
                case 1:
                    txtCustType.text= @"Be Back";
                    break;
                case 2:
                    txtCustType.text= @"Previous Customer";
                    break;
                case 3:
                    txtCustType.text= @"Appointment";
                    break;
                default:
                    break;
            }
            break;
        }
            
        case 2: {
            switch (buttonIndex) {
                case 0:
                    txtReference.text= @"Internet";
                    break;
                case 1:
                    txtReference.text= @"Walk In";
                    break;
                case 2:
                    txtReference.text= @"Referral";
                    break;
                case 3:
                    txtReference.text= @"Mailer";
                    break;
                case 4:
                    txtReference.text= @"3rd Party Website";
                    break;
                default:
                    break;
            }
            break;
        }
        case 3: {
            switch (buttonIndex) {
                    //                case 0:
                    //                    txtCurrentPayment.text= @"100-200";
                    //                    break;
                    //                case 1:
                    //                    txtCurrentPayment.text= @"50-100";
                    //                    break;
                    //                case 2:
                    //                    txtCurrentPayment.text= @"25-50";
                    //                    break;
                    //                case 3:
                    //                    txtCurrentPayment.text= @"0-25";
                    //                    break;
                    //
                    //                default:
                    //                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

-(void)textField:(IQDropDownTextField*)textField didSelectItem:(NSString*)item
{
    
}
-(void)selecttext:(id)sender
{
    if(isTextChecked==false)
        isTextChecked=true;
    else
        isTextChecked=false;
    btnText.selected=!btnText.selected;
}
-(void)selectemail:(id)sender
{
    if(isEmailChecked==false)
        isEmailChecked=true;
    else
        isEmailChecked=false;
    
    btnEmail.selected=!btnEmail.selected;
    
}

-(void)selectphone:(id)sender
{
    if(isPhoneChecked==false)
        isPhoneChecked=true;
    else
        isPhoneChecked=false;
    
    btnPhone.selected=!btnPhone.selected;
}

- (IBAction)onNextClicked:(id)sender {
    NSString *preferenceTypeTxt = [NSString stringWithFormat:@"%d%d%d",isPhoneChecked,isEmailChecked,isTextChecked];
    if(txtCustType.text.length==0){
        
        [self.view makeToast:@"Please select customer type" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtReference.text.length==0){
        [self.view makeToast:@"Please select how you here about us" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtFirstName.text.length==0){
        [self.view makeToast:@"Please enter first name" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtLastName.text.length==0){
        [self.view makeToast:@"Please enter last name" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtAddress.text.length==0){
        [self.view makeToast:@"Please enter address" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtCity.text.length==0){
        [self.view makeToast:@"Please enter city" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtCityCode.text.length==0){
        [self.view makeToast:@"Please enter zip" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtMobile.text.length==0){
        [self.view makeToast:@"Please enter mobile" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtWork.text.length==0){
        [self.view makeToast:@"Please enter work number" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if(txtEmail.text.length==0){
        [self.view makeToast:@"Please enter email address" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    else if (![ValidationViewController validateEmail:txtEmail.text])
    {
        [self.view makeToast:@"Please enter valid email address" duration:1 position:CSToastPositionCenter title:nil];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"IsAddClient"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:txtCustType.text forKey:@"CustType"];
    [dict setValue:txtReference.text forKey:@"Reference"];
    [dict setValue:txtFirstName.text forKey:@"FirstName"];
    [dict setValue:txtLastName.text forKey:@"LastName"];
    [dict setValue:txtAddress.text forKey:@"Address"];
    [dict setValue:txtCity.text forKey:@"City"];
    [dict setValue:txtCityCode.text forKey:@"Zip"];
    [dict setValue:txtMobile.text forKey:@"Mobile"];
    [dict setValue:txtHome.text forKey:@"Home"];
    [dict setValue:txtWork.text forKey:@"Work"];
    [dict setValue:txtEmail.text forKey:@"Email"];
    
    [dict setValue:preferenceTypeTxt forKey:@"PreferContType"];
    
    AddClientSectionTwoViewController *second=(AddClientSectionTwoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddClientSectionTwoViewController"];
    second.dataDictionary = [[NSMutableDictionary alloc] init];
    second.dataDictionary = dict;
    [self.navigationController pushViewController:second animated:YES];
}
@end
