//
//  CouchSearchFilter.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFilter.h"

#import "CouchSearchRequest.h"
#import "JSONKit.h"

@implementation CouchSearchFilter

@synthesize locationJSON;
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
        self.locationJSON = [@"{\"state_id\":\"4384\",\"state\":\"Praha\",\"latitude\":\"50.087814\",\"longitude\":\"14.420453\",\"type\":\"state\",\"country_id\":\"75\",\"country\":\"Czech Republic\",\"region_id\":\"6\",\"region\":\"Europe\"}" objectFromJSONString];
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
    self.locationJSON = nil;
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

#pragma Public methods

- (NSString *)location {
	return [self.locationJSON JSONString];
}

- (NSString *)locationName {
	if ([self.locationJSON objectForKey:@"city"]) {
		return [NSString stringWithFormat:@"%@, %@, %@", 
				[self.locationJSON objectForKey:@"city"],
				[self.locationJSON objectForKey:@"state"],
				[self.locationJSON objectForKey:@"country"]];
	} else if ([self.locationJSON objectForKey:@"state"]) {
		return [NSString stringWithFormat:@"%@, %@",
				[self.locationJSON objectForKey:@"state"],
				[self.locationJSON objectForKey:@"country"]];
	} else if ([self.locationJSON objectForKey:@"country"]) {
		return [NSString stringWithFormat:@"%@",
				[self.locationJSON objectForKey:@"country"]];
	} else if ([self.locationJSON objectForKey:@"region"]) {
		return [NSString stringWithFormat:@"%@",
				[self.locationJSON objectForKey:@"region"]];
	}
	return nil;
}

@end
