//
//  ProfileController.h
//  CouchSurfing
//
//  Created on 6/9/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdBannerViewOverlap.h"

#import "LogoutRequest.h"
#import "HomeRequest.h"
#import "CSImageDownloader.h"
#import "PreferencesRequest.h"

@class ActivityOverlap;
@class AuthControllersFactory;
@class HomeRequestFactory;
@protocol LoginAnnouncer;
@class CouchSearchResultController;
@protocol ActiveControllersSetter;

@interface HomeController : UIViewController <LogoutRequestDelegate, ProfileRequestDelegate, UITableViewDelegate, UITableViewDataSource, CSImageDownloaderDelegate, PreferencesRequestDelegate, ADBannerViewDelegate> {
    UIView *_contentView;
	AuthControllersFactory *_authControllersFactory;
    HomeRequestFactory *_profileRequestFactory;
    
    ActivityOverlap *_loadingOverlap;
    HomeRequest *_profileRequest;
	
	PreferencesRequest *_preferencesRequest;
    
    ActivityOverlap *_logoutOverlap;
    LogoutRequest *_logoutRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    
    UITableView *_tableView;
    UIImageView *_photoView;
    
    CSImageDownloader *_avatarDownloader;
    
    NSArray *_items;
	
	CouchSearchResultController *_couchSearchController;
	id<ActiveControllersSetter> _activeControllersSetter;
	
	BOOL _profileLoaded;
	BOOL _preferencesLoaded;
	
	BOOL _shouldReload;
	BOOL _isActive;
	
	AdBannerViewOverlap *_adBannerViewOverlap;
}

@property (nonatomic, assign) CouchSearchResultController *couchSearchController;
@property (nonatomic, assign) id<ActiveControllersSetter> activeControllersSetter;

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory 
               profileRequestFactory:(HomeRequestFactory *)profileRequestFactory
                      loginAnnouncer:(id<LoginAnnouncer>) loginAnnouncer;

- (void)refreshHomeInformation;

@end
