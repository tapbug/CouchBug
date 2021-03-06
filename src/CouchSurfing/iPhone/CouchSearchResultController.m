//
//  CouchSearchResultController.m
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//


#import "CouchSearchResultController.h"

#import "CSImageCropper.h"

#import "ActivityOverlap.h"
#import "CouchSearchResultCell.h"

#import "CouchSearchFilter.h"
#import "CouchSearchFormControllerFactory.h"
#import "CouchSearchFormController.h"
#import "ProfileControllerFactory.h"
#import "ProfileController.h"
#import "CouchSearchRequest.h"
#import "CouchSurfer.h"
#import "CSTools.h"

#import "ProfileController.h"
#import "LocationDisabledOverlap.h"
#import "FlurryAPI.h"

@interface CouchSearchResultController ()

@property (nonatomic, retain) ActivityOverlap *locateActivity;
@property (nonatomic, retain) ActivityOverlap *searchActivity;

@property (nonatomic, retain) NSArray *sourfers;
@property (nonatomic, retain) NSMutableDictionary *imageDownloaders;

@property (nonatomic, retain) CurrentLocationObjectRequest *locationObjectRequest;
@property (nonatomic, retain) LocationDisabledOverlap *locationDisabledOverlap;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *currentLocationLatLng;

@property (nonatomic, retain) CouchSearchRequest *searchRequest;
@property (nonatomic, retain) AdBannerViewOverlap *adOverlap;

//	Zjisti  current lokaci jako objekt (nazev, id ...) pro CouchSurfing
- (void)gatherCurrentLocationObjectAndSearch;
//	Zjisti current lokaci jako latLng pro hledani v rectangle na CouchSurfing
- (void)gatherCurrentLocationLatLngAndSearch;
//	spusti hledaci cast (dalsi casti jsou zjistovani pozice)
- (void)performSearchRequest;
//  Spusti vyhledavani dalsich vysledku (strankovani)
- (void)performSearchMore;

- (void)showSearchForm;

- (void)loadImages;
- (void)loadImageForIndex:(NSInteger)index surfer:(CouchSurfer *)surfer;

@end


@implementation CouchSearchResultController

@synthesize filter = _filter;
@synthesize formControllerFactory = _formControllerFactory;
@synthesize profileControllerFactory = _profileControllerFactory;
@synthesize locateActivity = _locateActivity;
@synthesize searchActivity = _searchActivity;
@synthesize locationDisabledOverlap = _locationDisabledOverlap;
@synthesize sourfers = _sourfers;
@synthesize imageDownloaders = _imageDownloaders;
@synthesize locationObjectRequest = _locationRequest;
@synthesize locationManager = _locationManager;
@synthesize currentLocationLatLng = _currentLocationLatLng;

@synthesize searchRequest = _searchRequest;

@synthesize adOverlap = _adOverlap;

