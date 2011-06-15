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
}

@property (nonatomic, readonly) UIImageView *photoView;
@property (nonatomic, readonly) UILabel *nameLabel;

@end
