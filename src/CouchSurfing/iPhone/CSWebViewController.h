//
//  CSWebViewController.h
//  CouchSurfing
//
//  Created on 7/8/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityOverlap;

@interface CSWebViewController : UIViewController <UIWebViewDelegate>{
	NSString *_urlString;
	ActivityOverlap *_loadingOverlap;
}

@property (nonatomic, copy) NSString *urlString;

@end
