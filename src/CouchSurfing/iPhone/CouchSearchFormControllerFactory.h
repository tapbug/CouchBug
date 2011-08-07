//
//  CouchSearchFormControllerFactory.h
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchFilter;

@interface CouchSearchFormControllerFactory : NSObject {
	CouchSearchFilter *injFilter;
}

@property (nonatomic, assign) CouchSearchFilter *filter;

- (id)createController;

@end
