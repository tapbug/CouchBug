//
//  IdentityManager.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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

@end
