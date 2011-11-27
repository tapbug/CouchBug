//
//  NSDictionary+URL.m
//  Pearescope
//
//  Created by Michal Vašíček on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+URL.h"

@implementation NSDictionary (URL)

- (NSString*)urlEscape:(NSString *)unencodedString {
	NSString *s = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
																	  (CFStringRef)unencodedString,
																	  NULL,
																	  (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	  kCFStringEncodingUTF8);
	return [s autorelease];
}

- (NSString *)URLQueryString {
	NSMutableString *queryString = [NSMutableString string];
	for(id key in self) {
		NSString *sKey = [key description];
		NSString *sVal = [[self objectForKey:key] description];
			
		if ([queryString rangeOfString:@"?"].location == NSNotFound) {
			[queryString appendFormat:@"?%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
		} else {
			[queryString appendFormat:@"&%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
		}
	}
	return queryString;
}

- (NSString *)URLQueryStringWithoutMark {
	NSMutableString *queryString = [NSMutableString string];
	for(id key in self) {
		NSString *sKey = [key description];
		NSString *sVal = [[self objectForKey:key] description];
		
		if (queryString.length == 0) {
			[queryString appendFormat:@"%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
		} else {
			[queryString appendFormat:@"&%@=%@", [self urlEscape:sKey], [self urlEscape:sVal]];
		}
	}
	return queryString;
}

@end
