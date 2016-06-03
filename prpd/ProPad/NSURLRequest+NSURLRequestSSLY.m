//
//  NSURLRequest+NSURLRequestSSLY.m
//  ProPad
//
//  Created by Bhumesh on 01/02/16.
//  Copyright © 2016 Zaptech. All rights reserved.
//

#import "NSURLRequest+NSURLRequestSSLY.h"

@implementation NSURLRequest (NSURLRequestSSLY)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end
