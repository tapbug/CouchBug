//
//  CouchSearchRequest.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString CouchSearchRequestHasCouch;

extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchYes;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchDefinitely;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchMaybe;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchCoffeeMaybe;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchCoffeDrink;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchNo;
extern CouchSearchRequestHasCouch * const CouchSearchRequestHasCouchTraveling;

@protocol CouchSearchRequestDelegate;

@interface CouchSearchRequest : NSObject {
    id<CouchSearchRequestDelegate> _delegate;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
    
    CouchSearchRequestHasCouch *_hasCouch;
    NSString *_maxSurfers;
    NSString *_keyword;
    NSString *_keywordOrAnd;
    NSString *_cityCountry;
    NSString *_regionId;
    NSString *_countryId;
    NSString *_stateId;
    NSString *_cityId;
    NSString *_radius;
    NSString *_radiusType;    
}

@property (nonatomic, assign) id<CouchSearchRequestDelegate> delegate;

@property (nonatomic, retain) CouchSearchRequestHasCouch *hasCouch;
@property (nonatomic, retain) NSString *maxSurfers;
@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, retain) NSString *keywordOrAnd;
@property (nonatomic, retain) NSString *cityCountry;
@property (nonatomic, retain) NSString *regionId;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *stateId;
@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *radius;
@property (nonatomic, retain) NSString *radiusType;

- (void)send;

@end

@protocol CouchSearchRequestDelegate <NSObject>

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers;

@end