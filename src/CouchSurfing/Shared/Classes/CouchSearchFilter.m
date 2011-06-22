//
//  CouchSearchFilter.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFilter.h"

#import "CouchSearchRequest.h"

@implementation CouchSearchFilter

@synthesize location;
@synthesize couchStatuses;
@synthesize ageLow;
@synthesize ageHigh;
@synthesize maxSurfers;
@synthesize languageId;
@synthesize lastLoginDays;
@synthesize male;
@synthesize female;
@synthesize severalPeople;
@synthesize hasPhoto;
@synthesize verified;
@synthesize vouched;
@synthesize ambassador;
@synthesize wheelchairAccessible;
@synthesize username;
@synthesize keyword;

- (id)init {
    self = [super init];
    if (self) {
        //self.location = @"{state_id\":\"4441\",\"state\":\"Usti nad Labem\",\"latitude\":\"50.661034\",\"longitude\":\"14.032994\",\"type\":\"state\",\"country_id\":\"75\",\"country\":\"Czech Republic\",\"region_id\":\"6\",\"region\":\"Europe\"}";
        self.location = @"{\"state_id\":\"4384\",\"state\":\"Praha\",\"latitude\":\"50.087814\",\"longitude\":\"14.420453\",\"type\":\"state\",\"country_id\":\"75\",\"country\":\"Czech Republic\",\"region_id\":\"6\",\"region\":\"Europe\"}";
        self.couchStatuses = [NSArray array];
        self.ageLow = @"";
        self.ageHigh = @"";
        self.maxSurfers = @"0";
        self.languageId = @"";
        self.lastLoginDays = @"";
        self.male = @"1";
        self.female = @"1";
        self.severalPeople = @"1";
        self.hasPhoto = @"";
        self.verified = @"";
        self.vouched = @"";
        self.ambassador = @"";
        self.wheelchairAccessible = @"";
        self.username = @"";
        self.keyword = @"";
    }
    return self;
}

- (void)dealloc {
    self.location = nil;
    self.couchStatuses = nil;
    self.ageLow = nil;
    self.ageHigh = nil;
    self.maxSurfers = nil;
    self.languageId = nil;
    self.lastLoginDays = nil;
    self.male = nil;
    self.female = nil;
    self.severalPeople = nil;
    self.hasPhoto = nil;
    self.wheelchairAccessible = nil;
    self.verified = nil;
    self.vouched = nil;
    self.ambassador = nil;
    self.username = nil;
    self.keyword = nil;
    [super dealloc];
}

- (CouchSearchRequest *)createRequest {
    CouchSearchRequest *request = [[[CouchSearchRequest alloc] init] autorelease];
    request.location = self.location;
    request.couchStatuses = self.couchStatuses;
    request.ageLow = self.ageLow;
    request.ageHigh = self.ageHigh;
    request.maxSurfers = self.maxSurfers;
    request.languageId = self.languageId;
    request.lastLoginDays = self.lastLoginDays;
    request.male = self.male;
    request.female = self.female;
    request.severalPeople = self.severalPeople;
    request.hasPhoto = self.hasPhoto;
    request.verified = self.verified;
    request.vouched = self.vouched;
    request.ambassador = self.ambassador;
    request.wheelchairAccessible = self.wheelchairAccessible;
    request.username = self.username;
    request.keyword = self.keyword;
    
    return request;
}

@end
