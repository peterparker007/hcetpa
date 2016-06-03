//
//  MPImageView.m
//  MPImageView
//
//  Created by Ashish Patel on 5/7/14.
//  Copyright (c) 2014 My Projects. All rights reserved.
//

#import "MPImageView.h"

static NSCache *imagecache;

@implementation MPImageView
@synthesize ai,connection, data;


+ (MPImageView*)sharedInstance
{
    static MPImageView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MPImageView alloc] init];
    });
    return sharedInstance;
}

-(void)initWithImageAtURL:(NSURL*)url
{
    [self setContentMode:UIViewContentModeScaleAspectFit];
    if (!ai){
        [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        [ai startAnimating];
        [ai setTranslatesAutoresizingMaskIntoConstraints:NO];
        [ai setCenter:self.center];
        [self addSubview:ai];
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)setImageAtURL:(NSURL *)url
{
    if (!ai){
        [self setAi:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
        [ai startAnimating];
        [ai setCenter:self.center];
        [self addSubview:ai];
        
        [ai setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *centerConst = [NSLayoutConstraint constraintWithItem:ai attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self addConstraint:centerConst];
        centerConst = [NSLayoutConstraint constraintWithItem:ai attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self addConstraint:centerConst];
        
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (data==nil) data = [[NSMutableData alloc] initWithCapacity:2048];
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection
{
    [self setImage:[UIImage imageWithData: data]];
    [ai removeFromSuperview];
    
    ai = nil;
}

@end