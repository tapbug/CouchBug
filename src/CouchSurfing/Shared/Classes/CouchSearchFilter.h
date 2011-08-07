//
//  CouchSearchFilter.h
//  CouchSurfing
//
//  Created on 6/10/11.
//  Copyright 2011 tapbug. All rights reserved.
//

//  Trida ma za ukol drzet aktualni filter pro hledani
//  Tzn. to, jak je nastaveny vyhledavaci formular

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CouchSearchRequest;

@interface CouchSearchFilter : NSObject {
    NSString *location;
	BOOL currentLocationRectSearch;
	
	BOOL hasCouchYes;
	BOOL hasCouchMaybe;
	BOOL hasCouchCoffeeOrDrink;
	BOOL hasCouchTraveling;
	
    NSUInteger ageLow;
    NSUInteger ageHigh;
    NSUInteger maxSurfers;
    NSString *languageId;
	NSString *languageName;
    NSUInteger lastLoginDays;
    BOOL male;
    BOOL female;
    BOOL severalPeople;
    BOOL hasPhoto;
    BOOL verified;
    BOOL vouched;
    BOOL ambassador;
	BOOL wheelchairAccessible;
    NSString *username;
    NSString *keyword;

}

@property (nonatomic , retain) NSDictionary *locationJSON;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, assign) BOOL currentLocationRectSearch;

@property (nonatomic, assign) BOOL hasCouchYes;
@property (nonatomic, assign) BOOL hasCouchMaybe;
@property (nonatomic, assign) BOOL hasCouchCoffeeOrDrink;
@property (nonatomic, assign) BOOL hasCouchTraveling;

@property (nonatomic, assign) NSUInteger ageLow;
@property (nonatomic, assign) NSUInteger ageHigh;
@property (nonatomic, assign) NSUInteger maxSurfers;
@property (nonatomic, retain) NSString *languageId;
@property (nonatomic, retain) NSString *languageName;
@property (nonatomic, assign) NSUInteger lastLoginDays;
@property (nonatomic, assign) BOOL male;
@property (nonatomic, assign) BOOL female;
@property (nonatomic, assign) BOOL severalPeople;
@property (nonatomic, assign) BOOL hasPhoto;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL vouched;
@property (nonatomic, assign) BOOL ambassador;
@property (nonatomic, assign) BOOL wheelchairAccessible;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *keyword;

//  Vytovorit request hledani couche, z vyplnenych parametru filtru 
- (CouchSearchRequest *)createRequest;

@end
