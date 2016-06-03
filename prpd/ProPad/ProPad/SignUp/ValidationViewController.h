//
//  ValidationViewController.h
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValidationViewController : UIViewController
+ (BOOL)validateEmail:(NSString *)inputText;
+ (BOOL)validatePassword:(NSString *)inputText;
+ (NSString*)Capital:(NSString*)inputText;
+ (BOOL)isValidPhone:(NSString *)text;
+ (BOOL)isValidTwoLetterStateAbbreviation:(NSString *)text;
+ (BOOL)isValidStateName:(NSString *)text;
+ (BOOL)isValidZipcode:(NSString *)text;
+ (BOOL)isValidName:(NSString *)text;

+ (NSString *)formatPhoneNumber:(NSString *)text format:(NSString *)format error:(NSError**)error;
@end
