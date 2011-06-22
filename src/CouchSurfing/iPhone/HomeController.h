//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LogoutRequest.h"
#import "ProfileRequest.h"
#import "CSImageDownloader.h"

@class ActivityOverlap;
@class AuthControllersFactory;
@class ProfileRequestFactory;
@protocol LoginAnnouncer;

@interface HomeController : UIViewController <LogoutRequestDelegate, ProfileRequestDelegate, UITableViewDelegate, UITableViewDataSource, CSImageDownloaderDelegate> {
    AuthControllersFactory *_authControllersFactory;
    ProfileRequestFactory *_profileRequestFactory;
    
    ActivityOverlap *_loadingOverlap;
    ProfileRequest *_profileRequest;
    
    ActivityOverlap *_logoutOverlap;
    LogoutRequest *_logoutRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    
    UITableView *_tableView;
    UIImageView *_photoView;
    
    CSImageDownloader *_avatarDownloader;
    
    NSArray *_items;
}

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory 
               profileRequestFactory:(ProfileRequestFactory *)profileRequestFactory
                      loginAnnouncer:(id<LoginAnnouncer>) loginAnnouncer;

@end
