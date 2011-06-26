//
//  LanguagesListController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CouchSearchFilter;

@protocol LanguagesListControllerDelegate;

@interface LanguagesListController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	id<LanguagesListControllerDelegate> _delegate;
	
    UITableView *_tableView;
	NSMutableArray *_languagesGroups;
	NSMutableArray *_alphabet;
	NSMutableDictionary *_languageToIdDictionary;
	
	CouchSearchFilter *_filter;
}

@property (nonatomic, assign) id<LanguagesListControllerDelegate> delegate;

- (id)initWithFilter:(CouchSearchFilter *)filter;

@end


@protocol LanguagesListControllerDelegate <NSObject>

- (void)languagesListDidSelectLanguage:(LanguagesListController *)languagesList;

@end