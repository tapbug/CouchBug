//
//  CouchSourfer.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSurfer.h"

static NSDictionary *hasCouchIcons;

@interface CouchSurfer ()

@end

@implementation CouchSurfer

@synthesize ident;
@synthesize name;
@synthesize livesIn;
@synthesize lastLoginLocation;
@synthesize lastLoginDate;
@synthesize imageSrc;
@synthesize image;
@synthesize gender;
@synthesize age;
@synthesize job;
@synthesize about;
@synthesize referencesCount;
@synthesize photosCount;
@synthesize replyRate;
@synthesize couchStatus;
@synthesize verified;
@synthesize vouched;
@synthesize ambassador;
@synthesize mission;

- (void)dealloc {
	self.ident = nil;
    self.name = nil;
	self.livesIn = nil;
	self.lastLoginLocation = nil;
	self.lastLoginDate = nil;
    self.imageSrc = nil;
    self.image = nil;
    self.about = nil;
    self.gender = nil;
    self.age = nil;
    self.job = nil;
	self.mission = nil;
    self.referencesCount = nil;
    self.photosCount = nil;
    self.replyRate = nil;
    [super dealloc];
}

+ (void)initialize {
    hasCouchIcons = [[NSDictionary alloc] initWithObjectsAndKeys:[UIImage imageNamed:@"couchYes"], CouchSurferHasCouchYes,
                     [UIImage imageNamed:@"couchNo"], CouchSurferHasCouchNo,
                     [UIImage imageNamed:@"couchTravel"], CouchSurferHasCouchTraveling,
                     [UIImage imageNamed: @"couchMaybe"], CouchSurferHasCouchMaybe,
                     [UIImage imageNamed:@"couchCoffee"], CouchSurferHasCouchCoffeDrink,
                     nil];
}

- (NSString *)basics {
    NSMutableString *basics = [[self.gender mutableCopy] autorelease];
    if (![self.age isEqualToString:@""]) {
        [basics appendFormat:@" • %@", self.age];
    }
    if (![self.job isEqualToString:@""]) {
        [basics appendFormat:@" • %@", self.job];
    }
    return basics;
}

- (NSString *)basicsForProfile {
	NSString *longGender = nil;
	
	if ([self.gender isEqualToString:@"M"]) {
		longGender = NSLocalizedString(@"male", nil);
	} else if ([self.gender isEqualToString:@"F"]){
		longGender = NSLocalizedString(@"female", nil);
	} else if ([self.gender isEqualToString:@"Group"]) {
		longGender = NSLocalizedString(@"Group", nil);
	}
	
	NSMutableString *basics = [[longGender mutableCopy] autorelease];
	if (![self.age isEqualToString:@""]) {
        [basics appendFormat:@" • %@", self.age];
    }
	return basics;
}

- (UIImage *)couchStatusImage {
	if (self.couchStatus != nil && [hasCouchIcons objectForKey:self.couchStatus]) {
		return [hasCouchIcons objectForKey:self.couchStatus];
	}
	return nil;
}

@end
