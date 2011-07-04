//
//  ProfileDetailController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileDetailController.h"
#import "RegexKitLite.h"

#import "CouchSurfer.h"
#import "ActivityOverlap.h"

@interface ProfileDetailController ()

@property (nonatomic, retain) NSString *html;
@property (nonatomic, retain) CouchSurfer *surfer;
@property (nonatomic, retain) NSString *property;

@property (nonatomic, retain) ActivityOverlap *activityOverlap;

- (void)showWebView;

@end

@implementation ProfileDetailController

@synthesize html = _html;
@synthesize surfer = _surfer;
@synthesize property = _property;

@synthesize activityOverlap = _activityOverlap;

- (id)initWithHtmlString:(NSString *)html
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.html = html;
    }
    return self;
}

- (id)initWithSurfer:(CouchSurfer *)surfer property:(NSString *)property {
	self = [super init];
	if (self != nil) {
		self.surfer = surfer;
		self.property = property;
	}
	return self;
}

- (void)dealloc {
	self.html = nil;
	
	if (self.surfer != nil) {
		[self.surfer removeObserver:self forKeyPath:self.property];
	}
	
	self.surfer = nil;
	self.property = nil;
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	if (self.html != nil) {
		[self showWebView];
	} else {
		self.activityOverlap = [[ActivityOverlap alloc] initWithView:self.view title:NSLocalizedString(@"LOADNG PROFILE INFORMATION", nil)];
		[self.activityOverlap overlapView];
		[self.surfer addObserver:self forKeyPath:self.property options:NSKeyValueObservingOptionNew context:nil];
	}
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	self.html = [change objectForKey:NSKeyValueChangeNewKey];
	[self showWebView];
	[self.activityOverlap removeOverlap];
}

- (void)showWebView {
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	NSString *html = [self.html stringByReplacingOccurrencesOfRegex:@"style=\"(.*?)\"" withString:@""];
	[webView loadHTMLString:html baseURL:nil];
	[self.view addSubview:webView];
}

@end
