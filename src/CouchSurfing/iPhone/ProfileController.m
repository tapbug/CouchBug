//
//  ProfileController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "AuthControllersFactory.h"
#import "ActivityOverlap.h"

@interface ProfileController ()

@property (nonatomic, retain) AuthControllersFactory *authControllersFactory;
@property (nonatomic, retain) ProfileRequestFactory *profileRequestFactory;

@property (nonatomic, retain) ActivityOverlap *loadingOverlap;
@property (nonatomic, retain) ProfileRequest *profileRequest;

@property (nonatomic, retain) ActivityOverlap *logoutOverlap;
@property (nonatomic, retain) LogoutRequest *logoutRequest;

-(void)logoutAction;

@end

@implementation ProfileController

@synthesize authControllersFactory = _authControllersFactory;
@synthesize profileRequestFactory = _profileRequestFactory;

@synthesize loadingOverlap = _loadingOverlap;
@synthesize profileRequest = _profileRequest;

@synthesize logoutOverlap = _logoutOverlap;
@synthesize logoutRequest = _logoutRequest;

- (id)initWithAuthControllersFactory:(AuthControllersFactory *)authControllersFactory
               profileRequestFactory:(ProfileRequestFactory *)profileRequestFactory {
    
    self = [super init];
    if (self) {
        self.authControllersFactory = authControllersFactory;
        self.profileRequestFactory = profileRequestFactory;
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
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.loadingOverlap = 
        [[[ActivityOverlap alloc] initWithView:self.view
                                        title:NSLocalizedString(@"Loading profile ...", @"Loading profile message")] autorelease];
    self.logoutOverlap = 
        [[[ActivityOverlap alloc] initWithView:self.view
                                         title:NSLocalizedString(@"Logout ...", @"Logout from profile activity label")] autorelease];
    
    [self.loadingOverlap overlapView];
    self.navigationItem.leftBarButtonItem = 
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout button in profile")
                                         style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(logoutAction)];
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    self.profileRequest = [self.profileRequestFactory createProfileRequest];
    self.profileRequest.delegate = self;
    [self.profileRequest loadProfile];
    
    [super viewDidLoad];
     
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark ProfileRequestDelegate methods

- (void)profileRequest:(ProfileRequest *)profileRequest didLoadProfile:(NSDictionary *)profile {
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", [profile objectForKey:@"firstname"], [profile objectForKey:@"lastname"]];
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.loadingOverlap removeOverlap];
}

- (void)profileRequestFailedToLogin:(ProfileRequest *)profileRequest {
    
}

#pragma Mark LogoutRequestDelegate methods

- (void)logoutDidFinnish:(LogoutRequest *)logoutReqeust {
    [self.logoutOverlap removeOverlap];
    id loginController = [self.authControllersFactory createLoginController];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:loginController] animated:YES];
}

#pragma Mark Action methods

- (void)logoutAction {
    [self.logoutOverlap overlapView];
    
    self.logoutRequest = [[[LogoutRequest alloc] init] autorelease];
    self.logoutRequest.delegate = self;
    [self.logoutRequest logout];
}

@end
