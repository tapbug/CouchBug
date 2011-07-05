//
//  IdentityManager.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IdentityManager.h"

@implementation IdentityManager

- (void)user:(NSString *)username hasLoggedWithPassword:(NSString *)password {
    [_username autorelease];
    _username = [username copy];
    [_password autorelease];
    _password = [password copy];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_username forKey:@"username"];
    [userDefaults setObject:_password forKey:@"password"];
    [userDefaults synchronize];
}

- (void)userHasLoggedOut {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults synchronize];
    [_password release]; _password = nil;
}

- (void)dealloc {
    [_username release]; _username = nil;
    [_password release]; _password = nil;
    [super dealloc];
}

- (NSString *)username {
    if (_username == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _username = [[userDefaults objectForKey:@"username"] copy];
    }
    return _username;    
}

- (NSString *)password {
    if (_password == nil) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _password = [[userDefaults objectForKey:@"password"] copy];
    }
    return _password;
}

- (BOOL)isLogged {
	return self.username != nil && self.password != nil;
}

@end
