//
//  CSSelectedValueCell.h
//  CouchSurfing
//
//  Created on 6/22/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSSelectedValueCell : UITableViewCell {
	UILabel *_keyLabel;
	UILabel *_selectedValueLabel;
	BOOL _simulateDisclosure;
}

@property (readonly) UILabel *keyLabel;
@property (readonly) UILabel *selectedValueLabel;
@property (nonatomic, assign) BOOL simulateDisclosure;

- (void)makeLayout;

@end
