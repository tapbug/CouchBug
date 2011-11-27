//
//  NSDictionary+URL.h
//  Pearescope
//
//  Created by Michal Vašíček on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URL)

- (NSString*)URLQueryString;
- (NSString *)URLQueryStringWithoutMark;
@end
