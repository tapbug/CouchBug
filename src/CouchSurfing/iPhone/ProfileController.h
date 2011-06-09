//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVUrlConnection.h"

@class MVUrlConnection;
@class ActivityOverlap;

@interface ProfileController : UIViewController <MVUrlConnectionDelegate>{
    ActivityOverlap *_activityOverlap;
    MVUrlConnection *_urlConnection;
}

@end
