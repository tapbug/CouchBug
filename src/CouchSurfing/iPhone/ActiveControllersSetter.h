//
//  ActiveControllersSetter.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeController;

@protocol ActiveControllersSetter <NSObject>

- (void)setHomeController:(HomeController *)controller;

@end
