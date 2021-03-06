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

@protocol CouchRequestRequestDelegate;

@class CouchSurfer;

@interface CouchRequestRequest : NSObject <MVUrlConnectionDelegate, PreferencesRequestDelegate> {
	id<CouchRequestRequestDelegate> _delegate;
	MVUrlConnection *_connection;
	
	PreferencesRequest *_preferencesRequest;
	
	NSString *_dateFormat;
	NSDate *_arrivalDate;
	NSDate *_departureDate;
	
	NSString *_subject;
	NSString *_message;
	
	NSInteger _numberOfSurfers;
	NSInteger _arrivalViaId;
	CouchSurfer *_surfer;
	
	//	pokud je toto opravny pokud
	//	napr. z duvodu spatneho formatu datumu
	BOOL _isRepaired;
}

@property (nonatomic, assign) id<CouchRequestRequestDelegate> delegate;

@property (nonatomic, retain) NSString *dateFormat;
@property (nonatomic, retain) NSDate *arrivalDate;
@property (nonatomic, retain) NSDate *departureDate;

@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger numberOfSurfers;
@property (nonatomic, assign) NSInteger arrivalViaId;

@property (nonatomic, retain) CouchSurfer *surfer;

- (void)sendCouchRequest;

@end

@protocol CouchRequestRequestDelegate <NSObject>

- (void)couchRequestRequestDidSent:(CouchRequestRequest *)request;
- (void)couchRequestDidFailedWithErrors:(NSDictionary *)errors;

@end