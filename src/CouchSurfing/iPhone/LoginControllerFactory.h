//
//  LoginControllerFactory.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginController;
@protocol LoginAnnouncer;
@protocol LoginInformation;

@interface LoginControllerFactory : NSObject {
    id<LoginAnnouncer> injLoginAnnouncer;
    id<LoginInformation> injLoginInformation;
}

@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;

- (id)createController;

@end
