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

@property (nonatomic, retain) NSMutableDictionary *switches;
@property (nonatomic, retain) NSMutableDictionary *fields;

- (void)cancelForm;
- (void)searchAction;

- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;

- (void)showDialogViewWithContentView:(UIView *)contentView;
- (void)hideDialogView;

- (CSCheckboxCell *)createCheckboxCell:(NSString *)title filterKey:(NSString *)filterKey;
- (CSSelectedValueCell *)createSelectedValueCell:(NSString *)title selected:(NSString *)selected;
- (CSEditableCell *)createEditableCell:(NSString *)title filterKey:(NSString *)filterKey;

- (void)reduceViewSizeByHeight:(CGFloat)byHeight;
- (void)extendViewSizeByHeight:(CGFloat)byHeight;

@end


@implementation CouchSearchFormController

@synthesize searchResultController = _searchResultController;
@synthesize filter = _filter;

@synthesize formTableView = _formTableView;
@synthesize sections = _sections;
@synthesize items = _items;

@synthesize switches = _switches;
@synthesize fields = _fields;

- (void)viewDidLoad {
	_hasSpaceFor = self.filter.maxSurfers;
	self.sections = [NSArray arrayWithObjects:@"LOCATION", @"COUCH STATUS", @"HOST", @"", @"COMUNITY", @"PROFILE", nil];
					 
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
	NSArray *comunitySection = [NSArray arrayWithObjects:@"VERIFIED", @"VOUCHED", @"AMBASSADOR", nil];
	NSArray *profileSection = [NSArray arrayWithObjects:@"NAME USERNAME", @"KEYWORD", nil];
	
	self.items = [NSArray arrayWithObjects:locationSection,
				  couchStatusSection,
				  host1Section,
				  host2Section,
				  comunitySection, 
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
	
	self.switches = [NSMutableDictionary dictionary];
	self.fields = [NSMutableDictionary dictionary];
	
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
	self.switches = nil;
	self.fields = nil;
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
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"hasCouchYes"];
	} else if ([item isEqualToString:@"MAYBE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"hasCouchMaybe"];
	} else if ([item isEqualToString:@"COFFEE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"hasCouchCoffeeOrDrink"];
	} else if ([item isEqualToString:@"TRAVELING"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"hasCouchTraveling"];
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
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"male"];
	} else if ([item isEqualToString:@"FEMALE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"female"];
	} else if ([item isEqualToString:@"SEVERAL PEOPLE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"severalPeople"];
	} else if ([item isEqualToString:@"HAS PHOTO"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"hasPhoto"];
	} else if ([item isEqualToString:@"WHEELCHAIR ACCESSIBLE"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"wheelchairAccessible"];
	} else if ([item isEqualToString:@"VERIFIED"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"verified"];
	} else if ([item isEqualToString:@"VOUCHED"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"vouched"];
	} else if ([item isEqualToString:@"AMBASSADOR"]) {
		cell = [self createCheckboxCell:NSLocalizedString(item, nil) filterKey:@"ambassador"];
	} else if ([item isEqualToString:@"NAME USERNAME"]) {
		cell = [self createEditableCell:NSLocalizedString(item, nil) filterKey:@"username"];
	} else if ([item isEqualToString:@"KEYWORD"]) {
		cell = [self createEditableCell:NSLocalizedString(item, nil) filterKey:@"keyword"];
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
	
	for (NSString *key in self.switches) {
		
		UISwitch *checkbox = [self.switches objectForKey:key];
		
		SEL setterSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [NSString stringWithFormat:@"%@%@",[[key substringToIndex:1] capitalizedString],[key substringFromIndex:1]]]);
		NSInvocation *flagInvocation = [NSInvocation invocationWithMethodSignature:[self.filter methodSignatureForSelector:setterSel]];
		[flagInvocation setSelector:setterSel];
		BOOL result = checkbox.on;
		[flagInvocation setArgument:&result atIndex:2];
		[flagInvocation invokeWithTarget:self.filter];
	}
	
	for (NSString *key in self.fields) {
		UITextField *field = [self.fields objectForKey:key];
		SEL setterSel = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [NSString stringWithFormat:@"%@%@",[[key substringToIndex:1] capitalizedString],[key substringFromIndex:1]]]);
		NSInvocation *flagInvocation = [NSInvocation invocationWithMethodSignature:[self.filter methodSignatureForSelector:setterSel]];
		[flagInvocation setSelector:setterSel];
		
		NSString *result = field.text;
		[flagInvocation setArgument:&result atIndex:2];
		[flagInvocation invokeWithTarget:self.filter];
	}
	
	self.filter.maxSurfers = _hasSpaceFor;
	
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

- (CSCheckboxCell *)createCheckboxCell:(NSString *)title filterKey:(NSString *)filterKey {
	CSCheckboxCell * cell = (CSCheckboxCell *)[_formTableView dequeueReusableCellWithIdentifier:@"checkboxCell"];
	if (cell == nil) {
		cell = [[CSCheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkboxCell"];
	}
	
	UISwitch *checkbox = [[[UISwitch alloc] init] autorelease];
	[self.switches setObject:checkbox forKey:filterKey];
	cell.checkbox = checkbox;
	
	cell.keyLabel.text = title;
	NSInvocation *flagInvocation = [NSInvocation invocationWithMethodSignature:[self.filter methodSignatureForSelector:NSSelectorFromString(filterKey)]];
	[flagInvocation setSelector:NSSelectorFromString(filterKey)];
	[flagInvocation invokeWithTarget:self.filter];

	BOOL result;
	[flagInvocation getReturnValue:&result];

	[cell.checkbox setOn:result];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell makeLayout];
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

- (CSEditableCell *)createEditableCell:(NSString *)title filterKey:(NSString *)filterKey {
	CSEditableCell * cell = (CSEditableCell *)[_formTableView dequeueReusableCellWithIdentifier:@"editableValueCell"];
	if (cell == nil) {
		cell = [[CSEditableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editableValueCell"];
	}
	cell.keyLabel.text = title;
	
	NSInvocation *flagInvocation = [NSInvocation invocationWithMethodSignature:[self.filter methodSignatureForSelector:NSSelectorFromString(filterKey)]];
	[flagInvocation setSelector:NSSelectorFromString(filterKey)];
	[flagInvocation invokeWithTarget:self.filter];
	
	NSString *result;
	[flagInvocation getReturnValue:&result];

	
	UITextField *valueField = [[[UITextField alloc] init] autorelease];
	valueField.text = result;
	valueField.clearButtonMode = UITextFieldViewModeAlways;
	[self.fields setObject:valueField forKey:filterKey];
	cell.valueField = valueField;
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

@end
