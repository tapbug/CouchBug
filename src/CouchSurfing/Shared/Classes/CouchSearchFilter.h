//
//  CouchSearchFilter.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//  Trida ma za ukol drzet aktualni filter pro hledani
//  Tzn. to, jak je nastaveny vyhledavaci formular

#import <Foundation/Foundation.h>

@class CouchSearchRequest;

@interface CouchSearchFilter : NSObject {
    NSString *location;
    NSArray *couchStatuses;
    NSString *ageLow;
    NSString *ageHigh;    
    NSString *maxSurfers;
    NSString *laguageId;
    NSString *lastLoginDays;
    NSString *male;
    NSString *female;
    NSString *severalPeople;
    NSString *hasPhoto;
    NSString *verified;
    NSString *vouched;
    NSString *ambassador;

    NSString *wheelchairAccessible;
    NSString *username;
    NSString *keyword;

}

@property (nonatomic, retain) NSString *location;
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

//  Vytovorit request hledani couche, z vyplnenych parametru filtru 
- (CouchSearchRequest *)createRequest;

@end
