//
//  CSEditableCell.m
//  CouchSurfing
//
//  Created on 6/23/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CSEditableCell.h"


@implementation CSEditableCell

@synthesize keyLabel = _keyLabel;
@synthesize valueField = _valueField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_keyLabel = [[[UILabel alloc] init] autorelease];
		_keyLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		_keyLabel.font = [UIFont boldSystemFontOfSize:17];
		_keyLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_keyLabel];
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

- (void)makeLayout {
	[_keyLabel sizeToFit];
	CGRect keyLabelFrame = _keyLabel.frame;
	keyLabelFrame.origin.x = 5;
	keyLabelFrame.origin.y = (int)((self.contentView.frame.size.height - keyLabelFrame.size.height) / 2);
	_keyLabel.frame = keyLabelFrame;
	
	_valueField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_valueField.textAlignment = UITextAlignmentRight;
	[self.contentView addSubview:_valueField];

	CGFloat valueX = keyLabelFrame.origin.x + keyLabelFrame.size.width + 4;
	_valueField.frame = CGRectMake(valueX,
								   (int)((self.contentView.frame.size.height - 20) / 2),
								   self.contentView.frame.size.width - valueX - 4,
								   22);
	_valueField.returnKeyType = UIReturnKeyDone;
	_valueField.autocorrectionType = UITextAutocorrectionTypeNo;
}

@end
