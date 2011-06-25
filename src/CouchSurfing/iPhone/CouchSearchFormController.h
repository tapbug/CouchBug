//
//  CouchSearchFormController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapableTableView.h"

@class CouchSearchResultController;
@class CouchSearchFilter;

@interface CouchSearchFormController : UIViewController <UITableViewDelegate, UITableViewDataSource, TabableTableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
	CouchSearchResultController *_searchResultController;
    CouchSearchFilter *_filter;
	
	TapableTableView *_formTableView;
	
	UIView *_dialogView;
	
	NSArray *_sections;
	NSArray *_items;
	
	UISwitch *_hasCouchYesCB;
	UISwitch *_hasCouchMaybeCB;
	UISwitch *_hasCouchCoffeOrDrinkCB;
	UISwitch *_hasCouchTravelingCB;
	
	UISwitch *_maleCB;
	UISwitch *_femaleCB;
	UISwitch *_groupCB;
	UISwitch *_hasPhotoCB;
	UISwitch *_wheelchairAccessibleCB;
	UISwitch *_verifiedCB;
	UISwitch *_vouchedCB;
	UISwitch *_ambassadorCB;
	
	UITextField *_usernameTF;
	UITextField *_keywordTF;
	
	BOOL dialogViewOn;
	UIPickerView *_hasSpaceForPickerView;
	UIPickerView *_lastLoginPickerView;
	NSArray *_lastLoginsData;
	
	NSIndexPath *_currentlyHiddenIndexPath;
}

@property (nonatomic, assign) CouchSearchResultController *searchResultController;
@property (nonatomic, assign) CouchSearchFilter *filter;

@end
