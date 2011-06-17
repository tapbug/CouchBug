//
//  CouchSearchResultController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchResultController.h"

#import "ActivityOverlap.h"
#import "CouchSearchResultCell.h"

#import "CouchSearchFilter.h"
#import "CouchSearchRequest.h"
#import "CouchSurfer.h"
#import "CSTools.h"

@interface CouchSearchResultController ()

@property (nonatomic, retain) ActivityOverlap *loadingActivity;

@property (nonatomic, retain) NSArray *sourfers;
@property (nonatomic, retain) NSMutableArray *imageDownloaders;
@property (nonatomic, retain) CouchSearchRequest *request;

//  Spusti hledani podle filteru
- (void)performSearch;
//  Spusti vyhledavani dalsich vysledku (strankovani)
- (void)performSearchMore;
- (void)loadImages;

@end


@implementation CouchSearchResultController

@synthesize filter = _filter;

@synthesize loadingActivity = _loadingActivity;

@synthesize sourfers = _sourfers;
@synthesize imageDownloaders = _imageDownloaders;
@synthesize request = _request;

- (void)viewDidLoad {
    _currentPage = 1;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                      target:self
                                                      action:@selector(showSearchForm)];
    _tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    _tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"worldBg"]] autorelease];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = self.view.autoresizingMask;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.loadingActivity =
        [[ActivityOverlap alloc] initWithView:self.view 
                                        title:NSLocalizedString(@"Searching couch ...", @"Searching couch activity label")];
    
    self.imageDownloaders = [NSMutableArray array];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSearch];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark CoachSearchRequest methods

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers {
    if (_loadingAction == CouchSearchResultControllerFirst) {
        self.sourfers = sourfers;
        [self.loadingActivity removeOverlap];        
    } else if (_loadingAction == CouchSearchResultControllerMore) {
        self.sourfers = [self.sourfers arrayByAddingObjectsFromArray:sourfers];
    }
    
    if ([sourfers count] <10) {
        _tryLoadMore = NO;
    } else {
        _tryLoadMore = YES;
    }
    
    [_tableView reloadData];
    self.request = nil;
    
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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadingMoreCell"];
            //Setup indicator view
            UIActivityIndicatorView *activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
            activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [activityView startAnimating];
            
            //setup label
            UILabel *loadingLabel = [[[UILabel alloc] initWithFrame:CGRectMake(activityView.frame.size.width + 5, 0, 0, 0)] autorelease];
            loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            loadingLabel.text = NSLocalizedString(@"Loading more ...", @"Loading more results cell label in couch search");
            [loadingLabel sizeToFit];
            
            //setup containing view
            CGFloat loadingViewWidth = loadingLabel.frame.origin.x + loadingLabel.frame.size.width;
            CGFloat loadingViewHeight = loadingLabel.frame.size.height;
            UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake((int)(cell.contentView.frame.size.width - loadingViewWidth) / 2, (int)(cell.contentView.frame.size.height - loadingViewHeight) / 2, loadingViewWidth, loadingViewHeight)];
            loadingView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            [loadingView addSubview:activityView];
            [loadingView addSubview:loadingLabel];
            
            [cell.contentView addSubview:loadingView];            
        }
        
    } else { // Vytvoreni bunky s couchsurferem
        CouchSearchResultCell *surferCell = (CouchSearchResultCell *)[tableView dequeueReusableCellWithIdentifier:@"surferCell"];
        if (surferCell == nil) {
            surferCell = [[CouchSearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"surferCell"];
            surferCell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchRowBg.png"]] autorelease];

            
        } else { //reset reused obrazku
            surferCell.photoView.image = nil;
        }
        
        CouchSurfer *surfer = [self.sourfers objectAtIndex:indexPath.row];
        surferCell.nameLabel.text = surfer.name;
        surferCell.basicsLabel.text = surfer.basics;
        surferCell.aboutLabel.text = surfer.about;
        surferCell.referencesCountLabel.text = surfer.referencesCount;
        surferCell.photosCountLabel.text = surfer.photosCount;
        surferCell.replyRateCountLabel.text = [NSString stringWithFormat:@"%@%", surfer.replyRate];
        
        [surferCell makeLayout];
        
        if (surfer.image == nil) {
            if (tableView.dragging == NO && tableView.decelerating == NO) {
                CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
                imageDownloader.delegate = self;
                [imageDownloader downloadWithSrc:surfer.imageSrc position:indexPath.row];
                [imageDownloader release];
            }
        } else {
            surferCell.photoView.image = surfer.image;
        }
        cell = surferCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.sourfers count]) {//indexpath loading cellu
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

#pragma mark CSImageDownloaderDelegate methods

- (void)imageDownloader:(CSImageDownloader *)imageDownloader didDownloadImage :(UIImage *)image forPosition:(NSInteger)position {
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
    self.request.delegate = nil;
    self.request = nil;
    for (CSImageDownloader *downloader in self.imageDownloaders) {
        downloader.delegate = nil;
    }
    self.imageDownloaders = nil;
    self.sourfers = nil;
    [super dealloc];
}

#pragma mark Private methods

- (void)performSearch {
    _loadingAction = CouchSearchResultControllerFirst;
    [self.loadingActivity overlapView];
    CouchSearchRequest *request = [self.filter createRequest];
    request.delegate = self;
    self.request = request;
    
    [self.request send];
}

- (void)performSearchMore {
    _loadingAction = CouchSearchResultControllerMore;
    CouchSearchRequest *request = [self.filter createRequest];
    request.delegate = self;
    self.request = request;
    request.page = [NSString stringWithFormat:@"%d", ++_currentPage];
    [self.request send];
    
}

- (void)loadImages {
    NSMutableArray *indexPaths = [[_tableView indexPathsForVisibleRows] mutableCopy];
    if (_tryLoadMore) {
        [indexPaths removeLastObject];
    }
    for (NSIndexPath *indexPath in indexPaths) {
        CouchSurfer *sourfer = [self.sourfers objectAtIndex:indexPath.row];
        if (sourfer.image == nil) {
            CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
            imageDownloader.delegate = self;
            [imageDownloader downloadWithSrc:sourfer.imageSrc position:indexPath.row];
            [imageDownloader release];            
        }
    }
}

@end
