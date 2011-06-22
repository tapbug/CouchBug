    //
//  CouchSearchFormController.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchFormController.h"

#import "CouchSearchResultController.h"
#import "CouchSearchFilter.h"

#import "CSCheckboxCell.h"
#import "CSSelectedValueCell.h"

#import "CSTools.h"

@interface CouchSearchFormController ()

@property (nonatomic, assign) UITableView *formTableView;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSArray *items;

- (void)cancelForm;
- (void)searchAction;

- (CSCheckboxCell *)createCheckboxCell:(NSString *)title checked:(BOOL)checked;
- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected;

@end


@implementation CouchSearchFormController

@synthesize searchResultController = _searchResultController;
@synthesize filter = _filter;

@synthesize formTableView = _formTableView;
@synthesize sections = _sections;
@synthesize items = _items;

- (void)viewDidLoad {
	self.sections = [NSArray arrayWithObjects:@"LOCATION", @"COUCH STATUS", @"HOST", @"", @"COMUNITY", @"PROFILE", nil];
					 
	NSArray *locationSection = [NSArray arrayWithObject:@"LOCATION"];
	NSArray *couchStatusSection = [NSArray arrayWithObjects:@"YES",
								   @"MAYBE", 
								   @"COFFEE AND DRINK",
								   @"TRAVELING",
								   nil];
	NSArray *host1Section = [NSArray arrayWithObjects:
							@"AGE", @"HAS SPACE FOR", @"LANGUAGE", @"LAST LOGIN", nil];
	NSArray *host2Section = [NSArray arrayWithObjects:
							 @"MALE", @"FEMALE", @"SEVERAL PEOPLE", @"HAS PHOTO", @"WHEELCHAIR ACCESSIBLE", nil];
	NSArray *comunitySection = [NSArray arrayWithObjects:@"VERIFIED", @"VOUCHED", @"AMBASSADOR", nil];
	NSArray *profileSection = [NSArray arrayWithObjects:@"NAME / USERNAME", @"KEYWORD", nil];
	
	self.items = [NSArray arrayWithObjects:locationSection,
				  couchStatusSection,
				  host1Section,
				  host2Section,
				  comunitySection, 
				  profileSection, nil];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];

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
	toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	toolBar.tintColor = UIColorFromRGB(0x3d4041);
	toolBar.items = [NSArray arrayWithObjects:cancelItem, spaceItem, searchItem, nil];
	[self.view addSubview:toolBar];
	
	_formTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 
																   toolBar.frame.size.height,
																   self.view.frame.size.width,
																   self.view.frame.size.height - toolBar.frame.size.height) 
												   style:UITableViewStyleGrouped] autorelease];
	_formTableView.backgroundColor = [UIColor clearColor];
	_formTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_formTableView.delegate = self;
	_formTableView.dataSource = self;
	[self.view addSubview:_formTableView];
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)dealloc {
	self.sections = nil;
	self.items = nil;
    [super dealloc];
}

#pragma Mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.items objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (![[self.sections objectAtIndex:section] isEqualToString:@""]) {
		return NSLocalizedString([self.sections objectAtIndex:section], @"");
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	NSString *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if ([item isEqualToString:@"LOCATION"]) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"] autorelease];
			UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,
																			0,
																			cell.contentView.frame.size.width,
																			cell.contentView.frame.size.height)] autorelease];
			textLabel.tag = 1;
			textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			textLabel.backgroundColor = [UIColor clearColor];
			textLabel.textAlignment = UITextAlignmentCenter;
			textLabel.adjustsFontSizeToFitWidth = YES;
			[cell.contentView addSubview:textLabel];
		}
		UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
		textLabel.text = self.filter.locationName; //otestovat veeelkou delku
		
	} else if ([item isEqualToString:@"YES"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.hasCouchYes];
	} else if ([item isEqualToString:@"MAYBE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.hasCouchMaybe];
	} else if ([item isEqualToString:@"COFFEE AND DRINK"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.hasCouchCoffeeOrDrink];
	} else if ([item isEqualToString:@"TRAVELING"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.hasCouchTraveling];
	} else if ([item isEqualToString:@"AGE"]) {
		NSString *value = nil;
		if (self.filter.ageLow || self.filter.ageHigh) {
			value = [NSString stringWithFormat:@"%@ to %@",
					 self.filter.ageLow == nil ? NSLocalizedString(@"ANY", nil) : self.filter.ageLow,
					 self.filter.ageHigh == nil ? NSLocalizedString(@"ANY", nil) : self.filter.ageHigh];
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:value];
	} else if ([item isEqualToString:@"HAS SPACE FOR"]) {
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:self.filter.maxSurfers];
	} else if ([item isEqualToString:@"LANGUAGE"]) {
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:@"English"];
	} else if ([item isEqualToString:@"LAST LOGIN"]) {
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:self.filter.lastLoginDays];
	} else if ([item isEqualToString:@"MALE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.male];
	} else if ([item isEqualToString:@"FEMALE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.female];
	} else if ([item isEqualToString:@"SEVERAL PEOPLE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.severalPeople];
	} else if ([item isEqualToString:@"HAS PHOTO"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.hasPhoto];
	} else if ([item isEqualToString:@"WHEELCHAIR ACCESSIBLE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) checked:self.filter.wheelchairAccessible];
	}
	return cell;
}

#pragma Mark Action methods

- (void)cancelForm {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)searchAction {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self.searchResultController performSearch];
}

#pragma Mark Private methods

- (CSCheckboxCell *)createCheckboxCell:(NSString *)title checked:(BOOL)checked {
	CSCheckboxCell * cell = (CSCheckboxCell *)[_formTableView dequeueReusableCellWithIdentifier:@"checkboxCell"];
	if (cell == nil) {
		cell = [[CSCheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkboxCell"];
	}
	cell.keyLabel.text = title;
	[cell.checkbox setOn:checked];
	[cell makeLayout];
	return cell;
}

- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected {
	CSSelectedValueCell * cell = (CSSelectedValueCell *)[_formTableView dequeueReusableCellWithIdentifier:@"selectedValueCell"];
	if (cell == nil) {
		cell = [[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectedValueCell"];
	}
	cell.keyLabel.text = title;
	cell.selectedValueLabel.text = (selected == nil || [selected isEqualToString:@""]) ? NSLocalizedString(@"ANY", nil) : selected;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cell makeLayout];
	return cell;
}

@end
