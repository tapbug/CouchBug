//
//  CouchSearchResultController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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

@interface CouchSearchResultController ()

@property (nonatomic, retain) ActivityOverlap *locateActivity;
@property (nonatomic, retain) ActivityOverlap *searchActivity;

@property (nonatomic, retain) NSArray *sourfers;
@property (nonatomic, retain) NSMutableArray *imageDownloaders;

@property (nonatomic, retain) CurrentLocationRequest *locationRequest;
@property (nonatomic, retain) CouchSearchRequest *searchRequest;

- (void)gatherCurrentLocation;
- (void)showSearchForm;

//  Spusti vyhledavani dalsich vysledku (strankovani)
- (void)performSearchMore;
- (void)loadImages;

@end


@implementation CouchSearchResultController

@synthesize filter = _filter;
@synthesize formControllerFactory = _formControllerFactory;
@synthesize profileControllerFactory = _profileControllerFactory;
@synthesize locateActivity = _locateActivity;
@synthesize searchActivity = _searchActivity;

@synthesize sourfers = _sourfers;
@synthesize imageDownloaders = _imageDownloaders;
@synthesize locationRequest = _locationRequest;
@synthesize searchRequest = _searchRequest;

- (void)viewDidLoad {
    _currentPage = 1;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                      target:self
                                                      action:@selector(showSearchForm)];
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
    
    self.imageDownloaders = [NSMutableArray array];
	self.navigationController.delegate = self;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!_initialLoadDone) {
		if (self.filter.locationJSON == nil) {
			//[self gatherCurrentLocation];
			[self performSearch];
		} else {
			[self performSearch];
		}
    }
    _initialLoadDone = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"worldBg"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark CoachSearchRequest methods

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers {
    if (_loadingAction == CouchSearchResultControllerFirst) {
        self.sourfers = sourfers;
        [self.searchActivity removeOverlap];        
    } else if (_loadingAction == CouchSearchResultControllerMore) {
        self.sourfers = [self.sourfers arrayByAddingObjectsFromArray:sourfers];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
                CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
                imageDownloader.delegate = self;
                [imageDownloader downloadWithSrc:surfer.imageSrc position:indexPath.row];
                [imageDownloader release];
            }
        } else {
            surferCell.photoView.image = [CSImageCropper scaleToSize:CGSizeMake(61, 61) image:surfer.image];
        }
        cell = surferCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.sourfers count] - 3 && _tryLoadMore) {//indexpath loading cellu
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


- (void)dealloc {
	self.locationRequest.delegate = nil;
	self.locationRequest = nil;
    self.searchRequest.delegate = nil;
    self.searchRequest = nil;
    for (CSImageDownloader *downloader in self.imageDownloaders) {
        downloader.delegate = nil;
    }
	self.locateActivity = nil;	
	self.searchActivity = nil;
    self.imageDownloaders = nil;
    self.sourfers = nil;
	self.formControllerFactory = nil;
	self.profileControllerFactory = nil;
    [super dealloc];
}

#pragma Mark CurrentLocationRequestDelegate methods

- (void)currentLocationRequest:(CurrentLocationRequest *)request didGatherLocation:(NSDictionary *)location {
	self.filter.locationJSON = location;
	[self.locateActivity removeOverlap];
	[self performSearch];
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
	CouchSearchFormController *formController = [self.formControllerFactory createController];
	formController.searchResultController = self;
	UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:formController] autorelease];
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:navController animated:YES];
}

#pragma mark Private methods

- (void)performSearch {
	[self scrollToTop];
    _loadingAction = CouchSearchResultControllerFirst;
    [self.searchActivity overlapView];
    CouchSearchRequest *request = [self.filter createRequest];
    request.delegate = self;
    self.searchRequest = request;
    
    [self.searchRequest send];
}

- (void)performSearchMore {
    _loadingAction = CouchSearchResultControllerMore;
    CouchSearchRequest *request = [self.filter createRequest];
    request.delegate = self;
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
            CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
            imageDownloader.delegate = self;
            [imageDownloader downloadWithSrc:sourfer.imageSrc position:indexPath.row];
            [imageDownloader release];            
        }
    }
    if ([self.sourfers count] > 0) {
		for(NSUInteger i = 1; i <= 2; i++) {
			NSUInteger rowToLoad = lastRow + i;
			int lastRowPosition = [self.sourfers count] - 1;
			if (lastRowPosition >= rowToLoad) {
				CouchSurfer *sourfer = [self.sourfers objectAtIndex:lastRow + i];
				if (sourfer.image == nil) {
					CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
					imageDownloader.delegate = self;
					[imageDownloader downloadWithSrc:sourfer.imageSrc position:lastRow + i];
					[imageDownloader release];
				}
			} else {
				break;
			}
		}
	}
	[indexPaths release]; indexPaths = nil;
}

- (void)gatherCurrentLocation {
	[self.locateActivity overlapView];
	self.locationRequest = [[[CurrentLocationRequest alloc] init] autorelease];
	self.locationRequest.delegate = self;
	[self.locationRequest gatherCurrentLocation];
}

#pragma Public methods

- (void)scrollToTop {
    if ([self.sourfers count] > 0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];        
    }	
}

@end
