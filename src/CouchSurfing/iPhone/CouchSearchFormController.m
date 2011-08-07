    //
//  CouchSearchFormController.m
//  CouchSurfing
//
//  Created on 11/6/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CouchSearchFormController.h"

#import "CouchSearchResultController.h"
#import "CouchSearchFilter.h"
#import "LocationSearchController.h"

#import "CSCheckboxCell.h"
#import "CSSelectedValueCell.h"
#import "CSEditableCell.h"

#import "CSTools.h"
#import "NSDictionary+Location.h"

@interface CouchSearchFormController ()

@property (nonatomic, assign) TapableTableView *formTableView;
@property (nonatomic, retain) NSArray *sections;
@property (nonatomic, retain) NSArray *items;

@property (nonatomic, retain) UISwitch *hasCouchYesCB;
@property (nonatomic, retain) UISwitch *hasCouchMaybeCB;
@property (nonatomic, retain) UISwitch *hasCouchCoffeeOrDrinkCB;
@property (nonatomic, retain) UISwitch *hasCouchTravelingCB;
@property (nonatomic, retain) UISwitch *maleCB;
@property (nonatomic, retain) UISwitch *femaleCB;
@property (nonatomic, retain) UISwitch *groupCB;
@property (nonatomic, retain) UISwitch *hasPhotoCB;
@property (nonatomic, retain) UISwitch *wheelchairAccessibleCB;
@property (nonatomic, retain) UISwitch *verifiedCB;
@property (nonatomic, retain) UISwitch *vouchedCB;
@property (nonatomic, retain) UISwitch *ambassadorCB;
@property (nonatomic, retain) UITextField *usernameTF;
@property (nonatomic, retain) UITextField *keywordTF;

@property (nonatomic, retain) NSIndexPath *currentlyHiddenIndexPath;

@property (nonatomic, retain) NSArray *lastLoginsData;

- (void)searchAction;

- (void)registerForKeyboardEvents;
- (void)unregisterKeyboardEvents;
- (void)hideKeyboard;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;

//	DialogView je v tomto pripade vse co vyjizdy ze spodu
//	zatim nejspise pouze pickery
- (void)showDialogViewWithContentView:(UIView *)contentView;
- (void)hideDialogView;

//	refreshuje aktualni vybranou bunku pri prechodu z obrazovky, kde probihala zmena hodnoty
//	teto bunky
- (void)refreshFormFilterInformation;

- (CSCheckboxCell *)getCheckboxCell;
- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected;
- (CSEditableCell *)getEditableCell;

- (void)reduceViewSizeByHeight:(CGFloat)byHeight;
- (void)extendViewSizeByHeight:(CGFloat)byHeight;

- (NSUInteger)selectedLastLoginDays;

@end


@implementation CouchSearchFormController

@synthesize searchResultController = _searchResultController;
@synthesize filter = _filter;

@synthesize formTableView = _formTableView;
@synthesize sections = _sections;
@synthesize items = _items;

@synthesize hasCouchYesCB = _hasCouchYesCB;
@synthesize hasCouchMaybeCB = _hasCouchMaybeCB;
@synthesize hasCouchCoffeeOrDrinkCB = _hasCouchCoffeOrDrinkCB;
@synthesize hasCouchTravelingCB = _hasCouchTravelingCB;
@synthesize maleCB = _maleCB;
@synthesize femaleCB = _femaleCB;
@synthesize groupCB = _groupCB;
@synthesize hasPhotoCB = _hasPhotoCB;
@synthesize wheelchairAccessibleCB = _wheelchairAccessibleCB;
@synthesize verifiedCB = _verifiedCB;
@synthesize vouchedCB = _vouchedCB;
@synthesize ambassadorCB = _ambassadorCB;
@synthesize usernameTF = _usernameTF;
@synthesize keywordTF = _keywordTF;

@synthesize currentlyHiddenIndexPath = _currentlyHiddenIndexPath;

@synthesize lastLoginsData = _lastLoginsData;

