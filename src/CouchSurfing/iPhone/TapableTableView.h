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
}

@property(nonatomic, assign) id<TabableTableViewDelegate> tapDelegate;

@end

@protocol TabableTableViewDelegate <NSObject>

- (void)tableViewWasTouched:(TapableTableView *)tableView;

@end