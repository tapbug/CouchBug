//
//  TapableTableView.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabableTableViewDelegate;

@interface TapableTableView : UITableView {
    id<TabableTableViewDelegate> _tapDelegate;
	BOOL _justTableTouch;
}

@property(nonatomic, assign) id<TabableTableViewDelegate> tapDelegate;
@property(nonatomic, assign) BOOL justTableTouch;

@end

@protocol TabableTableViewDelegate <NSObject>

- (void)tableViewWasTouched:(TapableTableView *)tableView;

@end