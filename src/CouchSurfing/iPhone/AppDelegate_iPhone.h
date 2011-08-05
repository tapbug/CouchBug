//
//  AppDelegate_iPhone.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVIOC/MVIOC.h"
#import "ActiveControllersSetter.h"

@class CouchSearchResultController;
@class HomeController;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ActiveControllersSetter> {
    UIWindow *_window;
    MVIOCContainer *_container;
    UITabBarController *_tabBarController;
	
	UINavigationController *_searchNavigationController;
	CouchSearchResultController *_searchResultController;
	
	HomeController *_activeHomeController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MVIOCContainer *container;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

