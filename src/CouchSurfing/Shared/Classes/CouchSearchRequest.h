//
//  CouchSearchRequest.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CouchSearchRequestDelegate;

@interface CouchSearchRequest : NSObject {
    id<CouchSearchRequestDelegate> _delegate;
    
    NSURLConnection *_connection;
    NSMutableData *_data;
    
    NSString *_page;
    NSString *_location;
    NSString *_mapEdges;
    NSArray *_couchStatuses;
    NSString *_ageLow;
    NSString *_ageHigh;    
    NSString *_maxSurfers;
    NSString *_laguageId;
    NSString *_lastLoginDays;
    NSString *_male;
    NSString *_female;
    NSString *_severalPeople;
    NSString *_hasPhoto;
    NSString *_verified;
    NSString *_vouched;
    NSString *_ambassador;
    
    NSString *_wheelchairAccessible;
    NSString *_username;
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

@property (nonatomic, retain) NSString *page;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *mapEdges;
@property (nonatomic, retain) NSArray *couchStatuses;
@property (nonatomic, retain) NSString *ageLow;
@property (nonatomic, retain) NSString *ageHigh;
@property (nonatomic, retain) NSString *maxSurfers;
@property (nonatomic, retain) NSString *languageId;
@property (nonatomic, retain) NSString *lastLoginDays;
@property (nonatomic, retain) NSString *male;
@property (nonatomic, retain) NSString *female;
@property (nonatomic, retain) NSString *severalPeople;
@property (nonatomic, retain) NSString *hasPhoto;
@property (nonatomic, retain) NSString *verified;
@property (nonatomic, retain) NSString *vouched;
@property (nonatomic, retain) NSString *ambassador;
@property (nonatomic, retain) NSString *wheelchairAccessible;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *keyword;

//  Vytvori a zasle http request, ktery se u CouchSurfu posila
- (void)send;

@end

@protocol CouchSearchRequestDelegate <NSObject>

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers;

@end