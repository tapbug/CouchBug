//
//  CSSelectedValueCell.m
//  CouchSurfing
//
//  Created on 6/22/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "CSSelectedValueCell.h"
#import "CSTools.h"

@implementation CSSelectedValueCell

@synthesize keyLabel = _keyLabel;
@synthesize selectedValueLabel = _selectedValueLabel;
@synthesize simulateDisclosure = _simulateDisclosure;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_keyLabel = [[[UILabel alloc] init] autorelease];
		_keyLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		_keyLabel.font = [UIFont boldSystemFontOfSize:17];
		_keyLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_keyLabel];
		
		_selectedValueLabel = [[[UILabel alloc] init] autorelease];
		_selectedValueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		_selectedValueLabel.textColor = UIColorFromRGB(0x385487);
		_selectedValueLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:_selectedValueLabel];
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
	
	[_selectedValueLabel sizeToFit];
	CGRect selectedValueFrame = _selectedValueLabel.frame;
	
	if (self.simulateDisclosure) {
		selectedValueFrame.origin.x = self.contentView.frame.size.width - selectedValueFrame.size.width - 15 - 20;
	} else {
		selectedValueFrame.origin.x = self.contentView.frame.size.width - selectedValueFrame.size.width - 15;
	}

	selectedValueFrame.origin.y = (int)((self.contentView.frame.size.height - selectedValueFrame.size.height) / 2);

	_selectedValueLabel.frame = selectedValueFrame;
}

@end
