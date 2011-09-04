//
//  CouchRequestFormController.m
//  CouchSurfing
//
//  Created on 6/27/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CouchRequestFormController.h"
#import "CouchSurfer.h"

#import "CSTools.h"

#import "CSSelectedValueCell.h"
#import "ActivityOverlap.h"
#import "FlurryAPI.h"

@interface CouchRequestFormController ()

@property (nonatomic, retain) CouchSurfer *surfer;

@property (nonatomic, retain) UITextField *subjectTF;
@property (nonatomic, retain) UITextView *messageTV;

@property (nonatomic, retain) NSDate *arrivalDate;
@property (nonatomic, retain) NSDate *departureDate;

@property (nonatomic, retain) CouchRequestRequest *couchRequest;
@property (nonatomic, retain) ActivityOverlap *activityOverlap;


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
- (void)refreshFormInformation;

- (void)reduceViewSizeByHeight:(CGFloat)byHeight;
- (void)extendViewSizeByHeight:(CGFloat)byHeight;

- (void)cancelAction;
- (void)sendAction;

- (void)arrivalDateChanged:(UIDatePicker *)sender;
- (void)departureDateChanged:(UIDatePicker *)sender;

- (void)revalidateSendButton;

@end

@implementation CouchRequestFormController

@synthesize surfer = _surfer;
@synthesize arrivalDate = _arrivalDate;
@synthesize departureDate = _departureDate;
@synthesize subjectTF = _subjectTF;
@synthesize messageTV = _messageTV;
@synthesize couchRequest = _couchRequest;
@synthesize activityOverlap = _activityOverlap;

- (id)initWithSurfer:(CouchSurfer *)surfer {
    self = [super init];
    if (self) {
        self.surfer = surfer;
    }
    return self;
}
- (void)dealloc {
	self.surfer = nil;
	self.subjectTF = nil;
	self.messageTV = nil;
	[_arrivingViaData release]; _arrivingViaData = nil;
	self.couchRequest.delegate = nil;
	self.couchRequest = nil;
	self.activityOverlap = nil;
	self.arrivalDate = nil;
	self.departureDate = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clothBg"]];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.activityOverlap = [[[ActivityOverlap alloc] initWithView:self.view
														   title:NSLocalizedString(@"SENDING", nil)] autorelease];
	
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self
																				   action:@selector(cancelAction)] autorelease];

	_sendButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SEND", nil) 
																	style:UIBarButtonItemStyleDone target:self 
																   action:@selector(sendAction)] autorelease];
	_sendButton.enabled = NO;
	
	UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0,
																	 0,
																	 self.view.frame.size.width,
																	 44)] autorelease];
	
	UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
																					target:nil
																					action:nil] autorelease];
	UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
	titleLabel.font = [UIFont boldSystemFontOfSize:19];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.text = NSLocalizedString(@"COUCHREQUEST", nil);
	[titleLabel sizeToFit];
	UIBarButtonItem *titleItem = [[[UIBarButtonItem alloc] initWithCustomView:titleLabel] autorelease];
	
	toolbar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
	[toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexibleSpace, titleItem, flexibleSpace, _sendButton, nil]];
	toolbar.tintColor = UIColorFromRGB(0x3d4041);
	[self.view addSubview:toolbar];
	
	_formTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0,
																	toolbar.frame.size.height,
																	self.view.frame.size.width,
																	self.view.frame.size.height - toolbar.frame.size.height) 
												   style:UITableViewStyleGrouped] autorelease];

	_formTableView.backgroundColor = [UIColor clearColor];
	_formTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_formTableView.delegate = self;
	_formTableView.dataSource = self;
	[self.view addSubview:_formTableView];
	
	self.arrivalDate = [NSDate date];
	self.departureDate = [self.arrivalDate dateByAddingTimeInterval:3 * 24 * 60 * 60];
	
	self.subjectTF = [[[UITextField alloc] init] autorelease];
	self.subjectTF.returnKeyType = UIReturnKeyDone;	
	self.subjectTF.placeholder = NSLocalizedString(@"SUBJECT", nil);
	self.subjectTF.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.subjectTF.delegate = self;
	
	self.messageTV = [[[UITextView alloc] init] autorelease];
	self.messageTV.text = NSLocalizedString(@"REQUEST SIGNATURE", nil);
	self.messageTV.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.messageTV.delegate = self;
	[self registerForKeyboardEvents];
	
	_numberOfSurfers = 1;
	_arrivingViaIndex = 0;
	_arrivingViaId = 0;
	_arrivingViaData = [[NSArray arrayWithObjects:
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:0], @"CHOOSE", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:1], @"PLANE", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:2], @"MOTOR VEHICLE", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:3], @"BUS", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:4], @"TRAIN", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:5], @"BICYCLE", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:6], @"FOOT", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:8], @"METRO", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:9], @"BOAT", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:10], @"HITCH-HIKING", nil],
						 [NSArray arrayWithObjects:[NSNumber numberWithInt:7], @"OTHER", nil], nil ] retain];
	_arrivingViaName = [[_arrivingViaData objectAtIndex:0] objectAtIndex:1];
    [super viewDidLoad];
}

