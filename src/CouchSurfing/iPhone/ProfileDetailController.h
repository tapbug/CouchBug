//
//  ProfileDetailController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSurfer;
@class ActivityOverlap;

@interface ProfileDetailController : UIViewController {
    NSString *_html;
	CouchSurfer *_surfer;
	NSString *_property;
	
	ActivityOverlap *_activityOverlap;
}

- (id)initWithHtmlString:(NSString *)html;
- (id)initWithSurfer:(CouchSurfer *)surfer property:(NSString *)property;


@end
