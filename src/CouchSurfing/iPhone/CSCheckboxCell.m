//
//  CSCheckboxCell.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSCheckboxCell.h"


@implementation CSCheckboxCell

@synthesize keyLabel = _keyLabel;
@synthesize checkbox = _checkbox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_keyLabel = [[[UILabel alloc] init] autorelease];
		_keyLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		_keyLabel.font = [UIFont boldSystemFontOfSize:17];
		[self.contentView addSubview:_keyLabel];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

#pragma Mark public methods

- (void)makeLayout {
	[_keyLabel sizeToFit];
	CGRect keyLabelFrame = _keyLabel.frame;
	keyLabelFrame.origin.x = 5;
	keyLabelFrame.origin.y = (int)((self.contentView.frame.size.height - keyLabelFrame.size.height) / 2);
	_keyLabel.frame = keyLabelFrame;
	
	_checkbox.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	CGRect checkboxFrame = _checkbox.frame;
	checkboxFrame.origin.x = self.contentView.frame.size.width - checkboxFrame.size.width - 5;
	checkboxFrame.origin.y = (int)((self.contentView.frame.size.height - checkboxFrame.size.height) / 2);
	_checkbox.frame = checkboxFrame;
	
	[self.contentView addSubview:_checkbox];
}

@end
