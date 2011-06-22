//
//  AppDelegate_iPhone.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVIOC/MVIOC.h"

@class CouchSearchResultController;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *_window;
    MVIOCContainer *_container;
    UITabBarController *_tabBarController;
	
	UINavigationController *_searchNavigationController;
	CouchSearchResultController *_searchResultController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MVIOCContainer *container;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

