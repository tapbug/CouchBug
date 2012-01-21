//
//  CouchRequest.h
//  CouchSurfing
//
//  Created on 6/28/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVUrlConnection.h"

#import "PreferencesRequest.h"

@protocol SetLanguageRequestDelegate;

@class CouchSurfer;

@interface SetLanguageRequest : NSObject <MVUrlConnectionDelegate> {
	id<SetLanguageRequestDelegate> _delegate;
	MVUrlConnection *_connection;
}

@property (nonatomic, assign) id<SetLanguageRequestDelegate> delegate;

- (void)setDefaultLanguage;

@end

@protocol SetLanguageRequestDelegate <NSObject>

- (void)setLanguageRequestDidSent:(SetLanguageRequest *)request;

@end