- (void)viewDidLoad {
    _currentPage = 1;
	self.navigationItem.title = NSLocalizedString(@"COUCHSEARCH", nil);
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"worldBg"]];
    self.navigationItem.rightBarButtonItem =
		[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"FILTER", nil) style:UIBarButtonItemStyleBordered 
										 target:self
										 action:@selector(showSearchForm)] autorelease];

	 _tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    _tableView.backgroundView = nil;
	_tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = self.view.autoresizingMask;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

	self.locateActivity =
	[[ActivityOverlap alloc] initWithView:self.view 
									title:NSLocalizedString(@"LOCATING", nil)];
    
    self.searchActivity =
        [[ActivityOverlap alloc] initWithView:self.view 
                                        title:NSLocalizedString(@"LOADING COUCHES", nil)];
    
    self.imageDownloaders = [NSMutableDictionary dictionary];
	self.navigationController.delegate = self;
	
	self.adOverlap = [[[AdBannerViewOverlap alloc] initWithContentView:_tableView] autorelease];
	self.adOverlap.adBannerView.delegate = self;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.adOverlap setCurrentContentSize];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!_initialLoadDone) {
		[self performSearch];
    }
    _initialLoadDone = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark CoachSearchRequest methods

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers {
    if (_loadingAction == CouchSearchResultControllerFirst) {
		self.imageDownloaders = [NSMutableDictionary dictionary];
        self.sourfers = sourfers;
        [self.searchActivity removeOverlap];        
    } else if (_loadingAction == CouchSearchResultControllerMore) {
        self.sourfers = [self.sourfers arrayByAddingObjectsFromArray:sourfers];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		_isLoadingMore = NO;
    }
    
    if ([sourfers count] <10) {
        _tryLoadMore = NO;
    } else {
        _tryLoadMore = YES;
    }
    
    [_tableView reloadData];
    [_tableView flashScrollIndicators];
    self.searchRequest = nil;
    
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = [self.sourfers count];
    if (_tryLoadMore == YES) {
        count += 1;
    }
    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell;
    
    if ([self.sourfers count] == indexPath.row && _tryLoadMore) {// vytvoreni bunky load more
        cell = [tableView dequeueReusableCellWithIdentifier:@"loadingMoreCell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingMoreCell"] autorelease];
            //Setup indicator view
            UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [activityView startAnimating];
            
            //setup label
            UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(activityView.frame.size.width + 5, 0, 0, 0)] autorelease];
            loadingLabel.backgroundColor = [UIColor clearColor];
            loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            loadingLabel.text = NSLocalizedString(@"LOADING COUCHES", nil);
            [loadingLabel sizeToFit];
            
            //setup containing view
            CGFloat loadingViewWidth = loadingLabel.frame.origin.x + loadingLabel.frame.size.width;
            CGFloat loadingViewHeight = loadingLabel.frame.size.height;
            UIView *loadingView = [[[UIView alloc] initWithFrame:CGRectMake((int)(cell.contentView.frame.size.width - loadingViewWidth) / 2, (int)(cell.contentView.frame.size.height - loadingViewHeight) / 2, loadingViewWidth, loadingViewHeight)] autorelease];
            loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [loadingView addSubview:activityView];
            [loadingView addSubview:loadingLabel];
            
            [cell.contentView addSubview:loadingView];            
        }
        
    } else { // Vytvoreni bunky s couchsurferem
        CouchSearchResultCell *surferCell = (CouchSearchResultCell *)[tableView dequeueReusableCellWithIdentifier:@"surferCell"];
        if (surferCell == nil) {
            surferCell = [[[CouchSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surferCell"] autorelease];
            surferCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchRowBg.png"]] autorelease];

            
        } else { //reset reused obrazku
            [surferCell resetCell];
        }
        
        CouchSurfer *surfer = [self.sourfers objectAtIndex:indexPath.row];
        surferCell.nameLabel.text = surfer.name;
        surferCell.basicsLabel.text = surfer.basics;
        surferCell.aboutLabel.text = surfer.about;
        surferCell.referencesCountLabel.text = surfer.referencesCount;
        surferCell.photosCountLabel.text = surfer.photosCount;
        surferCell.replyRateCountLabel.text = [NSString stringWithFormat:@"%@%", surfer.replyRate];
        
        if (surfer.verified) {
            surferCell.verifiedImageView.hidden = NO;
        } else {
            surferCell.verifiedImageView.hidden = YES;
        }
        
        surferCell.hasCouchView.image = surfer.couchStatusImage;
        
        surferCell.vouchedView.hidden = !surfer.vouched;
        surferCell.ambassadorView.hidden = !surfer.ambassador;
        
        [surferCell makeLayout];
        
        if (surfer.image == nil) {
            if (tableView.dragging == NO && tableView.decelerating == NO) {
				[self loadImageForIndex:indexPath.row surfer:surfer];
            }
        } else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
				UIImage *croppedImage = [[CSImageCropper scaleToSize:CGSizeMake(61, 61) image:surfer.image] retain];
				dispatch_async(dispatch_get_main_queue(), ^{
					surferCell.photoView.image = croppedImage;
					[croppedImage release];
				});
			});
			
        }
        cell = surferCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.sourfers count] - 3 && _tryLoadMore && _isLoadingMore == NO) {//indexpath loading cellu
        [self performSearchMore];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.sourfers count] == indexPath.row && _tryLoadMore) {
        return 44;
    } else {
        return 98;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.sourfers count] > indexPath.row) {
		CouchSurfer *surfer = [self.sourfers objectAtIndex:indexPath.row];
		ProfileController *profileController = 
			[self.profileControllerFactory createProfileControllerWithSurfer:surfer];
		
		profileController.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:profileController animated:YES];
	}
}

