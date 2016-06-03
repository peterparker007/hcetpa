//
//  AppConstant.h
//  ProPad
//
//  Created by Bhumesh on 29/06/15.
//  Copyright (c) 2015 Zaptech. All rights reserved.
//

#ifndef AppConstant_AppConstant_h
#define AppConstant_AppConstant_h


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//https://app.propadauto.com/webservices/
// http://216.55.169.45/~propad/master/webservices/
//#define SERVER_URL @"http://216.55.169.45/~propad/master/webservices/"
//http://216.55.169.45/~propad/master/webservices/questionlist.php
#define SERVER_URL @"https://app.propadauto.com/webservices_phase2/"

#define KRegisterNewUser          SERVER_URL@"adduser.php"
#define KLogin                    SERVER_URL@"login.php"
#define KAddClient                SERVER_URL@"addclient.php"
#define KGetClientList            SERVER_URL@"clientlist.php"
#define KDeleteSingleClient       SERVER_URL@"clientdel.php"
#define KGetCompanyList           SERVER_URL@"companylist.php"
#define KNotify                   SERVER_URL@"newemail.php"
#define Kaddform                  SERVER_URL@"addform.php"
#define KQuesList                 SERVER_URL@"questionlist.php"
#define URL_ISpay                 SERVER_URL@"accstatus.php"
#define kLinkedInClientID @"75wk1fvbggboau"
#define kLinkedInSecretAppKey @"lSjuLy80mLRarTYP"
#define kLinkeDinStates @"ECEEFWF45453sdffef696"


#define KClientId @"nClientId"
#define KUserList SERVER_URL@"userlist.php"
#define KForgetPassword SERVER_URL@"forgotpassword.php"

#define KEdmundsSecrectKey @"Xqmuq75EZG6NpjwNb3PDnwgr"
#define KEdmundsApiKey @"u87a3h49paxjb97z9cfkea2n"
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

#endif