- (void)viewDidLoad {
	self.sections = [NSArray arrayWithObjects:@"LOCATION", @"COUCH STATUS", @"HOST", @"", @"COMMUNITY", @"PROFILE", nil];
					 
	NSArray *locationSection = [NSArray arrayWithObject:@"LOCATION"];
	NSArray *couchStatusSection = [NSArray arrayWithObjects:@"YES",
								   @"MAYBE", 
								   @"COFFEE",
								   @"TRAVELING",
								   nil];
	NSArray *host1Section = [NSArray arrayWithObjects:
							@"AGE", @"HAS SPACE FOR", @"LAST LOGIN", @"LANGUAGE", nil];
	NSArray *host2Section = [NSArray arrayWithObjects:
							 @"MALE", @"FEMALE", @"SEVERAL PEOPLE", @"HAS PHOTO", @"WHEELCHAIR ACCESSIBLE", nil];
	NSArray *communitySection = [NSArray arrayWithObjects:@"VERIFIED", @"VOUCHED", @"AMBASSADOR", nil];
	NSArray *profileSection = [NSArray arrayWithObjects:@"NAME USERNAME", @"KEYWORD", nil];
	
	self.items = [NSArray arrayWithObjects:locationSection,
				  couchStatusSection,
				  host1Section,
				  host2Section,
				  communitySection, 
				  profileSection, nil];
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UIBarButtonItem *searchItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SEARCH", nil) 
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(searchAction)] autorelease];
	
	self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3d4041);
	self.navigationItem.rightBarButtonItem = searchItem;
	
	_formTableView = [[[TapableTableView alloc] initWithFrame:CGRectMake(0, 
																   0,
																   self.view.frame.size.width,
																   self.view.frame.size.height) 
												   style:UITableViewStyleGrouped] autorelease];
	//TODO nejspis jiz nebude potreba, uvidime
	//_formTableView.tapDelegate = self;
	_formTableView.backgroundColor = [UIColor clearColor];
	_formTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_formTableView.delegate = self;
	_formTableView.dataSource = self;
	[self.view addSubview:_formTableView];
	
	self.lastLoginsData = [NSArray arrayWithObjects:
						   [NSArray arrayWithObjects:NSLocalizedString(@"ANY", nil), [NSNumber numberWithInt:0], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 90, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:90], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 50, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:50], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 30, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:30], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 14, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:14], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 7, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:7], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 3, NSLocalizedString(@"DAYS", nil)], [NSNumber numberWithInt:3], nil],
						   [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d %@", 24, NSLocalizedString(@"HOURS", nil)], [NSNumber numberWithInt:1], nil],
						   nil];
	
	self.navigationController.delegate = self;
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[self registerForKeyboardEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self unregisterKeyboardEvents];
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
	self.sections = nil;
	self.items = nil;
	self.hasCouchYesCB = nil;
	self.hasCouchMaybeCB = nil;
	self.hasCouchCoffeeOrDrinkCB = nil;
	self.hasCouchTravelingCB = nil;
	self.maleCB = nil;
	self.femaleCB = nil;
	self.groupCB = nil;
	self.hasPhotoCB = nil;
	self.wheelchairAccessibleCB = nil;
	self.verifiedCB = nil;
	self.vouchedCB = nil;
	self.ambassadorCB = nil;
	self.usernameTF = nil;
	self.keywordTF = nil;
	self.currentlyHiddenIndexPath = nil;
	self.lastLoginsData = nil;
    [super dealloc];
}

