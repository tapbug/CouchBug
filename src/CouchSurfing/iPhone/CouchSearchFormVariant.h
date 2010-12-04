//
//  CouchSearchFormVariant.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// Varianta vyhledavaciho formulare
//

@protocol CouchSearchFormVariant

- (UIView *)view;
- (NSString *)name;

@end
