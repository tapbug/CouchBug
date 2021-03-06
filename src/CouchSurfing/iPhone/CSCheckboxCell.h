//
//  CSCheckboxCell.h
//  CouchSurfing
//
//  Created on 6/22/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSCheckboxCell : UITableViewCell {
    UILabel *_keyLabel;
	UISwitch *_checkbox;
}

@property (readonly) UILabel *keyLabel;
@property (nonatomic, assign) UISwitch *checkbox;

- (void)makeLayout;

@end
