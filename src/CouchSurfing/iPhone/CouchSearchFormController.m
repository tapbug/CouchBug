    //
//  CouchSearchFormController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFormController.h"

#import "CouchSearchResultControllerFactory.h"
#import "CouchSearchResultController.h"
#import "CouchSearchRequestFactory.h"
#import "CouchSearchRequest.h"
#import "CouchSearchFormVariant.h"

@interface CouchSearchFormController ()

- (void)showForm;

- (void)variantChanged;
- (void)searchAction;

@end


@implementation CouchSearchFormController

@synthesize requestFactory = _requestFactory;
@synthesize resultControllerFactory = _resultControllerFactory;
@synthesize variants = _variants;

- (void)viewDidLoad {
    NSMutableArray *variantSCItems = [NSMutableArray array];
    for (id<CouchSearchFormVariant> variant in self.variants) {
        [variantSCItems addObject:[variant name]];
    }
                                    
    _variantSC = [[[UISegmentedControl alloc] initWithItems:variantSCItems] autorelease];
    _variantSC.selectedSegmentIndex = 0;
    [_variantSC addTarget:self action:@selector(variantChanged) forControlEvents:UIControlEventValueChanged];
    _variantSC.segmentedControlStyle = UISegmentedControlStyleBar;
    _variantSC.tintColor = self.navigationController.navigationBar.tintColor;
    self.navigationItem.titleView = _variantSC;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                            target:self
                                                                                            action:@selector(searchAction)] autorelease];
    [self showForm];
    
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
    self.resultControllerFactory = nil;
    self.requestFactory = nil;
    self.variants = nil;
    [super dealloc];
}

#pragma mark Private methods

- (void)showForm {
    /*NSInteger selectedIndex = _variantSC.selectedSegmentIndex;
    id<CouchSearchFormVariant> variantToSelect = [self.variants objectAtIndex:selectedIndex];
    asd*/
}

#pragma mark Action methods

- (void)variantChanged {
    [self showForm];
}

- (void)searchAction {
    CouchSearchRequest *request = [self.requestFactory createRequest];
    
    request.hasCouch = @"";    
    request.keywordOrAnd = @"0";
    request.regionId = @"0";
    request.radiusType = @"M";
    
    CouchSearchResultController *resultController = [self.resultControllerFactory createControllerWithRequest:request];
    [self.navigationController pushViewController:resultController animated:YES];
}

@end
