//
//  CouchSearchResultControllerFactory.m
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CouchSearchResultControllerFactory.h"

#import "CouchSearchResultController.h"
#import "ProfileControllerFactory.h"

@implementation CouchSearchResultControllerFactory

@synthesize filter = injFilter;
@synthesize formControllerFactory = injFormControllerFactory;
@synthesize profileControllerFactory = injProfileControllerFactory;

- (id)createInstance {
    CouchSearchResultController *controller = [[[CouchSearchResultController alloc] init] autorelease];
    controller.filter = self.filter;
	controller.formControllerFactory = self.formControllerFactory;
	controller.profileControllerFactory = self.profileControllerFactory;
    return controller;
}


- (void)dealloc {
    self.formControllerFactory = nil;
	self.profileControllerFactory = nil;
    [super dealloc];
}

@end
