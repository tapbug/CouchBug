//
//  PreferencesRequest.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 9/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MVUrlConnection.h"

@protocol PreferencesRequestDelegate;

@interface PreferencesRequest : NSObject <MVUrlConnectionDelegate> {
	MVUrlConnection *_preferencesConnection;
	id<PreferencesRequestDelegate> _delegate;
}

@property (nonatomic, assign) id<PreferencesRequestDelegate> delegate;

- (void)loadPreferences;

@end

@protocol PreferencesRequestDelegate <NSObject>

- (void)preferencesRequest:(PreferencesRequest *)request didLoadResult:(NSDictionary *)result;

@end