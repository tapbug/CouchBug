//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileRequest.h"

@class CouchSurfer;
@class CXMLDocument;

@interface ProfileController : UIViewController <UITableViewDelegate, UITableViewDataSource, ProfileRequestDelegate> {
	CouchSurfer *_surfer;
	
	UITableView *_tableView;
    UIImageView *_photoView;
	BOOL _imageObserved;
	
	UILabel *_currentMissionValueLabel;
	UIView *_currentMissionView;
	UIView *_currentMissionViewPlaceholder;
	
	ProfileRequest *_profileRequest;
	
	NSArray *_sections;
	
	//	stazena stranka profile
	CXMLDocument *_doc;
	//	zpracovana data pro zobrazeni v tabulce of couch infu
	NSArray *_couchInfoValues;
	
	BOOL _parsePersonalDescriptionAfterProfileDidLoad;
	
}

- (id)initWithSurfer:(CouchSurfer *)surfer;

@end
