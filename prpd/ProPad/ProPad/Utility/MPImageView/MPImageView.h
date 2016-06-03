//
//  MPImageView.h
//  MPImageView
//
//  Created by Ashish Patel on 5/7/14.
//  Copyright (c) 2014 My Projects. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MPImageView : UIImageView<NSURLConnectionDelegate>{
    
    NSURLConnection *connection;
    NSMutableData* data;
    UIActivityIndicatorView *ai;
}
+ (MPImageView*)sharedInstance;
-(void)initWithImageAtURL:(NSURL*)url;
- (void)setImageAtURL:(NSURL *)url;

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) UIActivityIndicatorView *ai;

@end
