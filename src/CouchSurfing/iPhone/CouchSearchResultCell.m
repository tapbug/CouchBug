//
//  CouchSearchResultCell.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CouchSearchResultCell.h"
#import "CSTools.h"

@interface CouchSearchResultCell ()

- (UILabel *)createCountLabel;

@end

@implementation CouchSearchResultCell

@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;
@synthesize basicsLabel = _basicsLabel;
@synthesize aboutLabel = _aboutLabel;
@synthesize referencesCountLabel = _referencesCountLabel;
@synthesize photosCountLabel = _photosCountLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _photoView = [[[UIImageView alloc] init] autorelease];
        [self.contentView addSubview:_photoView];
        
        _photoFrameView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photoFrame.png"]] autorelease];
        _photoFrameView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_photoFrameView];
                
        _nameLabel = [[[UILabel alloc] init] autorelease];
        _nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _nameLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.shadowOffset = CGSizeMake(0, 1);
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.shadowColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        _basicsLabel = [[[UILabel alloc] init] autorelease];
        _basicsLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _basicsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _basicsLabel.backgroundColor = [UIColor clearColor];
        _basicsLabel.font = [UIFont boldSystemFontOfSize:11.5];
        _basicsLabel.shadowOffset = CGSizeMake(0, 1);
        _basicsLabel.textColor = UIColorFromRGB(0x4d4d4d);
        _basicsLabel.shadowColor = [UIColor whiteColor];
        [self.contentView addSubview:_basicsLabel];
        
        _aboutLabel = [[[UILabel alloc] init] autorelease];
        _aboutLabel.numberOfLines = 2;
        _aboutLabel.lineBreakMode = UILineBreakModeWordWrap | UILineBreakModeTailTruncation;
        _aboutLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _aboutLabel.backgroundColor = [UIColor clearColor];
        _aboutLabel.font = [UIFont systemFontOfSize:11.5];
        _aboutLabel.textColor = UIColorFromRGB(0x4d4d4d);
        [self.contentView addSubview:_aboutLabel];
        
        _referencesCountLabel = [self createCountLabel];
        [self.contentView addSubview:_referencesCountLabel];
        
        _referencesLabel = [[[UILabel alloc] init] autorelease];
        _referencesLabel.backgroundColor = [UIColor clearColor];
        _referencesLabel.text = NSLocalizedString(@"references", @"references label in couch search result table cell");
        _referencesLabel.textColor = UIColorFromRGB(0x6b6b6b);
        _referencesLabel.font = [UIFont systemFontOfSize:11.5];
        [_referencesLabel sizeToFit];
        [self.contentView addSubview:_referencesLabel];
        
        _photosCountLabel = [self createCountLabel];
        [self.contentView addSubview:_photosCountLabel];
        
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

#pragma Mark Public methods

- (void)makeLayout {
    CGRect contentFrame = self.contentView.frame;
    _photoView.frame = CGRectMake(8.5, 9, 62.5, 62.5);
    
    CGRect photoFrameViewFrame = _photoFrameView.frame;
    photoFrameViewFrame.origin.x = 4;
    photoFrameViewFrame.origin.y = 3;
    _photoFrameView.frame = photoFrameViewFrame;
    
    CGFloat rightColumnX = photoFrameViewFrame.size.width + photoFrameViewFrame.origin.x + 2;
    CGFloat rightColumnWidth = contentFrame.size.width - rightColumnX - 5;
    
    CGSize nameSize = [_nameLabel.text sizeWithFont:_nameLabel.font
                                              forWidth:rightColumnWidth
                                         lineBreakMode:UILineBreakModeTailTruncation];
    _nameLabel.frame = CGRectMake(rightColumnX, 7, rightColumnWidth, nameSize.height);
    
    CGFloat basicsTop = _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 2;
    CGSize basicsSize = [_basicsLabel.text sizeWithFont:_basicsLabel.font
                                      constrainedToSize:CGSizeMake(rightColumnWidth, 12) 
                                          lineBreakMode:_basicsLabel.lineBreakMode];
    _basicsLabel.frame = CGRectMake(rightColumnX, basicsTop, rightColumnWidth, basicsSize.height);
    
    CGFloat aboutTop = basicsTop + basicsSize.height + 2;
    CGSize aboutSize = [_aboutLabel.text sizeWithFont:_aboutLabel.font
                                    constrainedToSize:CGSizeMake(rightColumnWidth, 25)
                                        lineBreakMode:_aboutLabel.lineBreakMode];
    _aboutLabel.frame = CGRectMake(rightColumnX, aboutTop, rightColumnWidth, aboutSize.height);
    
    CGFloat countsTop = aboutTop + aboutSize.height + 2;

    CGSize referencesCountSize = [_referencesCountLabel.text sizeWithFont:_referencesCountLabel.font
                                                        constrainedToSize:CGSizeMake(30, CGFLOAT_MAX)];
    _referencesCountLabel.frame = CGRectMake(rightColumnX, countsTop, referencesCountSize.width + 6, 14);
    
    CGRect referencesLabelFrame = _referencesLabel.frame;
    referencesLabelFrame.origin.x = rightColumnX + _referencesCountLabel.frame.size.width + 2;
    referencesLabelFrame.origin.y = countsTop;
    _referencesLabel.frame = referencesLabelFrame;
    
    CGSize photosCountSize = [_photosCountLabel.text sizeWithFont:_photosCountLabel.font
                                                        constrainedToSize:CGSizeMake(30, CGFLOAT_MAX)];
    _photosCountLabel.frame = CGRectMake(_referencesLabel.frame.origin.x + _referencesLabel.frame.size.width + 7, countsTop, photosCountSize.width + 6, 14);
    
}

#pragma Mark Private methods

- (UILabel *)createCountLabel {
    UILabel *countLabel = [[[UILabel alloc] init] autorelease];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:11.5];
    countLabel.shadowOffset = CGSizeMake(0, 1);
    countLabel.textColor = [UIColor whiteColor];
    countLabel.backgroundColor = [UIColor grayColor];
    countLabel.textAlignment = UITextAlignmentCenter;
    countLabel.layer.cornerRadius = 6;
    
    return countLabel;
    
}

@end
