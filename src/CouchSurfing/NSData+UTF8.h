//
//  NSData+UTF8.h
//  CouchSurfing
//
//  Created on 7/7/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (NSData_UTF8)
- (NSData *)dataByCleanUTF8;
@end
