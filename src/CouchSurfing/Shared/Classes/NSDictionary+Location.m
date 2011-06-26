//
//  LocationCategory.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Location.h"


@implementation NSDictionary (LocationCategory)

#pragma Public methods

- (NSString *)locationName {
	if ([self objectForKey:@"city"]) {
		return [NSString stringWithFormat:@"%@, %@, %@", 
				[self objectForKey:@"city"],
				[self objectForKey:@"state"],
				[self objectForKey:@"country"]];
	} else if ([self objectForKey:@"state"]) {
		return [NSString stringWithFormat:@"%@, %@",
				[self objectForKey:@"state"],
				[self objectForKey:@"country"]];
	} else if ([self objectForKey:@"country"]) {
		return [NSString stringWithFormat:@"%@",
				[self objectForKey:@"country"]];
	} else if ([self objectForKey:@"region"]) {
		return [NSString stringWithFormat:@"%@",
				[self objectForKey:@"region"]];
	}
	return nil;
}

@end
