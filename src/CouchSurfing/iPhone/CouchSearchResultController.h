//
//  CouchSearchResultController.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CouchSearchRequest.h"
#import "CSImageDownloader.h"
#import "CurrentLocationRequest.h"

//  Konstanty stavu, ktere rikaji co se zrovna deje
typedef enum {
    CouchSearchResultControllerFirst,   //prvni loading
    CouchSearchResultControllerMore     //loadovani dalsich vysledku
} CouchSearchResultControllerLoadingActions;

@class CouchSearchRequest;
@class CouchSearchFilter;
@class CouchSearchFormControllerFactory;
@class ActivityOverlap;
@class ProfileControllerFactory;

@interface CouchSearchResultController : UIViewController <CouchSearchRequestDelegate, UITableViewDelegate, UITableViewDataSource, CSImageDownloaderDelegate, CurrentLocationRequestDelegate, UINavigationControllerDelegate> {
    CouchSearchFilter *_filter;
    CouchSearchFormControllerFactory *_formControllerFactory;
	ProfileControllerFactory *_profileControllerFactory;
	
    UITableView *_tableView;
	ActivityOverlap *_locateActivity;
    ActivityOverlap *_searchActivity;

	CurrentLocationRequest *_locationRequest;
    CouchSearchRequest *_searchRequest;
    NSMutableArray *_imageDownloaders;
    
    //oznacuje, jaky druh loadingu se zrovna deje
    CouchSearchResultControllerLoadingActions _loadingAction;
    //cislo aktualni stranky
    NSUInteger _currentPage;
    //zobrazit, nezobrazit show more posledni cell
    BOOL _tryLoadMore;
    //seznam surferu ktery zobrazujeme
    NSArray *_sourfers;
    //znaci, ze jiz probehlo prvni hledani po zapnuti appky
    BOOL _initialLoadDone;
}

@property (nonatomic, assign) CouchSearchFilter *filter;
@property (nonatomic, retain) CouchSearchFormControllerFactory *formControllerFactory;
@property (nonatomic, retain) ProfileControllerFactory *profileControllerFactory;

//  Spusti hledani podle filteru
- (void)performSearch;
//	Zaskroluje nalezeny vysledek nahoru
- (void)scrollToTop;

@end
