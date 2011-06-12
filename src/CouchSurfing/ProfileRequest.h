//
//  ProfileRequest.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

//  Nacita profil prihlaseneho uzivatele

@protocol ProfileRequestDelegate;

@interface ProfileRequest : NSObject <MVUrlConnectionDelegate> {
    id<ProfileRequestDelegate> _delegate;
    MVUrlConnection *_loadingConnection;    
}

@property(nonatomic, assign) id<ProfileRequestDelegate> delegate;

- (void)loadProfile;

@end

@protocol ProfileRequestDelegate <NSObject>

- (void)profileRequest:(ProfileRequest *)profileRequest didLoadProfile:(NSDictionary *)profile;

@end