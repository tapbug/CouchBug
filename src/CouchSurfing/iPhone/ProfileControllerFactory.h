//
//  ProfileControllerFactory.h
//  CouchSurfing
//
//  Created on 7/5/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileController;
@class CouchSurfer;
@protocol LoginInformation;

@interface ProfileControllerFactory : NSObject {
    id<LoginInformation> injLoginInformation;
}

@property (nonatomic, assign) id<LoginInformation> loginInformation;

- (ProfileController *)createProfileControllerWithSurfer:(CouchSurfer *)surfer;

@end
