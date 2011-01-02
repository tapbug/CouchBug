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


@interface CouchSearchFormController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    CouchSearchResultControllerFactory *_resultControllerFactory;
    CoachSearchRequestFactory *_requestFactory;
        
    UISegmentedControl *_variantSC;
    UITableView *_formTableView;
    NSArray *_variants;
    id<CouchSearchFormVariant> _currentVariant;
}

@property (nonatomic, retain) CoachSearchRequestFactory *requestFactory;
@property (nonatomic, retain) CouchSearchResultControllerFactory *resultControllerFactory;

@property (nonatomic, retain) NSArray *variants;

@end
