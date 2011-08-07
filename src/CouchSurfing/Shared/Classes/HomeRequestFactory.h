//
//  ProfileRequestFactory.h
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeRequest;
@protocol LoginInformation;

@interface HomeRequestFactory : NSObject {
    id<LoginInformation> injLoginInformation;
}

- (HomeRequest *)createHomeRequest;

@end