#pragma mark CSImageDownloaderDelegate methods

- (void)imageDownloader:(CSImageDownloader *)imageDownloader
	  didDownloadImage :(UIImage *)image 
			forPosition:(NSInteger)position {
	
    CouchSurfer *sourfer = [self.sourfers objectAtIndex:position];
    sourfer.image = image;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:position inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];        
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [self loadImages];
    }
}

#pragma mark LifeCycle methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
								duration:(NSTimeInterval)duration
{
	[self.adOverlap willRotateAnimation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self.adOverlap didRotateAnimation];
}

- (void)dealloc {
	self.locationObjectRequest.delegate = nil;
	self.locationObjectRequest = nil;
	self.locationManager.delegate = nil;
	self.locationManager = nil;
    self.searchRequest.delegate = nil;
    self.searchRequest = nil;
	self.locationDisabledOverlap = nil;
	self.locateActivity = nil;	
	self.searchActivity = nil;
    self.imageDownloaders = nil;
    self.sourfers = nil;
	self.formControllerFactory = nil;
	self.profileControllerFactory = nil;
	self.adOverlap = nil;
    [super dealloc];
}

#pragma Mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	self.adOverlap.adLoaded = YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	self.adOverlap.adLoaded = NO;
}

#pragma Mark CurrentLocationRequestDelegate methods

- (void)currentLocationObjectRequest:(CurrentLocationObjectRequest *)request didGatherLocation:(NSDictionary *)location {
	self.filter.locationJSON = location;
	[self.locateActivity removeOverlap];
	[self performSearchRequest];
}

#pragma Mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation {
	
	self.currentLocationLatLng = newLocation;
	[manager stopUpdatingLocation];
	[self.locateActivity removeOverlap];
	[self performSearchRequest];
	
	[FlurryAPI setLatitude:newLocation.coordinate.latitude
				 longitude:newLocation.coordinate.longitude
		horizontalAccuracy:newLocation.horizontalAccuracy
		  verticalAccuracy:newLocation.verticalAccuracy]; 
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[manager stopUpdatingLocation];
	[self.locateActivity removeOverlap];
	if (error) {
		
		if ([error code] == kCLErrorDenied) {
			if (self.locationDisabledOverlap == nil) {
				self.locationDisabledOverlap = [[LocationDisabledOverlap alloc] initWithView:self.view
																					   title:NSLocalizedString(@"LOCATION WARNING TITLE", nil)
																						body:NSLocalizedString(@"LOCATION WARNING BODY", nil)];				
			}
			[self.locationDisabledOverlap overlapView];
			_locationDisabled = YES;
		} else {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
																message:NSLocalizedString(@"LOCATION NOT FOUND", nil)
															   delegate:nil
													  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
			[alertView show];
			[alertView release]; alertView = nil;
			[self showSearchForm];
		}
	}
}

#pragma Mark UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (viewController == self) {
		[_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
	}
}

#pragma Mark Action methods

- (void)showSearchForm {
	[self.locationDisabledOverlap removeOverlap];
	[self.locateActivity removeOverlap];
	CouchSearchFormController *formController = [self.formControllerFactory createController];
	formController.searchResultController = self;
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:formController] autorelease];
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:navController animated:YES];
}

