//
//  CouchSearchFormControllerFactory.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CouchSearchRequestFactory;
@class CouchSearchResultControllerFactory;
@class CouchSearchBasicFormVariant;
@class CouchSearchAdvancedFormVariant;

@interface CouchSearchFormControllerFactory : NSObject {
    CouchSearchRequestFactory *injRequestFactory;
}

@property (nonatomic, retain) CouchSearchRequestFactory *requestFactory;

- (id)createController;

@end
