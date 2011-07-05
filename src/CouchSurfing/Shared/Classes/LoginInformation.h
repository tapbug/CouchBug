//
//  LoginInformation.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginInformation

@property (readonly) NSString *username;
@property (readonly) NSString *password;
@property (readonly) BOOL isLogged;

@end