#pragma Mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 6;
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
			textLabel.font = [UIFont boldSystemFontOfSize:17];
			textLabel.adjustsFontSizeToFitWidth = YES;
			[cell.contentView addSubview:textLabel];
		}
		UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
		NSString *locationName = NSLocalizedString(@"EVERYWHERE", nil);
		if (self.filter.currentLocationRectSearch == YES) {
			locationName = NSLocalizedString(@"CURRENT LOCATION", nil);
			textLabel.textColor = UIColorFromRGB(0x2957ff);
		} else if (self.filter.locationJSON != nil) {
			locationName = [self.filter.locationJSON locationName];
		}
		textLabel.text = locationName;
		
	} else if ([item isEqualToString:@"YES"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.hasCouchYesCB == nil) {
			self.hasCouchYesCB = [[[UISwitch alloc] init] autorelease];
			[self.hasCouchYesCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.hasCouchYesCB;		
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		[csCell.checkbox setOn:self.filter.hasCouchYes];
		[csCell makeLayout];
		cell = csCell;

	} else if ([item isEqualToString:@"MAYBE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.hasCouchMaybeCB == nil) {
			self.hasCouchMaybeCB = [[[UISwitch alloc] init] autorelease];
			[self.hasCouchMaybeCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.hasCouchMaybeCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.hasCouchMaybe];
		[csCell makeLayout];
		cell = csCell;
		
	} else if ([item isEqualToString:@"COFFEE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.hasCouchCoffeeOrDrinkCB == nil) {
			self.hasCouchCoffeeOrDrinkCB = [[[UISwitch alloc] init] autorelease];
			[self.hasCouchCoffeeOrDrinkCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.hasCouchCoffeeOrDrinkCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.hasCouchCoffeeOrDrink];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"TRAVELING"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.hasCouchTravelingCB == nil) {
			self.hasCouchTravelingCB = [[[UISwitch alloc] init] autorelease];
			[self.hasCouchTravelingCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.hasCouchTravelingCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.hasCouchTraveling];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"AGE"]) {
		NSString *value = nil;
		if (self.filter.ageLow || self.filter.ageHigh) {
			value = [NSString stringWithFormat:@"%@ to %@",
					 self.filter.ageLow == 0 ? NSLocalizedString(@"ANY", nil) : [NSString stringWithFormat:@"%d", self.filter.ageLow],
					 self.filter.ageHigh == 0 ? NSLocalizedString(@"ANY", nil) : [NSString stringWithFormat:@"%d", self.filter.ageHigh]];
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:value];
	} else if ([item isEqualToString:@"HAS SPACE FOR"]) {
		NSString *value;
		if (self.filter.maxSurfers == 0) {
			value = NSLocalizedString(@"ANY", nil);
		} else {
			value = [NSString stringWithFormat:@"%d", self.filter.maxSurfers];
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:value];
	} else if ([item isEqualToString:@"LANGUAGE"]) {
		NSString *languageName = nil;
		if (self.filter.languageId != nil) {
			languageName = self.filter.languageName;
		} else {
			languageName = NSLocalizedString(@"ANY", nil);
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:languageName];
	} else if ([item isEqualToString:@"LAST LOGIN"]) {
		NSArray *selectedRow = [self.lastLoginsData objectAtIndex:[self selectedLastLoginDays]];
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:[selectedRow objectAtIndex:0]];
	} else if ([item isEqualToString:@"MALE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.maleCB == nil) {
			self.maleCB = [[[UISwitch alloc] init] autorelease];
			[self.maleCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.maleCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.male];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"FEMALE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.femaleCB == nil) {
			self.femaleCB = [[[UISwitch alloc] init] autorelease];
			[self.femaleCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.femaleCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.female];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"SEVERAL PEOPLE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.groupCB == nil) {
			self.groupCB = [[[UISwitch alloc] init] autorelease];
			[self.groupCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.groupCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.severalPeople];
		[csCell makeLayout];
		cell = csCell;		
	} else if ([item isEqualToString:@"HAS PHOTO"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.hasPhotoCB == nil) {
			self.hasPhotoCB = [[[UISwitch alloc] init] autorelease];
			[self.hasPhotoCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.hasPhotoCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.hasPhoto];
		[csCell makeLayout];
		cell = csCell;	
	} else if ([item isEqualToString:@"WHEELCHAIR ACCESSIBLE"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.wheelchairAccessibleCB == nil) {
			self.wheelchairAccessibleCB = [[[UISwitch alloc] init] autorelease];
			[self.wheelchairAccessibleCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.wheelchairAccessibleCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.wheelchairAccessible];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"VERIFIED"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.verifiedCB == nil) {
			self.verifiedCB = [[[UISwitch alloc] init] autorelease];
			[self.verifiedCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.verifiedCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.verified];
		[csCell makeLayout];
		cell = csCell;		
	} else if ([item isEqualToString:@"VOUCHED"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.vouchedCB == nil) {
			self.vouchedCB = [[[UISwitch alloc] init] autorelease];
			[self.vouchedCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.vouchedCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.vouched];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"AMBASSADOR"]) {
		CSCheckboxCell *csCell = [self getCheckboxCell];
		if (self.ambassadorCB == nil) {
			self.ambassadorCB = [[[UISwitch alloc] init] autorelease];
			[self.ambassadorCB addTarget:self action:@selector(switchHasChanged:) forControlEvents:UIControlEventValueChanged];
		}
		csCell.checkbox = self.ambassadorCB;
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		
		[csCell.checkbox setOn:self.filter.ambassador];
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"NAME USERNAME"]) {
		CSEditableCell *csCell = [self getEditableCell];
		if (self.usernameTF	== nil) {
			self.usernameTF = [[[UITextField alloc] init] autorelease];
			self.usernameTF.clearButtonMode = UITextFieldViewModeAlways;
			self.usernameTF.delegate = self;
			self.usernameTF.autocapitalizationType = UITextAutocapitalizationTypeWords;
			self.usernameTF.placeholder = NSLocalizedString(@"ANY", nil);
		}
		
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		self.usernameTF.text = self.filter.username;
		csCell.valueField = self.usernameTF;
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"KEYWORD"]) {
		CSEditableCell *csCell = [self getEditableCell];
		if (self.keywordTF	== nil) {
			self.keywordTF = [[[UITextField alloc] init] autorelease];
			self.keywordTF.clearButtonMode = UITextFieldViewModeAlways;
			self.keywordTF.delegate = self;
			self.keywordTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
			self.keywordTF.placeholder = NSLocalizedString(@"ANY", nil);
		}
		
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		self.keywordTF.text = self.filter.keyword;
		csCell.valueField = self.keywordTF;
		[csCell makeLayout];
		cell = csCell;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if ([item isEqualToString:@"HAS SPACE FOR"]) {
		_hasSpaceForPickerView = [[[UIPickerView alloc] init] autorelease];
		_hasSpaceForPickerView.dataSource = self;
		_hasSpaceForPickerView.delegate = self;
		_hasSpaceForPickerView.showsSelectionIndicator = YES;
		[_hasSpaceForPickerView selectRow:self.filter.maxSurfers inComponent:0 animated:NO];
		[self showDialogViewWithContentView:_hasSpaceForPickerView];
	} else if ([item isEqualToString:@"LAST LOGIN"]) {
		_lastLoginPickerView = [[[UIPickerView alloc] init] autorelease];
		_lastLoginPickerView.dataSource = self;
		_lastLoginPickerView.delegate = self;
		_lastLoginPickerView.showsSelectionIndicator = YES;
		NSUInteger selectedIndex = [self selectedLastLoginDays];
		[_lastLoginPickerView selectRow:selectedIndex inComponent:0 animated:NO];
		[self showDialogViewWithContentView:_lastLoginPickerView];
	} else if ([item isEqualToString:@"AGE"]) {
		_agePickerView = [[[UIPickerView alloc] init] autorelease];
		_agePickerView.dataSource = self;
		_agePickerView.delegate = self;
		_agePickerView.showsSelectionIndicator = YES;
		
		NSUInteger selectedIndexAgeLow = 0;
		NSUInteger selectedIndexAgeHigh = 0;
		if (self.filter.ageLow != 0) {
			selectedIndexAgeLow = self.filter.ageLow - 17;
		}
		
		if (self.filter.ageHigh != 0) {
			selectedIndexAgeHigh = self.filter.ageHigh - 17;
		}
		
		[_agePickerView selectRow:selectedIndexAgeLow inComponent:0 animated:NO];
		[_agePickerView selectRow:selectedIndexAgeHigh inComponent:1 animated:NO];
		[self showDialogViewWithContentView:_agePickerView];
	} else if ([item isEqualToString:@"LANGUAGE"]) {
		LanguagesListController *controller = [[[LanguagesListController alloc] initWithFilter:self.filter] autorelease];
		controller.delegate = self;
		[self.navigationController pushViewController:controller animated:YES];
		
	} else if ([item isEqualToString:@"LOCATION"]) {
		LocationSearchController *controller = [[[LocationSearchController alloc] initWithFilter:self.filter] autorelease];
		controller.delegate = self;
		[self.navigationController pushViewController:controller animated:YES];
	}
	
	id selectedCell = [_formTableView cellForRowAtIndexPath:indexPath];
	
	if ([selectedCell isKindOfClass:[CSEditableCell class]]) {
		[((CSEditableCell*)selectedCell).valueField becomeFirstResponder];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[tableView indexPathForSelectedRow] isEqual:indexPath]) {
		if (dialogViewOn) {
			[self hideDialogView];
		}

		if (keyboardOn) {
			[self hideKeyboard];
		}

		return nil;
	}
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (dialogViewOn) {
		[self hideDialogView];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (dialogViewOn) {
		[self hideDialogView];
	}
	if (keyboardOn) {
		[self hideKeyboard];
	}
}

#pragma Mark Action methods

- (void)searchAction {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self hideDialogView];
	[self.searchResultController performSearch];
}

#pragma Mark Keyboard events methods

- (void)registerForKeyboardEvents {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterKeyboardEvents {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)hideKeyboard {
	[_activeField resignFirstResponder];
	[_formTableView deselectRowAtIndexPath:[_formTableView indexPathForSelectedRow] animated:NO];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	keyboardOn = YES;
	NSIndexPath *lastVisibleIndexPath = [[_formTableView indexPathsForVisibleRows] lastObject];

    CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];    
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }
    	
    [UIView beginAnimations:@"showKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
	
	[self reduceViewSizeByHeight:keyboardHeigh];
    
    [UIView commitAnimations];
	[_formTableView scrollToRowAtIndexPath:lastVisibleIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	keyboardOn = NO;
	CGRect addFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeigh = 0;
    if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
        keyboardHeigh = addFrame.size.height;
    } else {
        keyboardHeigh = addFrame.size.width;
    }

    [UIView beginAnimations:@"hideKeyboard" context:nil];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    
	[self extendViewSizeByHeight:keyboardHeigh];
	
	[UIView commitAnimations];
}

#pragma Mark DialogView methods

- (void)showDialogViewWithContentView:(UIView *)contentView {
	dialogViewOn = YES;
	CGFloat toolBarHeight = 30;
	if (_dialogView == nil) {
		
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		_dialogView = [[UIView alloc] initWithFrame:CGRectMake(0,
															   window.frame.size.height,
															   window.frame.size.width,
															   0)];
		_dialogView.backgroundColor = [UIColor whiteColor];
		[window addSubview:_dialogView];
		
		UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _dialogView.frame.size.width, toolBarHeight)] autorelease];
		toolBar.tintColor = UIColorFromRGB(0x3d4041);
		[_dialogView addSubview:toolBar];
				
		UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					 target:self
																					 action:@selector(hideDialogView)] autorelease];
		UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					   target:nil
																					   action:nil] autorelease];
		[toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];		
	}

	CGRect dialogViewFrame = _dialogView.frame;
	dialogViewFrame.size.height = toolBarHeight + contentView.frame.size.height;
	_dialogView.frame = dialogViewFrame;

	[[_dialogView viewWithTag:1] removeFromSuperview];
	
	CGRect contentViewFrame = contentView.frame;
	contentViewFrame.origin.y = toolBarHeight;
	contentView.frame = contentViewFrame;
	contentView.tag = 1;
	[_dialogView addSubview:contentView];
	
	[UIView beginAnimations:@"showDialog" context:nil];
	[self reduceViewSizeByHeight:dialogViewFrame.size.height];
	dialogViewFrame.origin.y -= dialogViewFrame.size.height;
	_dialogView.frame = dialogViewFrame;
	[UIView commitAnimations];
	[_formTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)hideDialogView {
	dialogViewOn = NO;
	[UIView beginAnimations:@"hideDialog" context:nil];
	CGRect dialogViewFrame = _dialogView.frame;
	dialogViewFrame.origin.y += dialogViewFrame.size.height;
	_dialogView.frame = dialogViewFrame;
	[UIView commitAnimations];

	[self extendViewSizeByHeight:dialogViewFrame.size.height];
	[_formTableView deselectRowAtIndexPath:[_formTableView indexPathForSelectedRow] animated:YES];
	_hasSpaceForPickerView = nil;
	_lastLoginPickerView = nil;
	_agePickerView = nil;
}

