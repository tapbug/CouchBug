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
    UILabel *_nameLabel;
    UILabel *_basicsLabel;
    UILabel *_aboutLabel;
    UILabel *_referencesCountLabel;
    UILabel *_photosCountLabel;
    
    UIImageView *_photoFrameView;
    UILabel *_referencesLabel;
    UILabel *_photosLabel;
}

@property (nonatomic, readonly) UIImageView *photoView;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *basicsLabel;
@property (nonatomic, readonly) UILabel *aboutLabel;
@property (nonatomic, readonly) UILabel *referencesCountLabel;
@property (nonatomic, readonly) UILabel *photosCountLabel;

- (void)makeLayout;

@end
