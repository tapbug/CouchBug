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

- (id)createController {
    CouchSearchResultController *controller = [[[CouchSearchResultController alloc] init] autorelease];
    return controller;
}


- (void)dealloc {
    [super dealloc];
}

@end
