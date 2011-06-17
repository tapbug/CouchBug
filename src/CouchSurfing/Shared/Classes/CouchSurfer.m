//
//  CouchSourfer.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSurfer.h"

@implementation CouchSurfer

@synthesize name;
@synthesize imageSrc;
@synthesize image;
@synthesize about;
@synthesize basics;
@synthesize referencesCount;
@synthesize photosCount;
@synthesize replyRate;
@synthesize couchStatus;
@synthesize verified;
@synthesize vouched;
@synthesize ambassador;

- (void)dealloc {
    self.name = nil;
    self.imageSrc = nil;
    self.image = nil;
    self.about = nil;
    self.basics = nil;
    self.referencesCount = nil;
    self.photosCount = nil;
    self.replyRate = nil;
    [super dealloc];
}

- (NSString *)description {
    return [[[[NSArray alloc] initWithObjects:
            self.about, @"about",
            self.basics, @"basics",
            self.referencesCount, @"referencesCount",
            self.photosCount, @"photosCount",
            self.replyRate, @"replyRate", 
            self.couchStatus, @"couchStatus",
            [NSNumber numberWithBool:self.verified], @"verified", 
            [NSNumber numberWithBool:self.vouched], @"vouched",
            [NSNumber numberWithBool:self.ambassador], @"ambassador",
            nil] autorelease] description];
}

@end
