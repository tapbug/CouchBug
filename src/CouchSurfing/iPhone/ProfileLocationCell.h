//
//  ProfileLocationCell.h
//  CouchSurfing
//
//  Created on 7/1/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProfileLocationCell : UITableViewCell {
    UILabel *_keyLabel;
	UILabel *_valueLabel;
	UILabel *_dateLabel;
}

@property (nonatomic, readonly) UILabel *keyLabel;
@property (nonatomic, readonly) UILabel *valueLabel;
@property (nonatomic, readonly) UILabel *dateLabel;

- (void)makeLayout;

@end
