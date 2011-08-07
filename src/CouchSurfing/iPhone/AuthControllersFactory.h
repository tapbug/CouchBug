//
//  AuthControllersFactory.h
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Tovarna, ktera umi vytvorit Login a Profile controllery

@class LoginController;
@protocol LoginAnnouncer;
@protocol LoginInformation;
@protocol ActiveControllersSetter;

@class HomeController;
@class HomeRequestFactory;
@class CouchSearchResultController;

@interface AuthControllersFactory : NSObject {
    id<LoginAnnouncer> injLoginAnnouncer;
    id<LoginInformation> injLoginInformation;
    
    HomeRequestFactory *injProfileRequestFactory;
	CouchSearchResultController *injCouchSearchResultController;
	id<ActiveControllersSetter> injActiveControllersSetter;
}

@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;
@property (nonatomic, assign) id<LoginInformation> loginInformation;
@property (nonatomic, assign) id<ActiveControllersSetter> activeControllersSetter;

@property (nonatomic, retain) HomeRequestFactory *profileRequestFactory;
@property (nonatomic, assign) CouchSearchResultController *couchSearchResultController;

- (LoginController *)createLoginController;
- (HomeController *)createProfileController;

@end
