//
//  LauncherController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSearchFormControllerFactory;
@class LoginControllerFactory;

@interface LauncherController : UIViewController {

}

@property (nonatomic, retain) CouchSearchFormControllerFactory *searchControllerFactory;
@property (nonatomic, retain) LoginControllerFactory *loginControllerFactory;

@end
