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
#import "CSEditableCell.h"

#import "CSTools.h"

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

- (void)cancelForm;
- (void)searchAction;

- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;

- (void)showDialogViewWithContentView:(UIView *)contentView;
- (void)hideDialogView;

- (CSCheckboxCell *)getCheckboxCell;
- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected;
- (CSEditableCell *)getEditableCell;

- (void)reduceViewSizeByHeight:(CGFloat)byHeight;
- (void)extendViewSizeByHeight:(CGFloat)byHeight;

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

- (void)viewDidLoad {
	_hasSpaceFor = self.filter.maxSurfers;
	self.sections = [NSArray arrayWithObjects:@"LOCATION", @"COUCH STATUS", @"HOST", @"", @"COMMUNITY", @"PROFILE", nil];
					 
	NSArray *locationSection = [NSArray arrayWithObject:@"LOCATION"];
	NSArray *couchStatusSection = [NSArray arrayWithObjects:@"YES",
								   @"MAYBE", 
								   @"COFFEE",
								   @"TRAVELING",
								   nil];
	NSArray *host1Section = [NSArray arrayWithObjects:
							@"AGE", @"HAS SPACE FOR", @"LANGUAGE", @"LAST LOGIN", nil];
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
	
	_formTableView = [[[TapableTableView alloc] initWithFrame:CGRectMake(0, 
																   toolBar.frame.size.height,
																   self.view.frame.size.width,
																   self.view.frame.size.height - toolBar.frame.size.height) 
												   style:UITableViewStyleGrouped] autorelease];
	_formTableView.tapDelegate = self;
	_formTableView.backgroundColor = [UIColor clearColor];
	_formTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_formTableView.delegate = self;
	_formTableView.dataSource = self;
	[self.view addSubview:_formTableView];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
	
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
			textLabel.adjustsFontSizeToFitWidth = YES;
			[cell.contentView addSubview:textLabel];
		}
		UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1];
		textLabel.text = self.filter.locationName; //otestovat veeelkou delku
		
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
					 self.filter.ageLow == nil ? NSLocalizedString(@"ANY", nil) : self.filter.ageLow,
					 self.filter.ageHigh == nil ? NSLocalizedString(@"ANY", nil) : self.filter.ageHigh];
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:value];
	} else if ([item isEqualToString:@"HAS SPACE FOR"]) {
		NSString *value;
		if (_hasSpaceFor == 0) {
			value = NSLocalizedString(@"ANY", nil);
		} else {
			value = [NSString stringWithFormat:@"%d", _hasSpaceFor];
		}
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:value];
	} else if ([item isEqualToString:@"LANGUAGE"]) {
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:@"English"];
	} else if ([item isEqualToString:@"LAST LOGIN"]) {
		cell = [self createSelectedValueCell:NSLocalizedString(item, nil) selected:self.filter.lastLoginDays];
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
		}
		
		csCell.keyLabel.text = NSLocalizedString(item, nil);
		csCell.valueField = self.usernameTF;
		[csCell makeLayout];
		cell = csCell;
	} else if ([item isEqualToString:@"KEYWORD"]) {
		CSEditableCell *csCell = [self getEditableCell];
		if (self.keywordTF	== nil) {
			self.keywordTF = [[[UITextField alloc] init] autorelease];
			self.keywordTF.clearButtonMode = UITextFieldViewModeAlways;
			self.keywordTF.delegate = self;
		}
		
		csCell.keyLabel.text = NSLocalizedString(item, nil);
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
		[_hasSpaceForPickerView selectRow:_hasSpaceFor inComponent:0 animated:NO];
		[self showDialogViewWithContentView:_hasSpaceForPickerView];
	}
}

#pragma Mark Action methods

- (void)cancelForm {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self hideDialogView];
}

- (void)searchAction {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self hideDialogView];
	[self.searchResultController performSearch];
}

#pragma Mark Keyboard events methods

- (void)keyboardDidShow:(NSNotification *)notification {
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
	_formTableView.justTableTouch = YES;
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
		
		UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, _dialogView.frame.size.width, toolBarHeight)];
		toolBar.tintColor = UIColorFromRGB(0x3d4041);
		[_dialogView addSubview:toolBar];
				
		UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																					 target:self
																					 action:@selector(hideDialogView)] autorelease];
		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																					   target:nil
																					   action:nil];
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
	_formTableView.justTableTouch = NO;
	dialogViewOn = NO;
	[UIView beginAnimations:@"hideDialog" context:nil];
	CGRect dialogViewFrame = _dialogView.frame;
	[self extendViewSizeByHeight:dialogViewFrame.size.height];
	dialogViewFrame.origin.y += dialogViewFrame.size.height;
	_dialogView.frame = dialogViewFrame;
	[UIView commitAnimations];
	
	_hasSpaceForPickerView = nil;
}

#pragma Mark UIPickerViewDataSource / Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (_hasSpaceForPickerView == pickerView) {
		return 1;
	}
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (_hasSpaceForPickerView) {
		return 7;
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (_hasSpaceForPickerView == pickerView) {
		if (row == 0) {
			return NSLocalizedString(@"ANY", nil);
		}
	}
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (_hasSpaceForPickerView == pickerView) {
		NSUInteger newHasSpaceFor = [_hasSpaceForPickerView selectedRowInComponent:0];
		if (_hasSpaceFor != newHasSpaceFor) {
			_hasSpaceFor = newHasSpaceFor;
			[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:2]]
								  withRowAnimation:UITableViewRowAnimationMiddle];		
		}
	}
}

#pragma Mark Cell creation methods

- (CSCheckboxCell *)getCheckboxCell {
	CSCheckboxCell * cell = (CSCheckboxCell *)[_formTableView dequeueReusableCellWithIdentifier:@"checkboxCell"];
	if (cell == nil) {
		cell = [[CSCheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkboxCell"];
	}	
	return cell;
}

- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected {
	CSSelectedValueCell * cell = (CSSelectedValueCell *)[_formTableView dequeueReusableCellWithIdentifier:@"selectedValueCell"];
	if (cell == nil) {
		cell = [[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectedValueCell"];
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
		cell = [[CSEditableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editableValueCell"];
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

#pragma Mark TapableTableViewDelegate methods

- (void)tableViewWasTouched:(TapableTableView *)tableView {
	if (dialogViewOn) {
		[self hideDialogView];
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
}

@end
