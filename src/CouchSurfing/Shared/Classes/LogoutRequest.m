//
//  LogoutRequest.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogoutRequest.h"

@interface LogoutRequest ()

@property (nonatomic, retain) MVUrlConnection *connection;

@end

@implementation LogoutRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;

- (void)dealloc {
    self.connection = nil;
    [super dealloc];
}

- (void)logout {
    self.connection = [[[MVUrlConnection alloc] initWithUrlString:@"https://www.couchsurfing.org/login.html?auth_logout=1"] autorelease];
    self.connection.delegate = self;
    [self.connection sendRequest];
}

#pragma Mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
    if ([self.delegate respondsToSelector:@selector(logoutDidFinnish:)]) {
        [self.delegate logoutDidFinnish:self];
    }
}

@end
