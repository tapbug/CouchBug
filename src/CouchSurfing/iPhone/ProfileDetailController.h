//
//  ProfileDetailController.h
//  CouchSurfing
//
//  Created on 7/3/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVUrlConnection.h"

@class CouchSurfer;
@class ActivityOverlap;

@interface ProfileDetailController : UIViewController <MVUrlConnectionDelegate, UIWebViewDelegate> {
    NSString *_html;

	CouchSurfer *_surfer;
	NSString *_property;
	
	MVUrlConnection *_connection;
	
	ActivityOverlap *_activityOverlap;
	
	BOOL _withInlineStyles;
	NSString *_styleName;
}

@property (nonatomic, assign) BOOL withInlineStyles;
@property (nonatomic, assign) NSString *styleName;

- (id)initWithHtmlString:(NSString *)html;
- (id)initWithSurfer:(CouchSurfer *)surfer property:(NSString *)property;
- (id)initWithConnection:(MVUrlConnection *)connection;


@end
