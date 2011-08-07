//
//  ProfileRequest.h
//  CouchSurfing
//
//  Created on 7/2/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

@protocol ProfileRequestDelegate;
@class CouchSurfer;
@class CXMLDocument;

@interface ProfileRequest : NSObject <MVUrlConnectionDelegate> {
    id<ProfileRequestDelegate> _delegate;
	MVUrlConnection *_profileConnection;
	
	CouchSurfer *_surfer;
}

@property (nonatomic, assign) id<ProfileRequestDelegate> delegate;
@property (nonatomic, retain) CouchSurfer *surfer;

- (void)sendProfileRequest;

+ (NSString *)parsePersonalDescription:(CXMLDocument*)doc;

@end

@protocol ProfileRequestDelegate <NSObject>

- (void)profileRequestDidFillSurfer:(ProfileRequest *)request withResultDocument:(CXMLDocument *)doc;

@end