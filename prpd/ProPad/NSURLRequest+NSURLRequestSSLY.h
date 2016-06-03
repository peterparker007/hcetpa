//
//  NSURLRequest+NSURLRequestSSLY.h
//  ProPad
//
//  Created by Bhumesh on 01/02/16.
//  Copyright © 2016 Zaptech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestSSLY)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

@end
