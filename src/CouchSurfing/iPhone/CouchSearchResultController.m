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

@property (nonatomic, retain) CouchSearchRequest *request;
@property (nonatomic, retain) NSArray *sourfers;
@property (nonatomic, retain) NSMutableArray *imageDownloaders;

- (void)loadImages;

@end


@implementation CouchSearchResultController

@synthesize request = _request;
@synthesize sourfers = _sourfers;
@synthesize imageDownloaders = _imageDownloaders;

- (void)viewDidLoad {
    
    _tableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    _tableView.autoresizingMask = self.view.autoresizingMask;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.imageDownloaders = [NSMutableArray array];
    
    self.request.delegate = self;
    [self.request send];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark Public methods

- (void)searchResultForRequest:(CouchSearchRequest *)request {
    self.request = request;
    request.delegate = self;
    [request send];
}

#pragma mark CoachSearchRequest methods

- (void)couchSearchRequest:(CouchSearchRequest *)request didRecieveResult:(NSArray *)sourfers {
    self.sourfers = sourfers;
    [_tableView reloadData];
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
