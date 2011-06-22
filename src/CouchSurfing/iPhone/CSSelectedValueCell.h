//
//  CSSelectedValueCell.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSSelectedValueCell : UITableViewCell {
	UILabel *_keyLabel;
	UILabel *_selectedValueLabel;
	
}

@property (readonly) UILabel *keyLabel;
@property (readonly) UILabel *selectedValueLabel;

- (void)makeLayout;

@end
