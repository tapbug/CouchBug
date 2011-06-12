//
//  AppDelegate_iPhone.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVIOC/MVIOC.h"

#import "ProfileRequestFactory.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    MVIOCContainer *_container;
    UITabBarController *_tabBarController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MVIOCContainer *container;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end

