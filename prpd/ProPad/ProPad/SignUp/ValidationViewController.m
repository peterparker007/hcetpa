//
//  ValidationViewController.m
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#import "ValidationViewController.h"

@interface ValidationViewController ()

@end

@implementation ValidationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (BOOL)validateEmail:(NSString *)inputText
{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:inputText];
}

+ (BOOL)validatePassword:(NSString *)inputText
{
    if([inputText length] <5)
    {
        return FALSE;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (NSString*)Capital:(NSString*)inputText
{
    NSString *text = inputText;
    NSString *capitalized = [text uppercaseString];
    
    return capitalized;
}

+ (BOOL)isValidPhone:(NSString *)text {
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:text] == YES)
        || ([regextestcm evaluateWithObject:text] == YES)
        || ([regextestct evaluateWithObject:text] == YES)
        || ([regextestcu evaluateWithObject:text] == YES)
        || ([regextestphs evaluateWithObject:text] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isValidTwoLetterStateAbbreviation:(NSString *)text {
    NSString *regex = @"^(AA|AE|AP|AL|AK|AS|AZ|AR|CA|CO|CT|DE|DC|FM|FL|GA|GU|HI|ID|IL|IN|IA|KS|KY|LA|ME|MH|MD|MA|MI|MN|MS|MO|MT|NE|NV|NH|NJ|NM|NY|NC|ND|MP|OH|OK|OR|PW|PA|PR|RI|SC|SD|TN|TX|UT|VT|VI|VA|WA|WV|WI|WY)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)isValidStateName:(NSString *)text {
    
    NSString *regex = @"^(Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|District of Columbia|Florida|Georgia|Hawaii|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New Hampshire|New Jersey|New Mexico|New York|North Carolina|North Dakota|Ohio|Oklahoma|Oregon|Pennsylvania|Rhode Island|South Carolina|South Dakota|Tennessee|Texas|Utah|Vermont|Virginia|Washington|West Virginia|Wisconsin|Wyoming)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
    
}

+ (BOOL)isValidZipcode:(NSString *)text {
    NSString *regex = @"^\\d{5}(-\\d{4})?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (BOOL)isValidName:(NSString *)text {
    NSString *regex = @"^[a-zA-Z\\s]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:text];
}

+ (NSString *)formatPhoneNumber:(NSString *)text format:(NSString *)format error:(NSError**)error {
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[#]{1}"
                                                                           options:NSRegularExpressionCaseInsensitive error:error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:format options:0 range:NSMakeRange(0, format.length)];
    
    if (numberOfMatches != 10) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:@"Format does not have 10 digit representations (i.e., \"#\")" forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"eddieios" code:100 userInfo:errorDetail];
        return @"";
    }
    
    regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1}" options:0 error:error];
    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    NSMutableArray *numArray = [NSMutableArray arrayWithObjects:
                                @"", @"", @"", @"", @"", @"", @"", @"", @"", @"",nil];
    
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult *match = [matches objectAtIndex:i];
        NSRange matchRange = [match range];
        NSString *matchString = [text substringWithRange:matchRange];
        [numArray insertObject:matchString atIndex:i];
    }
    
    NSString *modifiedFormat = [format stringByReplacingOccurrencesOfString:@"#" withString:@"%@"];
    NSString *formattedString = [NSString stringWithFormat:modifiedFormat,
                                 [numArray objectAtIndex:0],
                                 [numArray objectAtIndex:1],
                                 [numArray objectAtIndex:2],
                                 [numArray objectAtIndex:3],
                                 [numArray objectAtIndex:4],
                                 [numArray objectAtIndex:5],
                                 [numArray objectAtIndex:6],
                                 [numArray objectAtIndex:7],
                                 [numArray objectAtIndex:8],
                                 [numArray objectAtIndex:9]];
    return formattedString;
}


@end
