//
//  ProfileController.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CouchSurfer;

@interface ProfileController : UIViewController {
	CouchSurfer *_surfer;
	
	UITableView *_tableView;
    UIImageView *_photoView;
	BOOL _imageObserved;
}

- (id)initWithSurfer:(CouchSurfer *)surfer;

@end
