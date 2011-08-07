//
//  LocationCategory.m
//  CouchSurfing
//
//  Created on 6/26/11.
//  Copyright 2011 tapbug. All rights reserved.
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
