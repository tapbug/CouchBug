//
//  ActivityOverlap.h
//  CouchSurfing
//
//  Created on 6/9/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivityOverlap : NSObject {
    UIView *_view;
    NSString *_title;
    
    UIView *_activityView;
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_activityLabel;
	BOOL _active;
}

- (id)initWithView:(UIView *)view title:(NSString *)title;

- (void)overlapView;    
- (void)removeOverlap;

@end
