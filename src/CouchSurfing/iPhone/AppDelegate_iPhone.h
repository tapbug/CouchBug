//
//  AppDelegate_iPhone.h
//  CouchSurfing
//
//  Created on 11/5/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVIOC.h"
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

