//
//  ProfileRequest.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

@protocol ProfileRequestDelegate;
@class CouchSurfer;

@interface ProfileRequest : NSObject <MVUrlConnectionDelegate> {
    id<ProfileRequestDelegate> _delegate;
	MVUrlConnection *_profileConnection;
	
	CouchSurfer *_surfer;
}

@property (nonatomic, assign) id<ProfileRequestDelegate> delegate;
@property (nonatomic, retain) CouchSurfer *surfer;

- (void)sendProfileRequest;

@end

@protocol ProfileRequestDelegate <NSObject>

- (void)profileRequest:(ProfileRequest *)request didLoadProfileData:(NSDictionary *)data;

@end