//
//  LocationSearchController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationSearchController.h"
#import "JSONKit.h"

#import "NSDictionary+Location.h"
#import "CSTools.h"
#import "ActivityOverlap.h"

@interface LocationSearchController ()

@property (nonatomic, retain) MVUrlConnection *searchConnection;
@property (nonatomic, retain) NSArray *locations;

@property (nonatomic, retain) ActivityOverlap *searchActivityOverlap;

- (void)searchAction;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value;

- (BOOL)nonSearchMode;

- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;

- (void)reduceViewSizeByHeight:(CGFloat)byHeight;
- (void)extendViewSizeByHeight:(CGFloat)byHeight;

@end

@implementation LocationSearchController

@synthesize searchConnection;
@synthesize locations;

@synthesize searchActivityOverlap = _searchActivityOverlap;

- (id)initWithFilter:(CouchSearchFilter *)filter {
    self = [super init];
    if (self) {
        _filter = filter;
    }
    return self;
}

- (void)dealloc {
	self.searchConnection.delegate = nil;
	self.searchConnection = nil;
	self.locations = nil;
	self.searchActivityOverlap = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	_searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 44)] autorelease];
	_searchBar.tintColor = self.navigationController.navigationBar.tintColor;
	_searchBar.delegate = self;
	self.navigationItem.titleView = _searchBar;
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	self.searchActivityOverlap = [[[ActivityOverlap alloc] initWithView:_tableView 
																 title:NSLocalizedString(@"LOADING LOCATIONS", nil)] autorelease];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

	[super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	if ([searchText isEqualToString:@""]) {
		[_tableView reloadData];
	} else {
		[self performSelector:@selector(searchAction) withObject:nil afterDelay:0.5];
	}
}

#pragma Mark Actions

- (void)searchAction {
	[self.searchActivityOverlap overlapView];
	
	NSString *locationName = _searchBar.text;
	NSString *urlString = [NSString stringWithFormat:@"http://www.couchsurfing.org/geography/locations_by_name/%@/city%@state%@country%@region", [locationName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"%3A", @"%3A", @"%3A"];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPMethod:@"POST"];
	
	NSMutableString *bodyString = [NSMutableString string];
	[bodyString appendString:[self parameter:@"encoded_data" value:@"{}"]];
    [bodyString appendString:[self parameter:@"dataonly" value:@"false"]];
    [bodyString appendString:[self parameter:@"csstandard_request" value:@"true"]];
	[bodyString appendString:[self lastParameter:@"type" value:@"json"]];
	[request setValue:@"text/javascript, text/html, application/xml, text/xml, */*" forHTTPHeaderField:@"Accept"];
	[request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	self.searchConnection = [[[MVUrlConnection alloc] initWithUrlRequest:request] autorelease];
	self.searchConnection.delegate = self;
	[self.searchConnection sendRequest];
}

#pragma Mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
	NSArray *responseJSON = [responseData objectFromJSONData];
	self.locations = [[[responseJSON lastObject] objectForKey:@"data"] objectForKey:@"results"];
	[_tableView reloadData];
	[self.searchActivityOverlap removeOverlap];
}

#pragma Mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self nonSearchMode]) {
		return 2;
	}
	return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if ([self nonSearchMode]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"controlCell"];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"controlCell"];
		}
		
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"CURRENT LOCATION", nil);
			cell.textLabel.textColor = UIColorFromRGB(0x2957ff);
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"EVERYWHERE", nil);
		}
		
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"locationCell"];
		}
		
		NSDictionary *location = [self.locations objectAtIndex:indexPath.row];	
		cell.textLabel.text = [location locationName];
	}	
	return cell;
}

#pragma Mark Private methods

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@&", parameter, value];
}

- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@", parameter, value];
}

- (BOOL)nonSearchMode {
	return [_searchBar.text isEqualToString:@""] || _searchBar.text == nil;
}

#pragma Mark KeyboarShowing methods

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];    
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
	
    [UIView beginAnimations:@"showKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	
	[self reduceViewSizeByHeight:keyboardHeigh];
    
    [UIView commitAnimations];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
	
    [UIView beginAnimations:@"hideKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
	[self extendViewSizeByHeight:keyboardHeigh];
	
	[UIView commitAnimations];
}

#pragma Mark View manipulation methods

- (void)reduceViewSizeByHeight:(CGFloat)byHeight {
	CGRect viewFrame = self.view.frame;
	viewFrame.size.height -= byHeight;
    self.view.frame = viewFrame;
}

- (void)extendViewSizeByHeight:(CGFloat)byHeight {
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += byHeight;
    self.view.frame = viewFrame;
}

@end
