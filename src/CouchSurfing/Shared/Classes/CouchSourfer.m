//
//  CouchSourfer.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSourfer.h"


@implementation CouchSourfer

@synthesize name = _name;
@synthesize imageSrc = _imageSrc;
@synthesize image = _image;

- (void)dealloc {
    self.name = nil;
    self.imageSrc = nil;
    self.image = nil;
    [super dealloc];
}

@end
