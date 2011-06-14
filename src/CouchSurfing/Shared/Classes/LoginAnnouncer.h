//
//  LoginAnnouncer.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// Implementator ohlasuje systemu, ze uzivatel se prave zalogoval

@protocol LoginAnnouncer

- (void)user:(NSString*)username hasLoggedWithPassword:(NSString *)password;
- (void)userHasLoggedOut;

@end
