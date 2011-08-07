//
//  CouchSearchResultCell.h
//  CouchSurfing
//
//  Created on 6/15/11.
//  Copyright 2011 tapbug. All rights reserved.
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
    UIImageView *_hasCouchView;
    UIImageView *_vouchedView;
    UIImageView *_ambassadorView;
    
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
@property (nonatomic, readonly) UIImageView *hasCouchView;
@property (nonatomic, readonly) UIImageView *vouchedView;
@property (nonatomic, readonly) UIImageView *ambassadorView;

- (void)makeLayout;
- (void)resetCell;

@end