- (void)viewDidUnload {
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma Mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
		
	if (indexPath.section == 0) {
		CSSelectedValueCell *csCell = (CSSelectedValueCell *)[tableView dequeueReusableCellWithIdentifier:@"selectedValueCell"];

		if (csCell == nil) {
			csCell = [[[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault
												 reuseIdentifier:@"selectedValueCell"] autorelease];			
		}
		
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];		
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		NSString *dateString;
		
		if (indexPath.row == 0) {
			csCell.keyLabel.text = NSLocalizedString(@"ARRIVAL DATE", nil);
			dateString = [dateFormatter stringForObjectValue:self.arrivalDate];
		} else {
			csCell.keyLabel.text = NSLocalizedString(@"DEPARTURE DATE", nil);
			dateString = [dateFormatter stringForObjectValue:self.departureDate];
		}
		csCell.selectedValueLabel.text = dateString;
		csCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[csCell makeLayout];
		cell = csCell;
	} else if (indexPath.section == 1) {		
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"subjectCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											   reuseIdentifier:@"subjectCell"] autorelease];
				[cell.contentView addSubview:self.subjectTF];
			}
			CGFloat height = 22;
			CGFloat width = cell.contentView.frame.size.width - 6;
			self.subjectTF.frame = CGRectMake((int)(cell.contentView.frame.size.width - width) / 2,
											  (int)(cell.contentView.frame.size.height - height) / 2,
											  width,
											  height);
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
											   reuseIdentifier:@"messageCell"] autorelease];
				[cell.contentView addSubview:self.messageTV];
			}
			CGFloat width = cell.contentView.frame.size.width - 6;
			CGFloat height = cell.contentView.frame.size.height - 6;
			self.messageTV.frame = CGRectMake((int)(cell.contentView.frame.size.width - width) / 2,
											  (int)(cell.contentView.frame.size.height - height) / 2,
											  width,
											  height);
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
	} else if (indexPath.section == 2) {
		CSSelectedValueCell *csCell = (CSSelectedValueCell *)[tableView dequeueReusableCellWithIdentifier:@"selectedValueCell"];
		
		if (csCell == nil) {
			csCell = [[[CSSelectedValueCell alloc] initWithStyle:UITableViewCellStyleDefault
												 reuseIdentifier:@"selectedValueCell"] autorelease];			
		}
		if (indexPath.row == 0) {
			csCell.keyLabel.text = NSLocalizedString(@"NUMBER OF SURFERS", nil);
			csCell.selectedValueLabel.text = [NSString stringWithFormat:@"%d", _numberOfSurfers];
		} else if (indexPath.row == 1){
			csCell.keyLabel.text = NSLocalizedString(@"ARRIVING VIA", nil);
			csCell.selectedValueLabel.text = NSLocalizedString(_arrivingViaName, nil);;
		}
		csCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[csCell makeLayout];
		cell = csCell;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 1) {
		return 132;
	}
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		_datePicker = [[[UIDatePicker alloc] init] autorelease];
		_datePicker.datePickerMode = UIDatePickerModeDate;
		if (indexPath.row == 0) {
			_datePicker.minimumDate = [NSDate date];
			[_datePicker addTarget:self action:@selector(arrivalDateChanged:) forControlEvents:UIControlEventValueChanged];
			_datePicker.date = self.arrivalDate;
		} else {
			_datePicker.minimumDate = self.arrivalDate;
			[_datePicker addTarget:self action:@selector(departureDateChanged:) forControlEvents:UIControlEventValueChanged];			
			_datePicker.date = self.departureDate;
		}
		[self showDialogViewWithContentView:_datePicker];
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			[self.subjectTF becomeFirstResponder];
		} else if (indexPath.row == 1) {
			[self.messageTV becomeFirstResponder];
		}
	} else if (indexPath.section == 2) {
		UIPickerView *pickerView = [[[UIPickerView alloc] init] autorelease];
		pickerView.showsSelectionIndicator = YES;
		pickerView.delegate = self;

		if (indexPath.row == 0) {
			_numberOfSurfersPickerView = pickerView;
			[pickerView selectRow:_numberOfSurfers - 1 inComponent:0 animated:NO];
		} else if (indexPath.row == 1) {
			_arrivingViaPickerView = pickerView;
			[pickerView selectRow:_arrivingViaIndex inComponent:0 animated:NO];
		}

		[self showDialogViewWithContentView:pickerView];
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
	[_activeResponder resignFirstResponder];
	[_formTableView deselectRowAtIndexPath:[_formTableView indexPathForSelectedRow] animated:NO];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	keyboardOn = YES;	

	if (dialogViewOn) {
		[self hideDialogView];		
	}

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
	
	[self extendViewSizeByHeight:keyboardHeigh];
}

#pragma Mark DialogView methods

