//
//  LocationDisabledOverlap.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationDisabledOverlap : NSObject {
	UIView *_view;
    NSString *_title;
	NSString *_body;
    
    UIView *_overlapView;
    UILabel *_titleLabel;
	UILabel *_bodyLabel;
	BOOL _active;
}


- (id)initWithView:(UIView *)view title:(NSString *)title body:(NSString *)body;

- (void)overlapView;    
- (void)removeOverlap;

@end