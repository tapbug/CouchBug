//
//  CouchSearchFormControllerFactory.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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
