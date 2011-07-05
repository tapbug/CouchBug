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

#import "CouchSurfer.h"

@implementation CouchSearchFilter

@synthesize locationJSON;

@synthesize hasCouchYes;
@synthesize hasCouchMaybe;
@synthesize hasCouchCoffeeOrDrink;
@synthesize hasCouchTraveling;

@synthesize ageLow;
@synthesize ageHigh;
@synthesize maxSurfers;
@synthesize languageId;
@synthesize languageName;
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
		//self.locationJSON = [@"{\"state_id\":\"4384\",\"state\":\"Praha\",\"latitude\":\"50.087814\",\"longitude\":\"14.420453\",\"type\":\"state\",\"country_id\":\"75\",\"country\":\"Czech Republic\",\"region_id\":\"6\",\"region\":\"Europe\"}" objectFromJSONString];
		self.hasCouchYes = YES;
		self.hasCouchTraveling = YES;
		self.hasCouchCoffeeOrDrink = YES;
		self.hasCouchMaybe = YES;
		
        self.male = YES;
        self.female = YES;
        self.severalPeople = YES;
        self.hasPhoto = NO;
        self.verified = NO;
        self.vouched = NO;
        self.ambassador = NO;
        self.wheelchairAccessible = NO;
        self.username = nil;
        self.keyword = nil;
    }
    return self;
}

- (void)dealloc {
    self.locationJSON = nil;
    self.languageId = nil;
    self.username = nil;
    self.keyword = nil;
    [super dealloc];
}

- (CouchSearchRequest *)createRequest {
    CouchSearchRequest *request = [[[CouchSearchRequest alloc] init] autorelease];
	if (self.locationJSON == nil) {
		request.location = @"{\"label\":\"Everywhere\",\"latitude\":0,\"longitude\":0,\"type\":\"everywhere\",\"cssClass\":\"item-everywhere\"}";
	} else {
		request.location = [self.locationJSON JSONString];
	}
    
	NSMutableArray *couchStatusesTemp = [NSMutableArray array];
	if (self.hasCouchYes) {
		[couchStatusesTemp addObject:CouchSurferHasCouchYes];
	}
	if (self.hasCouchMaybe) {
		[couchStatusesTemp addObject:CouchSurferHasCouchMaybe];
	}
	if (self.hasCouchCoffeeOrDrink) {
		[couchStatusesTemp addObject:CouchSurferHasCouchCoffeDrink];
	}
	if (self.hasCouchTraveling) {
		[couchStatusesTemp addObject:CouchSurferHasCouchTraveling];
	}
	request.couchStatuses = couchStatusesTemp;
	
    request.ageLow = [NSString stringWithFormat:@"%d", self.ageLow];
    request.ageHigh = [NSString stringWithFormat:@"%d", self.ageHigh];
    request.maxSurfers = [NSString stringWithFormat:@"%d", self.maxSurfers];
    request.languageId = self.languageId;
    request.lastLoginDays = [NSString stringWithFormat:@"%d", self.lastLoginDays];
    request.male = self.male ? @"1" : @"";
    request.female = self.female ? @"1" : @"";;
    request.severalPeople = self.severalPeople ? @"1" : @"";;
    request.hasPhoto = self.hasPhoto ? @"1" : @"";;
    request.verified = self.verified ? @"1" : @"";;
    request.vouched = self.vouched ? @"1" : @"";;
    request.ambassador = self.ambassador ? @"1" : @"";;
    request.wheelchairAccessible = self.wheelchairAccessible ? @"1" : @"";;
    request.username = self.username;
    request.keyword = self.keyword;
    
    return request;
}

#pragma Public methods

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
