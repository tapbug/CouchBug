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

- (id)createControllerWithRequest:(CouchSearchRequest *)request {
    CouchSearchResultController *controller = [[[CouchSearchResultController alloc] initWithRequest:request] autorelease];
    return controller;
}


- (void)dealloc {
    [super dealloc];
}

@end
