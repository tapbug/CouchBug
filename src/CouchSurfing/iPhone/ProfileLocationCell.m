//
//  ProfileLocationCell.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileLocationCell.h"
#import "CSTools.h"

@implementation ProfileLocationCell

@synthesize keyLabel = _keyLabel;
@synthesize valueLabel = _valueLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _keyLabel = [[[UILabel alloc] init] autorelease];
		_keyLabel.font = [UIFont systemFontOfSize:12];
		_keyLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:_keyLabel];
		
		_valueLabel = [[[UILabel alloc] init] autorelease];
		_valueLabel.font = [UIFont boldSystemFontOfSize:12];
		_valueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.contentView addSubview:_valueLabel];
		
		_dateLabel = [[[UILabel alloc] init] autorelease];
		_dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_dateLabel.font = [UIFont systemFontOfSize:12];
		_dateLabel.textColor = UIColorFromRGB(0x2957ff);
		[self.contentView addSubview:_dateLabel];
		
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

#pragma Public methods

- (void)makeLayout {
	_keyLabel.frame = CGRectMake(7, 7, 0, 0);
	[_keyLabel sizeToFit];
	_valueLabel.frame = CGRectMake(7,
								   _keyLabel.frame.size.height + 7,
								   self.contentView.frame.size.width - 14,
								   [_valueLabel.text sizeWithFont:_valueLabel.font].height);
	CGSize dateLabelSize = [_dateLabel.text sizeWithFont:_dateLabel.font];
	_dateLabel.frame = CGRectMake(self.contentView.frame.size.width - 7 - dateLabelSize.width,
								  _keyLabel.frame.origin.y,
								  dateLabelSize.width,
								  dateLabelSize.height);
}

@end
