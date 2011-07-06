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

@property (nonatomic, retain) MVUrlConnection *connection;

@property (nonatomic, retain) ActivityOverlap *activityOverlap;

- (void)showWebView;

@end

@implementation ProfileDetailController

@synthesize withInlineStyles = _withInlineStyles;
@synthesize styleName = _styleName;

@synthesize html = _html;

@synthesize surfer = _surfer;
@synthesize property = _property;

@synthesize connection = _connection;

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

- (id)initWithConnection:(MVUrlConnection *)connection {
    self = [super init];
    if (self) {
        self.connection = connection;
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
	
	self.connection.delegate = nil;
	self.connection = nil;
	self.styleName = nil;
	self.title = nil;
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
	} else if(self.surfer != nil && self.property != nil){
		self.activityOverlap = [[ActivityOverlap alloc] initWithView:self.view title:NSLocalizedString(@"LOADING", nil)];
		[self.activityOverlap overlapView];
		[self.surfer addObserver:self forKeyPath:self.property options:NSKeyValueObservingOptionNew context:nil];
	} else if (self.connection != nil) {
		self.connection.delegate = self;
		[self.connection sendRequest];
		self.activityOverlap = [[ActivityOverlap alloc] initWithView:self.view title:NSLocalizedString(@"LOADING", nil)];
		[self.activityOverlap overlapView];
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

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseString:(NSString *)responseString {
	self.html = responseString;
	[self showWebView];
	[self.activityOverlap removeOverlap];
}

- (void)showWebView {
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	
	UIScrollView *scrollView = nil;
	for (UIView *subview in [webView subviews]) {
		if ([subview isKindOfClass:[UIScrollView class]]) {  
			scrollView = (UIScrollView *)subview;
			break;
		}
	}
	scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	NSString *html = nil;
	if (self.withInlineStyles == YES) {
		html = self.html;
	} else {
		html = [self.html stringByReplacingOccurrencesOfRegex:@"style=\"(.*?)\"" withString:@""];
	}
	html = [html stringByReplacingOccurrencesOfString:@"style=\"display: none\"" withString:@""];
	if (self.styleName != nil) {
		NSString *cssPath = [[NSBundle mainBundle] pathForResource:self.styleName ofType:@"css"];
		NSString *css = [NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:nil];
		html = [NSString stringWithFormat:@"<html><body>%@</body></html>", html];
		html = [NSString stringWithFormat:@"<style>%@</style>%@", css, html];		
	}
	[webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://www.couchsurfing.org/"]];
	[self.view addSubview:webView];
}

@end
