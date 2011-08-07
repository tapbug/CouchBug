//
//  TapableTableView.m
//  CouchSurfing
//
//  Created on 6/24/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "TapableTableView.h"


@implementation TapableTableView

@synthesize tapDelegate = _tabDelegate;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	if ([self.tapDelegate respondsToSelector:@selector(tableViewWasTouched:)]) {
		[self.tapDelegate tableViewWasTouched:self];
	}
}

@end
