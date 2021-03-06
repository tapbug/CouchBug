//
//  CouchRequestFormController.h
//  CouchSurfing
//
//  Created on 6/27/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouchRequestRequest.h"

@class CouchSurfer;
@class ActivityOverlap;

@interface CouchRequestFormController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CouchRequestRequestDelegate, UIAlertViewDelegate> {
    CouchSurfer *_surfer;
	
	UIBarButtonItem *_sendButton;
	UITableView *_formTableView;
	UIView *_dialogView;
	
	UITextField *_subjectTF;
	BOOL _subjectHasText;
	UITextView *_messageTV;
	UIResponder *_activeResponder;
	
	BOOL dialogViewOn;
	BOOL keyboardOn;
	
	UIDatePicker *_datePicker;
	NSDate *_arrivalDate;
	NSDate *_departureDate;
	
	
	UIPickerView *_numberOfSurfersPickerView;
	NSInteger _numberOfSurfers;
	
	UIPickerView *_arrivingViaPickerView;	
	NSArray *_arrivingViaData;
	NSInteger _arrivingViaId;
	NSString *_arrivingViaName;
	NSInteger _arrivingViaIndex;
	
	CouchRequestRequest *_couchRequest;
	ActivityOverlap *_activityOverlap;
}

- (id)initWithSurfer:(CouchSurfer *)surfer;

@end
