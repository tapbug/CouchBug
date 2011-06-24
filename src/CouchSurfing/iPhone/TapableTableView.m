//
//  TapableTableView.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TapableTableView.h"


@implementation TapableTableView

@synthesize tapDelegate = _tabDelegate;
@synthesize justTableTouch = _justTableTouch;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!self.justTableTouch) {
		[super touchesBegan:touches withEvent:event];		
	} else {
		if ([self.tapDelegate respondsToSelector:@selector(tableViewWasTouched:)]) {
			[self.tapDelegate tableViewWasTouched:self];
		}	
	}
}

@end
