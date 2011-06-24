//
//  CouchSearchFormController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSearchResultController;
@class CouchSearchFilter;

@interface CouchSearchFormController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate> {
	CouchSearchResultController *_searchResultController;
    CouchSearchFilter *_filter;
	
	UITableView *_formTableView;
	
	UIView *_dialogView;
	
	NSArray *_sections;
	NSArray *_items;
	
	NSMutableDictionary *_switches;
	NSMutableDictionary *_fields;
	
	UIPickerView *_hasSpaceForPickerView;
	NSUInteger _hasSpaceFor;
}

@property (nonatomic, assign) CouchSearchResultController *searchResultController;
@property (nonatomic, assign) CouchSearchFilter *filter;

@end
