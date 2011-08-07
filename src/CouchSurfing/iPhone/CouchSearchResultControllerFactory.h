//
//  CouchSearchResultControllerFactory.h
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchRequest;
@class CouchSearchFilter;
@class CouchSearchFormControllerFactory;
@class ProfileControllerFactory;

@interface CouchSearchResultControllerFactory : NSObject {
    CouchSearchFilter *injFilter;
	CouchSearchFormControllerFactory *injFormControllerFactory;
	ProfileControllerFactory *injProfileControllerFactory;
}

@property (nonatomic, assign) CouchSearchFilter *filter;
@property (nonatomic, retain) CouchSearchFormControllerFactory *formControllerFactory;
@property (nonatomic, retain) ProfileControllerFactory *profileControllerFactory;

- (id)createInstance;

@end
