//
//  CouchSearchResultCell.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchResultCell.h"
#import "CSTools.h"

@implementation CouchSearchResultCell

@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect contentFrame = self.contentView.frame;
        
        _photoView = [[[UIImageView alloc] initWithFrame:CGRectMake(8.5, 9, 62.5, 62.5)] autorelease];
        [self.contentView addSubview:_photoView];
        
        UIImageView *photoFrameView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoFrame.png"]] autorelease];
        photoFrameView.backgroundColor = [UIColor clearColor];
        CGRect photoFrameViewFrame = photoFrameView.frame;
        photoFrameViewFrame.origin.x = 4;
        photoFrameViewFrame.origin.y = 3;
        photoFrameView.frame = photoFrameViewFrame;
        [self.contentView addSubview:photoFrameView];
        
        CGFloat rightColumnX = photoFrameViewFrame.size.width + photoFrameViewFrame.origin.x + 4;
        
        _nameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(rightColumnX, 10, contentFrame.size.width - rightColumnX, 18)] autorelease];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.shadowOffset = CGSizeMake(0, 1);
        _nameLabel.textColor = UIColorFromRGB(0x333637);
        _nameLabel.shadowColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
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

@end