- (void)showDialogViewWithContentView:(UIView *)contentView {
	if (keyboardOn) {
		[self hideKeyboard];
	}
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

	//	DialogDidHide
	
	if ([self.departureDate earlierDate:self.arrivalDate] == self.departureDate) {
		self.departureDate = self.arrivalDate;
		[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]]
							  withRowAnimation:UITableViewRowAnimationNone];
	}
	
	//TODO nil pickers
}

#pragma Mark UIPickerViewDataSource / Delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (_numberOfSurfersPickerView == pickerView) {
		return 7;
	} else if (_arrivingViaPickerView == pickerView) {
		return [_arrivingViaData count];
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (_numberOfSurfersPickerView == pickerView) {
		return [NSString stringWithFormat:@"%d", row + 1];
	} else if (_arrivingViaPickerView == pickerView) {
		return NSLocalizedString([[_arrivingViaData objectAtIndex:row] objectAtIndex:1], nil);
	}
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (_numberOfSurfersPickerView == pickerView) {
		_numberOfSurfers = row + 1;
	} else if (_arrivingViaPickerView == pickerView) {
		_arrivingViaId = [[[_arrivingViaData objectAtIndex:row] objectAtIndex:0] intValue];
		_arrivingViaName = [[_arrivingViaData objectAtIndex:row] objectAtIndex:1]; 
		_arrivingViaIndex = row;
	}
	
	[self revalidateSendButton];
	NSIndexPath *actualIndexPath = [_formTableView indexPathForSelectedRow];
	if (actualIndexPath != nil) {
		[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:actualIndexPath]
							  withRowAnimation:UITableViewRowAnimationNone];
		[_formTableView selectRowAtIndexPath:actualIndexPath
									animated:NO
							  scrollPosition:UITableViewScrollPositionMiddle];		
	}
	
}

#pragma Mark UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (viewController == self) {
		[_formTableView deselectRowAtIndexPath:[_formTableView indexPathForSelectedRow] animated:YES];		
	}
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

- (void)refreshFormInformation {
	NSIndexPath *indexPath = [_formTableView indexPathForSelectedRow];
	if (indexPath != nil) {
		[_formTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
							  withRowAnimation:UITableViewRowAnimationNone];
		[_formTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];		
	}
}

#pragma Mark Actions methods

- (void)cancelAction {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self hideDialogView];
}

- (void)sendAction {
	self.couchRequest = [[[CouchRequestRequest alloc] init] autorelease];
	self.couchRequest.arrivalDate = self.arrivalDate;
	self.couchRequest.departureDate = self.departureDate;
	self.couchRequest.subject = self.subjectTF.text;
	self.couchRequest.message = self.messageTV.text;
	self.couchRequest.numberOfSurfers = _numberOfSurfers;
	self.couchRequest.arrivalViaId = _arrivingViaId;
	self.couchRequest.surfer = self.surfer;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSString *dateFormat = [userDefaults stringForKey:@"dateFormat"];
	if (dateFormat != nil) {
		self.couchRequest.dateFormat = dateFormat;
	}
	
	self.couchRequest.delegate = self;
	[self.couchRequest sendCouchRequest];
	[self.activityOverlap overlapView];
}

- (void)arrivalDateChanged:(UIDatePicker *)sender {
	self.arrivalDate = sender.date;
	[self refreshFormInformation];
}

- (void)departureDateChanged:(UIDatePicker *)sender {
	self.departureDate = sender.date;
	[self refreshFormInformation];
}

#pragma Mark Editable Fields Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[_formTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	_activeResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	_activeResponder = nil;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[_formTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
	_activeResponder = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	_activeResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
	[self revalidateSendButton];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	_subjectHasText = ![[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""];
	[self revalidateSendButton];
	return YES;
}

#pragma Mark CouchRequestRequestDelegate methods

- (void)couchRequestRequestDidSent:(CouchRequestRequest *)request {
	[self.activityOverlap removeOverlap];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"COUCHREQUEST SENT", nil) 
														message:nil
													   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles:nil];
	alertView.delegate = self;
	[alertView show];
	[alertView release]; alertView = nil;
	
	[FlurryAPI logEvent:@"CouchRequest" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
													 @"YES", 
													 @"Sent", 
													 nil]];
}

- (void)couchRequestDidFailedWithErrors:(NSDictionary *)errors {
	[self.activityOverlap removeOverlap];
	NSMutableArray *messages = [NSMutableArray array];
	for (NSString *key in errors) {
		[messages addObject:[errors objectForKey:key]];
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) 
														message:[messages componentsJoinedByString:@"\n"]
													   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release]; alertView = nil;
	
	[FlurryAPI logEvent:@"CouchRequest" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
														@"NO", 
														@"Sent", 
														nil]];
	
	[FlurryAPI logEvent:@"CouchRequest Error" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
														messages, 
														@"Error", 
														nil]];
}

#pragma Mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

#pragma Mark ViewController statuses

- (void)revalidateSendButton {
	BOOL enabled = YES;
	if (!_subjectHasText) {
		enabled = NO;
	}
	if (![self.messageTV hasText]) {
		enabled = NO;
	}
	_sendButton.enabled = enabled;
}

@end

