    //
//  CouchSearchFormController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFormController.h"

#import "CouchSearchResultController.h"
#import "CSTools.h"

@interface CouchSearchFormController ()

@property (nonatomic, assign) UITableView *formTableView;

- (void)cancelForm;
- (void)searchAction;

@end


@implementation CouchSearchFormController

@synthesize searchResultController = _searchResultController;
@synthesize formTableView = _formTableView;

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];

	UIBarButtonItem *cancelItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", nil)
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(cancelForm)] autorelease];
	UIBarButtonItem *searchItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SEARCH", nil) 
																   style:UIBarButtonItemStyleBordered
																  target:self
																  action:@selector(searchAction)] autorelease];
	UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil
																			   action:nil];
	
	UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
	toolBar.tintColor = UIColorFromRGB(0x3d4041);
	toolBar.items = [NSArray arrayWithObjects:cancelItem, spaceItem, searchItem, nil];
	[self.view addSubview:toolBar];
	
    [super viewDidLoad];
}

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
    [super dealloc];
}

- (void)cancelForm {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)searchAction {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self.searchResultController performSearch];
}

@end
