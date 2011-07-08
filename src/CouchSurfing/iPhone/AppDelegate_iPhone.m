//
//  AppDelegate_iPhone.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "AppDelegate_iPhone.h"

//Auth module
#import "AuthControllersFactory.h"
#import "LoginAnnouncer.h"
#import "IdentityManager.h"
#import "HomeRequestFactory.h"

//Couchsearch UI modules
#import "CouchSearchFormControllerFactory.h"
#import "CouchSearchResultController.h"
#import "CouchSearchResultControllerFactory.h"
//Profile UI modules
#import "ProfileControllerFactory.h"
#import "LoginController.h"
//Couchsearch core modules
#import "CouchSearchFilter.h"

#import "MoreController.h"

#import "RegexKitLite.h"
#import "CSTools.h"

@interface AppDelegate_iPhone ()

- (void)injectAuth;
- (void)injectCouchSearch;

@end


@implementation AppDelegate_iPhone

@synthesize window = _window;
@synthesize container = _container;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	application.statusBarHidden = NO;
    
    self.container = [[[MVIOCContainer alloc] init] autorelease];

    [self injectAuth];
    [self injectCouchSearch];
    
    //Tvorba Profile Tabu
    id<LoginInformation> loginInformation = [self.container getComponent:@protocol(LoginInformation)];
    AuthControllersFactory *authControllerFactory = [self.container getComponent:[AuthControllersFactory class]];
    id authController = nil;
	LoginController *loginController = nil;
    if (loginInformation.username && loginInformation.password) {
        authController = [authControllerFactory createProfileController];
    } else {
        authController = [authControllerFactory createLoginController];
		loginController = authController;
    }
    UINavigationController *loginNavigationController = 
        [[[UINavigationController alloc] initWithRootViewController:(UIViewController *)authController] autorelease];
    UITabBarItem *loginTabBarItem =
        [[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PROFILE", nil) 
                                       image:[UIImage imageNamed:@"profileCard.png"]
                                         tag:0] autorelease];
    [loginNavigationController setTabBarItem: loginTabBarItem];
    
    //Tvorba CouchSearchTabu
    _searchResultController =
        [self.container getComponent:[CouchSearchResultController class]];
    
    _searchNavigationController = 
    [[[UINavigationController alloc] initWithRootViewController:_searchResultController] autorelease];
    UITabBarItem *searchTabBarItem =
        [[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SEARCH", nil)
                                       image:[UIImage imageNamed:@"search.png"]
                                         tag:1] autorelease];
    [_searchNavigationController setTabBarItem:searchTabBarItem];
    
    //Tvorba MoreTabu
    UIViewController *moreController = [[[MoreController alloc] init] autorelease];
    UITabBarItem *moreTabBarItem =
        [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2] autorelease];
    [moreController setTabBarItem:moreTabBarItem];
    
    //Nastaveni TabBar controlleru
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             loginNavigationController,
                                             _searchNavigationController,
                                             moreController,
                                             nil];
	self.tabBarController.delegate = self;
	
	loginController.couchSearchController = _searchResultController;
	
    // zmena vzhledu TabBaru
    /*
    CGSize tabBarSize = [self.tabBarController.tabBar frame].size;
    UIView *tabBarFakeView = [[UIView alloc] initWithFrame:
                      CGRectMake(0,0,tabBarSize.width, tabBarSize.height)];
    [self.tabBarController.tabBar insertSubview:tabBarFakeView atIndex:0];
    [tabBarFakeView setBackgroundColor:UIColorFromRGB(0x353839)];
     */
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
        
    return YES;
}

#pragma mark Injections methods

- (void)injectCouchSearch {
	[[[self.container withInjectionType:MVIOCFactoryInjectionTypeDefault]
		withCache]
		addComponent:[CouchSearchResultControllerFactory class]
		representing:[CouchSearchResultController class]];
	
    [self.container addComponent:[CouchSearchFormControllerFactory class]];
    
	[self.container addComponent:[ProfileControllerFactory class]];
    //Core modules
    [[self.container withCache] addComponent:[CouchSearchFilter class]];
}

- (void)injectAuth {
    [self.container addComponent:[HomeRequestFactory class]];
    [self.container addComponent:[AuthControllersFactory class]];
    [[self.container withCache] addComponent:[IdentityManager class] 
                                representing:[NSArray arrayWithObjects:@protocol(LoginAnnouncer), @protocol(LoginInformation), nil]];
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
	[_searchResultController searchAgainBecauseOfLocationDisabled];
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

#pragma Mark UITabBarDelegate methods

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController {
	
	if (_searchNavigationController	== viewController) {
		if (_searchResultController == _searchNavigationController.topViewController) {
			[_searchResultController scrollToTop];
		}
	}
}

@end