#pragma Mark UIPickerViewDataSource / Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (_hasSpaceForPickerView == pickerView) {
		return 1;
	} else if (_lastLoginPickerView == pickerView) {
		return 1;
	} else if (_agePickerView == pickerView) {
		return 2;
	}
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (_hasSpaceForPickerView == pickerView) {
		return 7;
	} else if(_lastLoginPickerView == pickerView) {
		return 8;
	} else if (_agePickerView == pickerView) {
		return 83;
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (_hasSpaceForPickerView == pickerView) {
		if (row == 0) {
			return NSLocalizedString(@"ANY", nil);
		}
	} else if (_lastLoginPickerView == pickerView) {
		return [[self.lastLoginsData objectAtIndex:row] objectAtIndex:0];
	} else if (_agePickerView) {
		if (row == 0) {
			return NSLocalizedString(@"ANY", nil);
		}
		return [NSString stringWithFormat:@"%d", row + 17];
	}
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSIndexPath *actualIndexPath = [_formTableView indexPathForSelectedRow];
	if (_hasSpaceForPickerView == pickerView) {
		NSUInteger newHasSpaceFor = [_hasSpaceForPickerView selectedRowInComponent:0];
		if (self.filter.maxSurfers != newHasSpaceFor) {
			self.filter.maxSurfers = newHasSpaceFor;
		}
	} else if (_lastLoginPickerView == pickerView) {
		NSUInteger oldRow = [self selectedLastLoginDays];
		if (oldRow != row) {
			NSUInteger selectedValue = [[[self.lastLoginsData objectAtIndex:row] objectAtIndex:1] intValue];
			self.filter.lastLoginDays = selectedValue;
		}
	} else if (_agePickerView == pickerView) {
		NSUInteger actualAgeLow = 0;
		
		if ([pickerView selectedRowInComponent:0] != 0) {
			actualAgeLow = [pickerView selectedRowInComponent:0] + 17;
		}
		
		NSUInteger actualAgeHigh = 0;
		
		if ([pickerView selectedRowInComponent:1] != 0) {
			actualAgeHigh = [pickerView selectedRowInComponent:1] + 17;
		}

		if (self.filter.ageLow != actualAgeLow || self.filter.ageHigh != actualAgeHigh) {
			self.filter.ageLow = actualAgeLow;
			self.filter.ageHigh = actualAgeHigh;
		}
	}
	
	if (actualIndexPath != nil) {
		[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:actualIndexPath]
							  withRowAnimation:UITableViewRowAnimationNone];
		[_formTableView selectRowAtIndexPath:actualIndexPath
									animated:NO
							  scrollPosition:UITableViewScrollPositionMiddle];		
	}
	
}

