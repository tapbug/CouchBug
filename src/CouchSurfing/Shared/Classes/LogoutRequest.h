//
//  LogoutRequest.h
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

@protocol LogoutRequestDelegate;

@interface LogoutRequest : NSObject <MVUrlConnectionDelegate>{
    id<LogoutRequestDelegate> _delegate;
    
    MVUrlConnection *_connection;
}

@property (nonatomic, assign) id<LogoutRequestDelegate> delegate;

- (void)logout;

@end

@protocol LogoutRequestDelegate <NSObject>

- (void)logoutDidFinnish:(LogoutRequest *)logoutReqeust;

@end