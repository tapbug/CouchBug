//
//  ActiveControllersSetter.h
//  CouchSurfing
//
//  Created on 8/5/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeController;

@protocol ActiveControllersSetter <NSObject>

- (void)setHomeController:(HomeController *)controller;

@end
