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

- (void)dealloc {
    self.name = nil;
    self.imageSrc = nil;
    self.image = nil;
    self.about = nil;
    self.gender = nil;
    self.age = nil;
    self.job = nil;
    self.referencesCount = nil;
    self.photosCount = nil;
    self.replyRate = nil;
    [super dealloc];
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

@end
