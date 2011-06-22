//
//  CSCheckboxCell.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSCheckboxCell : UITableViewCell {
    UILabel *_keyLabel;
	UISwitch *_checkbox;
}

@property (readonly) UILabel *keyLabel;
@property (readonly) UISwitch *checkbox;

- (void)makeLayout;

@end
