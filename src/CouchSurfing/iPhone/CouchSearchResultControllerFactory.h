//
//  CouchSearchResultControllerFactory.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchRequest;

@interface CouchSearchResultControllerFactory : NSObject {
}

- (id)createController;

@end
