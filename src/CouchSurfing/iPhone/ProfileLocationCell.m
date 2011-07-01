//
//  ProfileLocationCell.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProfileLocationCell.h"


@implementation ProfileLocationCell

@synthesize keyLabel = _keyLabel;
@synthesize valueLabel = _valueLabel;
@synthesize dateLabel = _dateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _keyLabel = [[[UILabel alloc] init] autorelease];
		_keyLabel.font = [UIFont systemFontOfSize:11];
		_keyLabel.textColor = [UIColor lightGrayColor];
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

#pragma Public methods

- (void)makeLayout {
	_keyLabel.frame = CGRectMake(5, 5, 0, 0);
	[_keyLabel sizeToFit];
}

@end
