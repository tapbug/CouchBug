//
//  AuthControllersFactory.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Tovarna, ktera umi vytvorit Login a Profile controllery

@class LoginController;
@protocol LoginAnnouncer;
@protocol LoginInformation;

@class HomeController;
@class HomeRequestFactory;
@class CouchSearchResultController;

@interface AuthControllersFactory : NSObject {
    id<LoginAnnouncer> injLoginAnnouncer;
    id<LoginInformation> injLoginInformation;
    
    HomeRequestFactory *injProfileRequestFactory;
	CouchSearchResultController *injCouchSearchResultController;
}

@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;

@property (nonatomic, retain) HomeRequestFactory *profileRequestFactory;
@property (nonatomic, assign) CouchSearchResultController *couchSearchResultController;

- (LoginController *)createLoginController;
- (HomeController *)createProfileController;

@end
