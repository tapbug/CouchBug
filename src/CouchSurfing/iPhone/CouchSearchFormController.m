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

@property (nonatomic, assign) UITableView *formTableView;

- (void)showForm:(NSUInteger)index;

- (void)variantChanged:(UISegmentedControl *)sender;
- (void)searchAction;

@end


@implementation CouchSearchFormController

@synthesize formTableView = _formTableView;

@synthesize requestFactory = _requestFactory;
@synthesize resultControllerFactory = _resultControllerFactory;
@synthesize variants = _variants;

- (void)viewDidLoad {
    CGRect viewFrame = self.view.frame;
    
    NSMutableArray *variantSCItems = [NSMutableArray array];
    for (id<CouchSearchFormVariant> variant in self.variants) {
        [variantSCItems addObject:[variant name]];
    }
                                    
    _variantSC = [[[UISegmentedControl alloc] initWithItems:variantSCItems] autorelease];
    _variantSC.selectedSegmentIndex = 0;
    [_variantSC addTarget:self action:@selector(variantChanged:) forControlEvents:UIControlEventValueChanged];
    _variantSC.segmentedControlStyle = UISegmentedControlStyleBar;
    _variantSC.tintColor = self.navigationController.navigationBar.tintColor;
    self.navigationItem.titleView = _variantSC;
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                            target:self
                                                                                            action:@selector(searchAction)] autorelease];
    
    self.formTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height) style:UITableViewStyleGrouped];
    self.formTableView.delegate = self;
    self.formTableView.dataSource = self;
    [self.view addSubview:self.formTableView];
    [self showForm:_variantSC.selectedSegmentIndex];
    
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

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_currentVariant numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentVariant numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [_currentVariant createCellForRowAtIndexPath:indexPath];
    }
    [_currentVariant configureCell:cell forRowAtIndexPath:indexPath];    
    return cell;
}

#pragma mark Private methods

- (void)showForm:(NSUInteger)index {
    id<CouchSearchFormVariant> variantToSelect = [self.variants objectAtIndex:index];
    
    id<CouchSearchFormVariant> lastVariant = _currentVariant;
    _currentVariant = variantToSelect;
    
    if (_currentVariant != nil) {        
        NSIndexSet *sectionsToRemove = [variantToSelect sectionsToRemoveFrom:lastVariant];
        NSArray *rowsToRemove = [variantToSelect rowsToRemoveFrom:lastVariant];
        NSIndexSet *sectionsToInsert = [variantToSelect sectionsToInsertFrom:lastVariant];
        NSArray *rowsToInsert = [variantToSelect rowsToInsertFrom:lastVariant];
        [self.formTableView beginUpdates];
        if (sectionsToInsert != nil) {
            [self.formTableView insertSections:sectionsToInsert withRowAnimation:UITableViewRowAnimationRight];
        }
        if (rowsToInsert != nil) {
            [self.formTableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:UITableViewRowAnimationRight];
        }
        
        if (sectionsToRemove != nil) {
            [self.formTableView deleteSections:sectionsToRemove withRowAnimation:UITableViewRowAnimationFade];
        }        
        if (rowsToRemove != nil) {
            [self.formTableView deleteRowsAtIndexPaths:rowsToRemove withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.formTableView endUpdates];
    }
}

#pragma mark Action methods

- (void)variantChanged:(UISegmentedControl *)sender {    
    [self showForm:sender.selectedSegmentIndex];
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
