//
//  main.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString * const CouchSurferHasCouchYes = @"Y";
NSString * const CouchSurferHasCouchMaybe = @"M";
NSString * const CouchSurferHasCouchCoffeDrink = @"C";
NSString * const CouchSurferHasCouchTraveling = @"T";

NSString * const CouchSurferHasCouchNo = @"N";

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSString *delegateClassName = @"AppDelegate_iPhone";
    
    /*UI_USER_INTERFACE_IDIOM
    if (isDeviceAniPad()) {
        delegateClassName = @"AppDelegate_iPad";
    }
    */

    int retVal = UIApplicationMain(argc, argv, nil, delegateClassName);
    [pool release];
    return retVal;
}