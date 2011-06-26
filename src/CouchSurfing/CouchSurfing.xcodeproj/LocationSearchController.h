//
//  LocationSearchController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVUrlConnection.h"


@class CouchSearchFilter;
@class ActivityOverlap;

@interface LocationSearchController : UIViewController <UISearchBarDelegate, MVUrlConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
	UISearchBar *_searchBar;
	UITableView *_tableView;

    CouchSearchFilter *_filter;
	MVUrlConnection *_searchConnection;
	
	NSArray *locations;
	ActivityOverlap *_searchActivityOverlap;
}

- (id)initWithFilter:(CouchSearchFilter *)filter;

@end
