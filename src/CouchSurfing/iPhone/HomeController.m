//
//  ProfileController.m
//  CouchSurfing
//
//  Created on 6/9/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "HomeController.h"
#import "AuthControllersFactory.h"
#import "ActivityOverlap.h"
#import "HomeRequestFactory.h"
#import "LoginAnnouncer.h"

#import "CSTools.h"
#import "CSImageCropper.h"
#import "CouchSearchResultController.h"
#import "FlurryAPI.h"
#import "ActiveControllersSetter.h"

@interface HomeController ()

@property (nonatomic, retain) AuthControllersFactory *authControllersFactory;
@property (nonatomic, retain) HomeRequestFactory *profileRequestFactory;

@property (nonatomic, retain) ActivityOverlap *loadingOverlap;
@property (nonatomic, retain) HomeRequest *profileRequest;

@property (nonatomic, retain) ActivityOverlap *logoutOverlap;
@property (nonatomic, retain) LogoutRequest *logoutRequest;
@property (nonatomic, assign) id<LoginAnnouncer> loginAnnouncer;

@property (nonatomic, retain) CSImageDownloader *avatarDownloader;

@property (nonatomic, retain) NSArray *items;

- (void)logoutAction;
- (void)loadHomeInformation;

@end

@implementation HomeController

@synthesize authControllersFactory = _authControllersFactory;
@synthesize profileRequestFactory = _profileRequestFactory;

@synthesize loadingOverlap = _loadingOverlap;
@synthesize profileRequest = _profileRequest;

@synthesize logoutOverlap = _logoutOverlap;
@synthesize logoutRequest = _logoutRequest;
@synthesize loginAnnouncer = _loginAnnouncer;
@synthesize activeControllersSetter = _activeControllersSetter;

@synthesize avatarDownloader = _avatarDownloader;

@synthesize items = _items;

@synthesize couchSearchController = _couchSearchController;

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory
               profileRequestFactory:(HomeRequestFactory *)profileRequestFactory 
                      loginAnnouncer:(id<LoginAnnouncer>) loginAnnouncer {
    
    self = [super init];
    if (self) {
        self.authControllersFactory = authControllersFactory;
        self.profileRequestFactory = profileRequestFactory;
        self.loginAnnouncer = loginAnnouncer;
    }
    return self;
}

- (void)dealloc
{
    self.authControllersFactory = nil;
    self.profileRequestFactory = nil;
    self.loadingOverlap = nil;
    self.profileRequest.delegate = nil;
    self.profileRequest = nil;
    
    self.logoutRequest.delegate = nil;
    self.logoutRequest = nil;
    self.logoutOverlap = nil;
    
    self.avatarDownloader = nil;
    self.items = nil;
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
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
	
    CGRect viewFrame = self.view.frame;
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIImage *headerBackgroundImage = [UIImage imageNamed:@"blackBg"];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   headerBackgroundImage.size.width,
                                                                   headerBackgroundImage.size.height)] autorelease];
    headerView.backgroundColor = [UIColor colorWithPatternImage:headerBackgroundImage];
    _tableView.tableHeaderView = headerView;
    UIImage *photoNoneImage = [UIImage imageNamed:@"photoNoneProfile"];
    _photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(18,
                                                                18,
                                                                130,
                                                                130)] autorelease];
    _photoView.image = photoNoneImage;
    [headerView addSubview:_photoView];
    
    UIImage *photoFrameImage = [UIImage imageNamed:@"photoFrameProfile"];
    UIImageView *photoFrameView = [[[UIImageView alloc] initWithFrame:CGRectMake(8.5,
                                                                                 8.5,
                                                                                 photoFrameImage.size.width,
                                                                                 photoFrameImage.size.height)] autorelease];
    photoFrameView.image = photoFrameImage;
    [headerView addSubview:photoFrameView];
    
    
    [self.view addSubview:_tableView];
    
    self.loadingOverlap = 
        [[[ActivityOverlap alloc] initWithView:self.view
                                        title:NSLocalizedString(@"LOADING PROFILE", nil)] autorelease];
    self.logoutOverlap = 
        [[[ActivityOverlap alloc] initWithView:self.view
                                         title:NSLocalizedString(@"SIGNING OUT", nil)] autorelease];
    
    self.navigationItem.leftBarButtonItem = 
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SIGN OUT", nil)
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(logoutAction)];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);
	
	[self loadHomeInformation];
	
    [super viewDidLoad];
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	if (_shouldReload) {
		[self loadHomeInformation];
		_shouldReload = NO;
	}
	_isActive = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
	_isActive = NO;
}

