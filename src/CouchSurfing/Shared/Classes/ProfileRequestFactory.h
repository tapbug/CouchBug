//
//  ProfileRequestFactory.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileRequest;
@protocol LoginInformation;

@interface ProfileRequestFactory : NSObject {
    id<LoginInformation> injLoginInformation;
}

- (ProfileRequest *)createProfileRequest;

@end
