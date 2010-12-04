//
//  AppDelegate_iPhone.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "LauncherController.h"

#import "CouchSearchFormControllerFactory.h"
#import "CouchSearchBasicFormVariant.h"
#import "CouchSearchAdvancedFormVariant.h"

#import "CouchSearchResultControllerFactory.h"

#import "CouchSearchRequestFactory.h"


@interface AppDelegate_iPhone ()

- (void)injectCouchSearch;
- (void)injectCouchSearchRequest;

@end


@implementation AppDelegate_iPhone

@synthesize window = _window;
@synthesize container = _container;
@synthesize navController = _navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    self.container = [[[MVIOCContainer alloc] init] autorelease];

    //Base controller
    [self.container addComponent:[LauncherController class]];
    
    [self injectCouchSearch];
    [self injectCouchSearchRequest];
    
    LauncherController *launcherController = [self.container getComponent:[LauncherController class]];
    
    self.navController = [[[UINavigationController alloc] initWithRootViewController:launcherController] autorelease];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window addSubview:self.navController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark Injections methods

- (void)injectCouchSearch {
    [self.container addComponent:[CouchSearchResultControllerFactory class]];
    [self.container addComponent:[CouchSearchFormControllerFactory class]];
    [self.container addComponent:[CouchSearchBasicFormVariant class]];
    [self.container addComponent:[CouchSearchAdvancedFormVariant class]];
}

- (void)injectCouchSearchRequest {
    [self.container addComponent:[CouchSearchRequestFactory class]];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    self.window = nil;
    self.container = nil;
    [super dealloc];
}


@end
