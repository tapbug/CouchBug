//
//  CouchSearchResultController.h
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "CouchSearchRequest.h"
#import "CSImageDownloader.h"
#import "CurrentLocationObjectRequest.h"

#import "AdBannerViewOverlap.h"

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
@class LocationDisabledOverlap;

@interface CouchSearchResultController : UIViewController <CouchSearchRequestDelegate, UITableViewDelegate, UITableViewDataSource, CSImageDownloaderDelegate, CurrentLocationObjectRequestDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, ADBannerViewDelegate> {
    CouchSearchFilter *_filter;
    CouchSearchFormControllerFactory *_formControllerFactory;
	ProfileControllerFactory *_profileControllerFactory;
	
    UITableView *_tableView;
	ActivityOverlap *_locateActivity;
    ActivityOverlap *_searchActivity;

	LocationDisabledOverlap *_locationDisabledOverlap;
	CurrentLocationObjectRequest *_locationRequest;
	CLLocationManager *_locationManager;
	//	pouziva se pro zapamatovani kde ma pokracovat searchMore
	CLLocation *_currentLocationLatLng;
	
    CouchSearchRequest *_searchRequest;
    NSMutableDictionary *_imageDownloaders;
    
    //oznacuje, jaky druh loadingu se bude zrovna dit
    CouchSearchResultControllerLoadingActions _loadingAction;
    //cislo aktualni stranky
    NSUInteger _currentPage;
    //zobrazit, nezobrazit show more posledni cell
    BOOL _tryLoadMore;
	//probiha zrovna ted loadovani more vysledku?
	BOOL _isLoadingMore;
    //seznam surferu ktery zobrazujeme
    NSArray *_sourfers;
    //znaci, ze jiz probehlo prvni hledani po zapnuti appky
    BOOL _initialLoadDone;
	//ukazuje se zrovna hlaska  o locationDisabled
	BOOL _locationDisabled;
	
	AdBannerViewOverlap *_adOverlap;
}

@property (nonatomic, assign) CouchSearchFilter *filter;
@property (nonatomic, retain) CouchSearchFormControllerFactory *formControllerFactory;
@property (nonatomic, retain) ProfileControllerFactory *profileControllerFactory;

//  Spusti hledani podle filteru
- (void)performSearch;
//	Zaskroluje nalezeny vysledek nahoru
- (void)scrollToTop;
//	Pri zobrazeni view probehne nove hledani
- (void)shouldReload;
- (void)searchAgainBecauseOfLocationDisabled;
@end
