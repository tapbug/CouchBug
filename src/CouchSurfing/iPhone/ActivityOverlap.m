//
//  ActivityOverlap.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActivityOverlap.h"

@interface ActivityOverlap ()

@property (nonatomic, copy) NSString *title;

@end

@implementation ActivityOverlap

@synthesize title = _title;

- (id)initWithView:(UIView *)view title:(NSString *)title{
    if ((self = [super init])) {
        _view = view;
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    _activityView = nil;
    self.title = nil;
    [super dealloc];
}

- (void)overlapView {
    _activityView = [[[UIView alloc] init] autorelease];
    _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _activityView.backgroundColor = [UIColor whiteColor];
    
    _activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
    _activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_activityView addSubview:_activityIndicator];
    
    _activityLabel = [[[UILabel alloc] init] autorelease];
    _activityLabel.text = self.title;
    _activityLabel.backgroundColor = [UIColor whiteColor];
    _activityLabel.textColor = [UIColor grayColor];
    [_activityLabel sizeToFit];
    _activityLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_activityView addSubview:_activityLabel];
    
    _activityView.frame = CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);
    CGRect activityIndicatorFrame = _activityIndicator.frame;
    CGRect activityLabelFrame = _activityLabel.frame;
    activityIndicatorFrame.origin.x = (int)((_activityView.frame.size.width - activityIndicatorFrame.size.width) / 2);
    activityIndicatorFrame.origin.y = (int)((_activityView.frame.size.height - activityIndicatorFrame.size.height - 3 - activityLabelFrame.size.height) / 2);
    activityLabelFrame.origin.x = (int)((_activityView.frame.size.width - activityLabelFrame.size.width) / 2);
    activityLabelFrame.origin.y = (int)((_activityView.frame.size.height - activityLabelFrame.size.height) / 2 + activityIndicatorFrame.size.height - 3);
    _activityIndicator.frame = activityIndicatorFrame;
    _activityLabel.frame = activityLabelFrame;
    
    [_view addSubview:_activityView];
    [_activityIndicator startAnimating];
}

- (void)removeOverlap {
    [_activityIndicator stopAnimating];
    [_view removeFromSuperview];
}

@end
