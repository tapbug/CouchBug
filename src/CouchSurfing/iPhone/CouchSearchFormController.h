//
//  CouchSearchFormController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSearchResultControllerFactory;
@class CoachSearchRequestFactory;
@protocol CouchSearchFormVariant;


@interface CouchSearchFormController : UIViewController {
    CouchSearchResultControllerFactory *_resultControllerFactory;
    CoachSearchRequestFactory *_requestFactory;
        
    UISegmentedControl *_variantSC;
    NSArray *_variants;
}

@property (nonatomic, retain) CoachSearchRequestFactory *requestFactory;
@property (nonatomic, retain) CouchSearchResultControllerFactory *resultControllerFactory;

@property (nonatomic, retain) NSArray *variants;

@end
