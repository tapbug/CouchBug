//
//  CurrentLocationRequest.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

@protocol CurrentLocationRequestDelegate;

@interface CurrentLocationRequest : NSObject <MVUrlConnectionDelegate> {
	id<CurrentLocationRequestDelegate> _delegate;
    MVUrlConnection *_connection;
}

@property (nonatomic, assign) id<CurrentLocationRequestDelegate> delegate;

- (void)gatherCurrentLocation;

@end

@protocol CurrentLocationRequestDelegate <NSObject>

- (void)currentLocationRequest:(CurrentLocationRequest *)request
			 didGatherLocation:(NSDictionary *)location;

@end