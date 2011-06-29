//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LogoutRequest.h"
#import "HomeRequest.h"
#import "CSImageDownloader.h"

@class ActivityOverlap;
@class AuthControllersFactory;
@class HomeRequestFactory;
@protocol LoginAnnouncer;

@interface HomeController : UIViewController <LogoutRequestDelegate, ProfileRequestDelegate, UITableViewDelegate, UITableViewDataSource, CSImageDownloaderDelegate> {
    AuthControllersFactory *_authControllersFactory;
    HomeRequestFactory *_profileRequestFactory;
    
    ActivityOverlap *_loadingOverlap;
    HomeRequest *_profileRequest;
    
    ActivityOverlap *_logoutOverlap;
    LogoutRequest *_logoutRequest;
    id<LoginAnnouncer> _loginAnnouncer;
    
    UITableView *_tableView;
    UIImageView *_photoView;
    
    CSImageDownloader *_avatarDownloader;
    
    NSArray *_items;
}

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory 
               profileRequestFactory:(HomeRequestFactory *)profileRequestFactory
                      loginAnnouncer:(id<LoginAnnouncer>) loginAnnouncer;

@end
