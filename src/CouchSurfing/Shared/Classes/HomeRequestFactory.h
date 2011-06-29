//
//  ProfileRequestFactory.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeRequest;
@protocol LoginInformation;

@interface HomeRequestFactory : NSObject {
    id<LoginInformation> injLoginInformation;
}

- (HomeRequest *)createHomeRequest;

@end
