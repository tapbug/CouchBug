//
//  CouchSearchResultController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchResultController.h"

#import "CouchSearchRequest.h"
#import "CouchSourfer.h"

@interface CouchSearchResultController ()


@property (nonatomic, retain) NSArray *sourfers;
@property (nonatomic, retain) NSMutableArray *imageDownloaders;

- (void)loadImages;

@end


@implementation CouchSearchResultController

@synthesize sourfers = _sourfers;
@synthesize imageDownloaders = _imageDownloaders;
@synthesize request = _request;

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                      target:self
                                                      action:@selector(showSearchForm)];
    _tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    _tableView.autoresizingMask = self.view.autoresizingMask;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.imageDownloaders = [NSMutableArray array];
    
    CouchSearchRequest *request = [[[CouchSearchRequest alloc] init] autorelease];
    request.page = @"2";
    request.location = @"%7B%22city_id%22%3A%226064086%22%2C%22city%22%3A%22Prague%22%2C%22latitude%22%3A%2250.085785%22%2C%22longitude%22%3A%2214.443588%22%2C%22type%22%3A%22city%22%2C%22state_id%22%3A%224384%22%2C%22state%22%3A%22Praha%22%2C%22country_id%22%3A%2275%22%2C%22country%22%3A%22Czech%2BRepublic%22%2C%22region_id%22%3A%226%22%2C%22region%22%3A%22Europe%22%7D";
    request.mapEdges = @"%7B%22northEast%22%3A%7B%22lat%22%3A43.48552433447044%2C%22lng%22%3A-74.10790995312499%7D%2C%22southWest%22%3A%7B%22lat%22%3A41.54221236978597%2C%22lng%22%3A-76.72265604687499%7D%7D";
    request.couchStatuses = [NSArray arrayWithObject:CouchSearchRequestHasCouchYes];
    self.request = request;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.request send];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Public methods

- (void)setRequest:(CouchSearchRequest *)request {
    [_request autorelease];
    _request = [request retain];
    request.delegate = self;
}

#pragma mark CoachSearchRequest methods

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers {
    self.sourfers = sourfers;
    [_tableView reloadData];
    self.request = nil;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [self.sourfers count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourferCell"];
    CouchSourfer *sourfer = [self.sourfers objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sourferCell"];
    }
    
    cell.textLabel.text = sourfer.name;
    cell.imageView.image = nil;
    if (sourfer.image == nil) {
        if (tableView.dragging == NO && tableView.decelerating == NO) {
            CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
            imageDownloader.delegate = self;
            [imageDownloader downloadWithSrc:sourfer.imageSrc position:indexPath.row];
            [imageDownloader release];
        }            
    } else {
        cell.imageView.image = sourfer.image;
    }
    
    return cell;
}

#pragma mark CSImageDownloaderDelegate methods

- (void)imageDownloader:(CSImageDownloader *)imageDownloader didDownloadImage :(UIImage *)image forPosition:(NSInteger)position {
    CouchSourfer *sourfer = [self.sourfers objectAtIndex:position];
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

- (void)loadImages {
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in indexPaths) {
        CouchSourfer *sourfer = [self.sourfers objectAtIndex:indexPath.row];
        if (sourfer.image == nil) {
            CSImageDownloader *imageDownloader = [[CSImageDownloader alloc] init];
            imageDownloader.delegate = self;
            [imageDownloader downloadWithSrc:sourfer.imageSrc position:indexPath.row];
            [imageDownloader release];            
        }
    }
}

@end
