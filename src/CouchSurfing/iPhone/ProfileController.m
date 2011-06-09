//
//  ProfileController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileController.h"
#import "ActivityOverlap.h"
#import "XPathFinder.h"

@interface ProfileController ()

@property (nonatomic, retain) MVUrlConnection *urlConnection;
@property (nonatomic, retain) ActivityOverlap *activityOverlap;

@end

@implementation ProfileController

@synthesize urlConnection = _urlConnection;
@synthesize activityOverlap = _activityOverlap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.urlConnection = nil;
    self.activityOverlap = nil;
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
    self.activityOverlap = [[ActivityOverlap alloc] initWithView:self.view
                                                           title:NSLocalizedString(@"Loading profile ...", @"Loading profile message")];
    
    [self.activityOverlap overlapView];
    NSString *profileUrl = @"https://www.couchsurfing.org/editprofile.html?edit=general";
    self.urlConnection = [[[MVUrlConnection alloc] initWithUrlString:profileUrl] autorelease];
    self.urlConnection.delegate = self;
    [self.urlConnection sendRequest];
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

#pragma mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
    XPathFinder *xpathFinder = [[[XPathFinder alloc] initWithData:responseData] autorelease];
    NSString *firstname = [xpathFinder nodeValueForXPath:@"//input[@id='profilefirst_name']/@value"];
    NSString *lastname = [xpathFinder nodeValueForXPath:@"//input[@id='profilelast_name']/@value"];
        
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", firstname, lastname];
    
    [self.activityOverlap removeOverlap];
}

@end
