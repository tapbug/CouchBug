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
@protocol LocationSearchControllerDelegate;

@interface LocationSearchController : UIViewController <UISearchBarDelegate, MVUrlConnectionDelegate, UITableViewDelegate, UITableViewDataSource> {
	id<LocationSearchControllerDelegate> _delegate;
	UISearchBar *_searchBar;
	UITableView *_tableView;

    CouchSearchFilter *_filter;
	MVUrlConnection *_searchConnection;
	
	NSArray *locations;
	ActivityOverlap *_searchActivityOverlap;
}

@property (nonatomic, assign) id<LocationSearchControllerDelegate> delegate;

- (id)initWithFilter:(CouchSearchFilter *)filter;

@end

@protocol LocationSearchControllerDelegate <NSObject>

- (void)locationSearchDidSelectLocation:(LocationSearchController *)locationSearchController;

@end