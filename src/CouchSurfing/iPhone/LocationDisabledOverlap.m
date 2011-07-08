//
//  LocationDisabledOverlap.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationDisabledOverlap.h"
#import "CSTools.h"

@interface LocationDisabledOverlap ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@end

@implementation LocationDisabledOverlap
@synthesize title = _title;
@synthesize body = _body;

- (id)initWithView:(UIView *)view title:(NSString *)title body:(NSString *)body{
    if ((self = [super init])) {
        _view = view;
        self.title = title;
		self.body = body;
    }
    return self;
}

- (void)dealloc {
    _overlapView = nil;
    self.title = nil;
	self.body = nil;
    [super dealloc];
}

- (void)overlapView {
	if (_active == NO) {
		_overlapView = [[[UIView alloc] init] autorelease];
		_overlapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_overlapView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		
		UIView *containerView = [[[UIView alloc] init] autorelease];
		containerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
		_titleLabel = [[[UILabel alloc] init] autorelease];
		_titleLabel.font = [UIFont boldSystemFontOfSize:16];
		_titleLabel.text = self.title;
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.textColor = [UIColor whiteColor];
		[_titleLabel sizeToFit];
		[containerView addSubview:_titleLabel];
		
		_bodyLabel = [[[UILabel alloc] init] autorelease];
		_bodyLabel.font = [UIFont systemFontOfSize:15];
		_bodyLabel.text = self.body;
		_bodyLabel.frame = CGRectMake(0, 0, _view.frame.size.width - 20, 0);
		_bodyLabel.numberOfLines = 0;
		_bodyLabel.backgroundColor = [UIColor clearColor];
		_bodyLabel.textColor = [UIColor whiteColor];
		[_bodyLabel sizeToFit];
		[containerView addSubview:_bodyLabel];		
				
		_overlapView.frame = CGRectMake(0, 0, _view.frame.size.width, _view.frame.size.height);

		CGRect titleLabelFrame = _titleLabel.frame;
		_titleLabel.frame = titleLabelFrame;
				
		CGFloat containerWidth = MAX(titleLabelFrame.size.width, _bodyLabel.frame.size.width);
		CGFloat containerHeight = titleLabelFrame.size.height + _bodyLabel.frame.size.height + 10;
		
		containerView.frame = CGRectMake((int)(_view.frame.size.width - containerWidth) / 2,
										 (int)(_view.frame.size.height - containerHeight) / 2,
										 containerWidth, 
										 containerHeight);

		CGRect bodyLabelFrame = _bodyLabel.frame;
		bodyLabelFrame.origin.y = titleLabelFrame.size.height + titleLabelFrame.origin.y + 10;
		bodyLabelFrame.origin.x = (containerView.frame.size.width - bodyLabelFrame.size.width) / 2;
		_bodyLabel.frame = bodyLabelFrame;

		
		[_overlapView addSubview:containerView];
		[_view addSubview:_overlapView];
	}
	
	_active = YES;
}

- (void)removeOverlap {
	if (_active) {
		[_overlapView removeFromSuperview];		
	}
	_active = NO;
}

@end