#pragma Mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.items != nil) {
        return [self.items count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellType;

    id item = [self.items objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[NSString class]]) {
        cellType = @"singleValueCell";
    } else {
        cellType = @"pairCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellType];
    if (cell == nil) {
        if ([cellType isEqualToString:@"pairCell"]) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pairCell"] autorelease];
            
            UILabel *valueLabel = [[[UILabel alloc] init] autorelease];
            valueLabel.tag = 1;
            valueLabel.backgroundColor = [UIColor clearColor];
            valueLabel.font = [UIFont boldSystemFontOfSize:12.5];
            valueLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [cell.contentView addSubview:valueLabel];
            
            UILabel *descriptionLabel = [[[UILabel alloc] init] autorelease];
            descriptionLabel.tag = 2;
            descriptionLabel.backgroundColor = [UIColor clearColor];
            descriptionLabel.font = [UIFont systemFontOfSize:12.5];
            descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [cell.contentView addSubview:descriptionLabel];            
        } else if([cellType isEqualToString:@"singleValueCell"]) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"singleValueCell"] autorelease];
            UILabel *valueLabel = [[[UILabel alloc] init] autorelease];
            valueLabel.font = [UIFont systemFontOfSize:12.5];
            valueLabel.backgroundColor = [UIColor clearColor];
            valueLabel.tag = 1;
            valueLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [cell.contentView addSubview:valueLabel];
        }
        
    }
    
    if ([cellType isEqualToString:@"pairCell"]) {
        NSArray *pair = (NSArray *)item;
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:1];    
        valueLabel.text = [pair objectAtIndex:1];
        [valueLabel sizeToFit];
        CGRect valueLabelFrame = valueLabel.frame;
        valueLabelFrame.origin.x = 20;
        valueLabelFrame.origin.y = (int)(cell.contentView.frame.size.height - valueLabelFrame.size.height) / 2;
        valueLabel.frame = valueLabelFrame;
        
        UILabel *descriptionLabel = (UILabel *)[cell.contentView viewWithTag:2];
        descriptionLabel.text = [pair objectAtIndex:0];
        
        [descriptionLabel sizeToFit];
        CGRect descriptionLabelFrame = descriptionLabel.frame;
        descriptionLabelFrame.origin.x = valueLabelFrame.origin.x + valueLabelFrame.size.width + 2;
        descriptionLabelFrame.origin.y = (int)(cell.contentView.frame.size.height - descriptionLabelFrame.size.height) / 2;
        descriptionLabel.frame = descriptionLabelFrame;        
    } else if([cellType isEqualToString:@"singleValueCell"]) {
        UILabel *valueLabel = (UILabel *)[cell.contentView viewWithTag:1];
        valueLabel.text = (NSString *)item;
        [valueLabel sizeToFit];
        CGRect valueLabelFrame = valueLabel.frame;
        valueLabelFrame.origin.x = 20;
        valueLabelFrame.origin.y = (int)(cell.contentView.frame.size.height - valueLabelFrame.size.height) / 2;
        valueLabel.frame = valueLabelFrame;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 33;
}

#pragma Mark ProfileRequestDelegate methods