- (NSUInteger)selectedLastLoginDays {
	NSUInteger index = 0;
	for (; index < [self.lastLoginsData count]; index++) {
		NSArray *row = [self.lastLoginsData objectAtIndex:index];
		if ([[row objectAtIndex:1] intValue] == self.filter.lastLoginDays) {
			break;
		}
	}
	return index;
}

#pragma Mark Cell creation methods

- (CSCheckboxCell *)getCheckboxCell {
	CSCheckboxCell * cell = (CSCheckboxCell *)[_formTableView dequeueReusableCellWithIdentifier:@"checkboxCell"];
	if (cell == nil) {
		cell = [[[CSCheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkboxCell"] autorelease];
	}	
	return cell;
}

- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected {
	CSSelectedValueCell * cell = (CSSelectedValueCell *)[_formTableView dequeueReusableCellWithIdentifier:@"selectedValueCell"];
	if (cell == nil) {
		cell = [[[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectedValueCell"] autorelease];
	}
	cell.keyLabel.text = title;
	cell.selectedValueLabel.text = (selected == nil) ? NSLocalizedString(@"ANY", nil) : selected;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cell makeLayout];
	return cell;
}

- (CSEditableCell *)getEditableCell {
	CSEditableCell * cell = (CSEditableCell *)[_formTableView dequeueReusableCellWithIdentifier:@"editableValueCell"];
	if (cell == nil) {
		cell = [[[CSEditableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editableValueCell"] autorelease];
	}

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell makeLayout];
	return cell;	
}

#pragma Mark View manipulation methods

- (void)reduceViewSizeByHeight:(CGFloat)byHeight {
	CGRect viewFrame = self.view.frame;
	viewFrame.size.height -= byHeight;
    self.view.frame = viewFrame;
}

- (void)extendViewSizeByHeight:(CGFloat)byHeight {
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height += byHeight;
    self.view.frame = viewFrame;
}

#pragma Mark TapableTableViewDelegate methods TODO mozna uz nebude treba

- (void)tableViewWasTouched:(TapableTableView *)tableView {
	if (dialogViewOn) {
		self.currentlyHiddenIndexPath = [tableView indexPathForSelectedRow];
		[self hideDialogView];
	} else {
		self.currentlyHiddenIndexPath = nil;
	}
}

#pragma Mark ChangeForm actions

- (void)switchHasChanged:(id)sender {
	if (self.hasCouchYesCB == sender) {
		self.filter.hasCouchYes = self.hasCouchYesCB.on;
	} else if (self.hasCouchMaybeCB == sender) {
		self.filter.hasCouchMaybe = self.hasCouchMaybeCB.on;
	} else if (self.hasCouchCoffeeOrDrinkCB == sender) {
		self.filter.hasCouchCoffeeOrDrink = self.hasCouchCoffeeOrDrinkCB.on;
	} else if (self.hasCouchTravelingCB == sender) {
		self.filter.hasCouchTraveling = self.hasCouchTravelingCB.on;
	} else if (self.maleCB == sender) {
		self.filter.male = self.maleCB.on;
	} else if (self.femaleCB == sender) {
		self.filter.female = self.femaleCB.on;
	} else if (self.groupCB == sender) {
		self.filter.severalPeople = self.groupCB.on;
	} else if (self.hasPhotoCB == sender) {
		self.filter.hasPhoto = self.hasPhotoCB.on;
	} else if (self.wheelchairAccessibleCB == sender) {
		self.filter.wheelchairAccessible = self.wheelchairAccessibleCB.on;
	} else if (self.verifiedCB == sender) {
		self.filter.verified = self.verifiedCB.on;
	} else if (self.vouchedCB == sender) {
		self.filter.vouched = self.vouchedCB.on;
	} else if (self.ambassadorCB == sender) {
		self.filter.ambassador = self.ambassadorCB.on;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (self.usernameTF == textField) {
		self.filter.username = textField.text;
	} else if (self.keywordTF == textField) {
		self.filter.keyword = textField.text;
	}
	_activeField = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	_activeField = textField;
}

#pragma Mark LanguagesListControllerDelegate methods

- (void)languagesListDidSelectLanguage:(LanguagesListController *)languagesList {
	[self refreshFormFilterInformation];
	[self.navigationController popViewControllerAnimated:YES];	
}

#pragma  Mark LocationSearchControllerDelegate

- (void)locationSearchDidSelectLocation:(LocationSearchController *)locationSearchController {
	[self refreshFormFilterInformation];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshFormFilterInformation {
	NSIndexPath *indexPath = [_formTableView indexPathForSelectedRow];
	[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						  withRowAnimation:UITableViewRowAnimationNone];
	[_formTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma Mark UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (viewController == self) {
		[_formTableView deselectRowAtIndexPath:[_formTableView indexPathForSelectedRow] animated:YES];		
	}
}

@end
