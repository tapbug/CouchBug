//
//  CouchSearchFormControllerFactory.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchRequestFactory;
@class CouchSearchFilter;

@interface CouchSearchFormControllerFactory : NSObject {
    CouchSearchRequestFactory *injRequestFactory;
	CouchSearchFilter *injFilter;
}

@property (nonatomic, retain) CouchSearchRequestFactory *requestFactory;
@property (nonatomic, assign) CouchSearchFilter *filter;

- (id)createController;

@end
