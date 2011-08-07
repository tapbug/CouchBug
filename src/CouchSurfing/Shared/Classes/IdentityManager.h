//
//  IdentityManager.h
//  CouchSurfing
//
//  Created on 2/16/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginAnnouncer.h"
#import "LoginInformation.h"

@interface IdentityManager : NSObject <LoginAnnouncer, LoginInformation> {
    NSString *_username;
    NSString *_password;
}

@property (readonly) NSString *username;
@property (readonly) NSString *password;
@property (readonly) BOOL isLogged;

@end