#pragma mark Private methods

- (void)performSearchRequest {
	[self scrollToTop];
    _loadingAction = CouchSearchResultControllerFirst;
    [self.searchActivity overlapView];
	CouchSearchRequest *request = [self.filter createRequest];
	request.delegate = self;
	request.latLngLocation = self.currentLocationLatLng;
	self.searchRequest = request;
		
	[self.searchRequest send];
	
	[FlurryAPI logEvent:@"Search"];
}

- (void)performSearchMore {
	_isLoadingMore = YES;
    _loadingAction = CouchSearchResultControllerMore;
    CouchSearchRequest *request = [self.filter createRequest];
    request.delegate = self;
	request.latLngLocation = self.currentLocationLatLng;
    self.searchRequest = request;
    request.page = [NSString stringWithFormat:@"%d", ++_currentPage];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.searchRequest send];
    
}

- (void)loadImages {
    NSMutableArray *indexPaths = [[_tableView indexPathsForVisibleRows] mutableCopy];
    if (_tryLoadMore) {
        NSIndexPath *lastIndexPath = [indexPaths lastObject];
        if (lastIndexPath.row == [self.sourfers count]) {
            [indexPaths removeLastObject];
        }
    }
    
    NSUInteger lastRow = 0;
    for (NSIndexPath *indexPath in indexPaths) {
        lastRow = indexPath.row;
        CouchSurfer *sourfer = [self.sourfers objectAtIndex:indexPath.row];
        if (sourfer.image == nil) {
			[self loadImageForIndex:indexPath.row surfer:sourfer];
        }
    }
    if ([self.sourfers count] > 0) {
		for(NSUInteger i = 1; i <= 2; i++) {
			NSUInteger rowToLoad = lastRow + i;
			int lastRowPosition = [self.sourfers count] - 1;
			if (lastRowPosition >= rowToLoad) {
				CouchSurfer *sourfer = [self.sourfers objectAtIndex:lastRow + i];
				if (sourfer.image == nil) {
					[self loadImageForIndex:lastRow + 1 surfer:sourfer];
				}
			} else {
				break;
			}
		}
	}
	[indexPaths release]; indexPaths = nil;
}

- (void)gatherCurrentLocationObjectAndSearch {
	[self.locateActivity overlapView];
	self.locationObjectRequest = [[[CurrentLocationObjectRequest alloc] init] autorelease];
	self.locationObjectRequest.delegate = self;
	[self.locationObjectRequest gatherCurrentLocation];
}

- (void)gatherCurrentLocationLatLngAndSearch {
	[self.locateActivity overlapView];
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
}

#pragma Mark Public methods

- (void)performSearch {
	[self.locationDisabledOverlap removeOverlap];
	_locationDisabled = NO;
	self.currentLocationLatLng = nil;
	if (self.filter.currentLocationRectSearch == YES) {
		[self gatherCurrentLocationLatLngAndSearch];
	} else {
		[self performSearchRequest];
	}
}

- (void)scrollToTop {
    if ([self.sourfers count] > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];        
    }	
}

- (void)shouldReload {
	_initialLoadDone = NO;
}

- (void)searchAgainBecauseOfLocationDisabled {
	if (_locationDisabled) {
		BOOL searched = NO;
		if ([self.tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
			if ([(UINavigationController *)self.tabBarController.selectedViewController topViewController] == self) {
				[self performSearch];
				searched = YES;
			}
		}
		if (searched == NO) {
			_initialLoadDone = NO;
		}
	}
}

- (void)loadImageForIndex:(NSInteger)index surfer:(CouchSurfer *)surfer {
	if ([self.imageDownloaders objectForKey:[NSNumber numberWithInt:index]] == nil) {
		[self.imageDownloaders setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:index]];
		CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
		imageDownloader.delegate = self;
		[imageDownloader downloadWithSrc:surfer.imageSrc position:index];
		[imageDownloader release];		
	}
}

@end
