//
//  CouchSearchFormControllerFactory.m
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CouchSearchFormControllerFactory.h"
#import "CouchSearchFormController.h"
#import "CouchSearchFilter.h"

@implementation CouchSearchFormControllerFactory

@synthesize filter = injFilter;

- (id)createController {
    CouchSearchFormController *controller = [[[CouchSearchFormController alloc] init] autorelease];
	controller.filter = self.filter;
    return controller;
}

- (void)dealloc {
    [super dealloc];
}

@end
