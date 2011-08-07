//
//  CurrentLocationRequest.h
//  CouchSurfing
//
//  Created on 6/26/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

@protocol CurrentLocationObjectRequestDelegate;

@interface CurrentLocationObjectRequest : NSObject <MVUrlConnectionDelegate> {
	id<CurrentLocationObjectRequestDelegate> _delegate;
    MVUrlConnection *_connection;
}

@property (nonatomic, assign) id<CurrentLocationObjectRequestDelegate> delegate;

- (void)gatherCurrentLocation;

@end

@protocol CurrentLocationObjectRequestDelegate <NSObject>

- (void)currentLocationObjectRequest:(CurrentLocationObjectRequest *)request
				   didGatherLocation:(NSDictionary *)location;

@end