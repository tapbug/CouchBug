//
//  CouchSearchRequestFactory.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchRequestFactory.h"

#import "CouchSearchRequest.h"

@implementation CouchSearchRequestFactory

- (CouchSearchRequest *)createRequest {
    CouchSearchRequest *request = [[[CouchSearchRequest alloc] init] autorelease];
    return request;
}

@end
