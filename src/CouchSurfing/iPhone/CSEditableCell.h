//
//  CSEditableCell.h
//  CouchSurfing
//
//  Created on 6/23/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSEditableCell : UITableViewCell {
	UILabel *_keyLabel;
	UITextField *_valueField;
}

@property (readonly) UILabel *keyLabel;
@property (nonatomic, assign) UITextField *valueField;

- (void)makeLayout;

@end
