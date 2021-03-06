//
//  ProfileRequest.h
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"
#import "LoginRequest.h"

//  Nacita profil prihlaseneho uzivatele

@protocol ProfileRequestDelegate;
@protocol LoginInformation;

@interface HomeRequest : NSObject <MVUrlConnectionDelegate, LoginRequestDelegate> {
    id<ProfileRequestDelegate> _delegate;
    id<LoginInformation> _loginInformation;
    MVUrlConnection *_homeConnection;
    
    LoginRequest *_loginRequest;
    
    NSMutableDictionary *_profileDictionary;
}

@property(nonatomic, assign) id<ProfileRequestDelegate> delegate;

- (id)initWithLoginInformation:(id<LoginInformation>)loginInformation;
- (void)loadProfile;

@end

@protocol ProfileRequestDelegate <NSObject>

- (void)profileRequest:(HomeRequest *)profileRequest didLoadProfile:(NSDictionary *)profile;
- (void)profileRequestFailedToLogin:(HomeRequest *)profileRequest;

@end