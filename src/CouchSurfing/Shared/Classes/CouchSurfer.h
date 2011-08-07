//
//  CouchSourfer.h
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString CouchSurferHasCouch;

extern CouchSurferHasCouch * const CouchSurferHasCouchYes;
extern CouchSurferHasCouch * const CouchSurferHasCouchMaybe;
extern CouchSurferHasCouch * const CouchSurferHasCouchCoffeDrink;
extern CouchSurferHasCouch * const CouchSurferHasCouchTraveling;

extern CouchSurferHasCouch * const CouchSurferHasCouchNo;

@interface CouchSurfer : NSObject {
	NSString *ident;
    NSString *name;
	NSString *livesIn;
	NSString *lastLoginLocation;
	NSString *lastLoginDate;
    NSString *imageSrc;
    UIImage *image;
    
    NSString *gender;
    NSString *age;
    NSString *job;
    
    NSString *about; //zkraceny personalHtml
	NSString *mission;
    NSString *referencesCount;
    NSString *photosCount;
    NSString *replyRate;
	NSString *friendsCount;
    CouchSurferHasCouch *couchStatus;
    BOOL verified;
    BOOL vouched;
    BOOL ambassador;
	
	NSString *personalDescription;
	NSString *couchInfoShort;
	NSString *couchInfoHtml;
	NSString *preferredGender;
	NSString *maxSurfersPerNight;
	NSString *sharedSleepSurface;
	NSString *sharedRoom;
	
	BOOL profileDataLoaded;
}

@property (nonatomic, retain) NSString *ident;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *livesIn;
@property (nonatomic, retain) NSString *lastLoginLocation;
@property (nonatomic, retain) NSString *lastLoginDate;

@property (nonatomic, retain) NSString *imageSrc;
@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *job;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *mission;

@property (nonatomic, readonly) NSString *basics;
@property (nonatomic, readonly) NSString *basicsForProfile;
@property (nonatomic, retain) NSString *referencesCount;
@property (nonatomic, retain) NSString *photosCount;
@property (nonatomic, retain) NSString *replyRate;
@property (nonatomic, retain) NSString *friendsCount;
@property (nonatomic, assign) CouchSurferHasCouch *couchStatus;
@property (nonatomic, readonly) UIImage *couchStatusImage;
@property (nonatomic, readonly) NSString *couchStatusName;

@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL vouched;
@property (nonatomic, assign) BOOL ambassador;

@property (nonatomic, retain) NSString *personalDescription;
@property (nonatomic, retain) NSString *couchInfoShort;
@property (nonatomic, retain) NSString *couchInfoHtml;

@property (nonatomic, retain) NSString *preferredGender;
@property (nonatomic, retain) NSString *maxSurfersPerNight;
@property (nonatomic, retain) NSString *sharedSleepSurface;
@property (nonatomic, retain) NSString *sharedRoom;

@property (nonatomic, assign) BOOL profileDataLoaded;

- (BOOL)hasSomeCouchInfo;

@end
