//
//  IdentityManager.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IdentityManager.h"

@implementation IdentityManager

@synthesize username = _username;
@synthesize password = _password;

- (void)user:(NSString *)username hasLoggedWithPassword:(NSString *)password {
    [_username autorelease];
    _username = [username copy];
    [_password autorelease];
    _password = [password copy];
}

- (void)dealloc {
    [_username release]; _username = nil;
    [_password release]; _password = nil;
    [super dealloc];
}

@end
