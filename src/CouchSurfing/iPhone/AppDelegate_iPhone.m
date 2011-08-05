//
//  AppDelegate_iPhone.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "ActiveControllersSetter.h"

//Auth module
#import "AuthControllersFactory.h"
#import "LoginAnnouncer.h"
#import "IdentityManager.h"
#import "HomeRequestFactory.h"
#import "HomeController.h"

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
#import "FlurryAPI.h"

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
	[FlurryAPI startSession:@"227PC2P2Y2XM5P5VLITG"];
	
    self.container = [[[MVIOCContainer alloc] init] autorelease];
	[self.container addComponent:self representing:[NSArray arrayWithObject:@protocol(ActiveControllersSetter)]];
    [self injectAuth];
    [self injectCouchSearch];
    
    //Tvorba Profile Tabu
    id<LoginInformation> loginInformation = [self.container getComponent:@protocol(LoginInformation)];
    AuthControllersFactory *authControllerFactory = [self.container getComponent:[AuthControllersFactory class]];
    id authController = nil;
	LoginController *loginController = nil;
    if (loginInformation.username && loginInformation.password) {
        authController = [authControllerFactory createProfileController];
		[self setHomeController:authController];
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
	UINavigationController *moreNavController = [[[UINavigationController alloc] initWithRootViewController:moreController] autorelease];
	moreNavController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);
    UITabBarItem *moreTabBarItem =
        [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:2] autorelease];
    [moreNavController setTabBarItem:moreTabBarItem];
    
    //Nastaveni TabBar controlleru
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             loginNavigationController,
                                             _searchNavigationController,
                                             moreNavController,
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
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
	
	[FlurryAPI logAllPageViews:self.tabBarController];
        
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
	[_searchResultController searchAgainBecauseOfLocationDisabled];
	[_activeHomeController refreshHomeInformation];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
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

#pragma Mark ActiveControllersSetter role

- (void)setHomeController:(HomeController *)controller {
	_activeHomeController = controller;
}

@end
