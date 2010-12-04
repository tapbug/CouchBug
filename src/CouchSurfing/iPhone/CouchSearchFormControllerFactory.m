//
//  CouchSearchFormControllerFactory.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFormControllerFactory.h"
#import "CouchSearchRequestFactory.h"
#import "CouchSearchFormController.h"
#import "CouchSearchBasicFormVariant.h"
#import "CouchSearchAdvancedFormVariant.h"

@implementation CouchSearchFormControllerFactory

@synthesize requestFactory = injRequestFactory;
@synthesize resultControllerFactory = injResultControllerFactory;
@synthesize basicVariant = injBasicVariant;
@synthesize advancedVariant = injAdvancedVariant;

- (id)createController {
    CouchSearchFormController *controller = [[[CouchSearchFormController alloc] init] autorelease];
    controller.requestFactory = (id)self.requestFactory;
    controller.resultControllerFactory = self.resultControllerFactory;
    controller.variants = [NSArray arrayWithObjects:self.basicVariant, self.advancedVariant, nil];
    return controller;
}

- (void)dealloc {
    self.requestFactory = nil;
    self.resultControllerFactory = nil;
    [super dealloc];
}

@end
