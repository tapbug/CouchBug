//
//  CouchSearchResultCell.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CouchSearchResultCell : UITableViewCell {
    UIImageView *_photoView;
    UIImageView *_verifiedImageView;
    UILabel *_nameLabel;
    UILabel *_basicsLabel;
    UILabel *_aboutLabel;
    UILabel *_referencesCountLabel;
    UILabel *_photosCountLabel;
    UILabel *_replyRateCountLabel;
    
    UIImageView *_photoFrameView;
    UILabel *_referencesLabel;
    UILabel *_photosLabel;
    UILabel *_replyRateLabel;
    
    UIImage *_nonePhotoImage;
}

@property (nonatomic, readonly) UIImageView *photoView;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *basicsLabel;
@property (nonatomic, readonly) UILabel *aboutLabel;
@property (nonatomic, readonly) UILabel *referencesCountLabel;
@property (nonatomic, readonly) UILabel *photosCountLabel;
@property (nonatomic, readonly) UILabel *replyRateCountLabel;
@property (nonatomic, readonly) UIImageView *verifiedImageView;

- (void)makeLayout;
- (void)resetCell;

@end
