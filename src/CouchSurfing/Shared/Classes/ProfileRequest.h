//
//  ProfileRequest.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"
#import "LoginRequest.h"

//  Nacita profil prihlaseneho uzivatele

@protocol ProfileRequestDelegate;
@protocol LoginInformation;

@interface ProfileRequest : NSObject <MVUrlConnectionDelegate, LoginRequestDelegate> {
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

- (void)profileRequest:(ProfileRequest *)profileRequest didLoadProfile:(NSDictionary *)profile;
- (void)profileRequestFailedToLogin:(ProfileRequest *)profileRequest;

@end