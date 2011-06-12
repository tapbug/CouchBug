//
//  CouchSearchResultControllerFactory.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchRequest;
@class CouchSearchFilter;

@interface CouchSearchResultControllerFactory : NSObject {
    CouchSearchFilter *injFilter;
}

@property (nonatomic, assign) CouchSearchFilter *filter;

- (id)createController;

@end
