//
//  CouchSearchFormController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSearchResultController;

@interface CouchSearchFormController : UIViewController {
	CouchSearchResultController *_searchResultController;
    UITableView *_formTableView;
}

@property (nonatomic, assign) CouchSearchResultController *searchResultController;

@end