- (void)profileRequest:(HomeRequest *)profileRequest didLoadProfile:(NSDictionary *)profile {
    self.navigationItem.title = [NSString stringWithFormat:@"%@", [profile objectForKey:@"name"]];
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.loadingOverlap removeOverlap];
    
    self.avatarDownloader = [[[CSImageDownloader alloc] init] autorelease];
    self.avatarDownloader.delegate = self;
    [self.avatarDownloader downloadWithSrc:[profile objectForKey:@"avatar"] position:0];
    
    NSMutableArray *tempItems = [NSMutableArray array];
    if ([profile objectForKey:@"loggedVisitors"]) {
        NSArray *loggedVisitorsPair = [NSArray arrayWithObjects:NSLocalizedString(@"MEMBERS ONLINE",@""), [profile objectForKey:@"loggedVisitors"], nil];
        [tempItems addObject:loggedVisitorsPair];
    }
    if ([profile objectForKey:@"profileViews"]) {
        NSArray *profileViewsPair = [NSArray arrayWithObjects:NSLocalizedString(@"PROFILE VIEWS", nil), [profile objectForKey:@"profileViews"], nil];
        [tempItems addObject:profileViewsPair];
    }
    
    if ([profile objectForKey:@"messagesCount"]) {
        NSString *messagesCount = [profile objectForKey:@"messagesCount"];
        NSString *label;
        if ([messagesCount integerValue] == 1) {
            label = NSLocalizedString(@"UNREAD MESSAGE", nil);
        } else {
            label = NSLocalizedString(@"UNREAD MESSAGES", nil);
        }
        NSArray *messagesCountPair = [NSArray arrayWithObjects:label, messagesCount,nil];
        [tempItems addObject:messagesCountPair];
    }
    
    if ([profile objectForKey:@"pendingFriends"]) {
        NSString *label;
        NSString *pendingFriendsValue = [profile objectForKey:@"pendingFriends"];
        if ([pendingFriendsValue integerValue] == 1) {
            label = NSLocalizedString(@"FRIEND REQUEST", nil);
        } else {
            label = NSLocalizedString(@"FRIEND REQUESTS", nil);
        }
        NSArray *pendingFriendsPair = [NSArray arrayWithObjects:label, pendingFriendsValue, nil];
        [tempItems addObject:pendingFriendsPair];
    }
    
    if ([profile objectForKey:@"couchRequestCount"]) {
        NSString *label;
        NSString *couhRequests = [profile objectForKey:@"couchRequestCount"];
        if ([couhRequests integerValue] == 1) {
            label = NSLocalizedString(@"COUCH REQUEST", nil);
        } else {
            label = NSLocalizedString(@"COUCH REQUESTS", nil);
        }
        NSArray *couhRequestsPair = [NSArray arrayWithObjects:label, couhRequests, nil];
        [tempItems addObject:couhRequestsPair];
    }  
    
    if ([profile objectForKey:@"memberSince"]) {
        [tempItems addObject:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"MEMBER SINCE", nil), [profile objectForKey:@"memberSince"]]];
    }
    
    self.items = tempItems;
    [_tableView reloadData];
	
	[FlurryAPI setUserID:[NSString stringWithFormat:@"%@", [profile objectForKey:@"name"]]];
	//[FlurryAPI setAge:21];
	//[FlurryAPI setGender:@"m"];
}

- (void)profileRequestFailedToLogin:(HomeRequest *)profileRequest {
    
}

#pragma Mark LogoutRequestDelegate methods

- (void)logoutDidFinnish:(LogoutRequest *)logoutReqeust {
	[self.couchSearchController shouldReload];
    [self.loginAnnouncer userHasLoggedOut];
    [self.logoutOverlap removeOverlap];
    id loginController = [self.authControllersFactory createLoginController];
	[self.activeControllersSetter setHomeController:nil];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:loginController] animated:YES];
}

#pragma Mark CSImageDownloaderDelegate methods

- (void)imageDownloader:(CSImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forPosition:(NSInteger)position {
    _photoView.image = [CSImageCropper scaleToSize:CGSizeMake(130, 130) image:image];
}

#pragma Mark Action methods

- (void)logoutAction {
    [self.logoutOverlap overlapView];
    
    self.logoutRequest = [[[LogoutRequest alloc] init] autorelease];
    self.logoutRequest.delegate = self;
    [self.logoutRequest logout];
}

#pragma Mark private methods

- (void)loadHomeInformation {
	[self.loadingOverlap overlapView];
    self.profileRequest = [self.profileRequestFactory createHomeRequest];
    self.profileRequest.delegate = self;
    [self.profileRequest loadProfile];
}

#pragma Mark Public methods

- (void)refreshHomeInformation {
	if (_isActive) {
		[self loadHomeInformation];
	} else {
		_shouldReload = YES;
	}
}

@end
