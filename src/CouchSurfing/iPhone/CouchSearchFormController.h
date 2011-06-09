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

@interface CouchSearchFormController : UIViewController {
    CouchSearchResultControllerFactory *_resultControllerFactory;
    CoachSearchRequestFactory *_requestFactory;
        
    UITableView *_formTableView;
}

@property (nonatomic, retain) CoachSearchRequestFactory *requestFactory;
@property (nonatomic, retain) CouchSearchResultControllerFactory *resultControllerFactory;

@end
