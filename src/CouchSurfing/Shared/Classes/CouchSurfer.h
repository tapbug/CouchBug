//
//  CouchSourfer.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString CouchSurferHasCouch;

extern CouchSurferHasCouch * const CouchSurferHasCouchYes;
extern CouchSurferHasCouch * const CouchSurferHasCouchMaybe;
extern CouchSurferHasCouch * const CouchSurferHasCouchCoffeDrink;
extern CouchSurferHasCouch * const CouchSurferHasCouchTraveling;

extern CouchSurferHasCouch * const CouchSurferHasCouchNo;

@interface CouchSurfer : NSObject {
    NSString *name;
    NSString *imageSrc;
    UIImage *image;
    
    NSString *gender;
    NSString *age;
    NSString *job;
    
    NSString *about;
    NSString *referencesCount;
    NSString *photosCount;
    NSString *replyRate;
    CouchSurferHasCouch *couchStatus;
    BOOL verified;
    BOOL vouched;
    BOOL ambassador;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageSrc;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *job;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, readonly) NSString *basics;
@property (nonatomic, retain) NSString *referencesCount;
@property (nonatomic, retain) NSString *photosCount;
@property (nonatomic, retain) NSString *replyRate;
@property (nonatomic, assign) CouchSurferHasCouch *couchStatus; 
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL vouched;
@property (nonatomic, assign) BOOL ambassador;

@end
