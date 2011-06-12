//
//  CouchSearchResultControllerFactory.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchResultControllerFactory.h"

#import "CouchSearchResultController.h"

@implementation CouchSearchResultControllerFactory

@synthesize filter = injFilter;

- (id)createController {
    CouchSearchResultController *controller = [[[CouchSearchResultController alloc] init] autorelease];
    controller.filter = self.filter;
    return controller;
}


- (void)dealloc {
    self.filter = nil;
    [super dealloc];
}

@end
