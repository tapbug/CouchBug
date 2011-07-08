//
//  CSWebViewController.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSWebViewController.h"
#import "ActivityOverlap.h"

@interface CSWebViewController ()

@property (nonatomic, retain) ActivityOverlap *loadingOverlap;

@end

@implementation CSWebViewController

@synthesize loadingOverlap = _loadingOverlap;

@synthesize urlString = _urlString;

- (void)dealloc {
	self.urlString = nil;
	self.loadingOverlap = nil;
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
	UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(0,
																	  0,
																	  self.view.frame.size.width,
																	  self.view.frame.size.height)] autorelease];

	self.loadingOverlap = [[[ActivityOverlap alloc] initWithView:webView title:NSLocalizedString(@"LOADING", nil)] autorelease];
	[self.loadingOverlap overlapView];

	webView.delegate = self;
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:webView];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
	[webView loadRequest:request];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.loadingOverlap removeOverlap];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self.loadingOverlap removeOverlap];
}

@end
