//
//  AdBannerViewOverlap.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface AdBannerViewOverlap : NSObject <ADBannerViewDelegate>
{
	UIView *_ownerView;
	UIView *_contentView;
	
	ADBannerView *_adBannerView;
	
	BOOL _adLoaded;
}

@property (nonatomic, readonly) ADBannerView *adBannerView;
@property (nonatomic, assign) BOOL adLoaded;

- (id)initWithContentView:(UIView *)contentView;

- (void)setCurrentContentSize;

- (void)willRotateAnimation:(UIInterfaceOrientation)toInterfaceOrientation 
				   duration:(NSTimeInterval)duration;

- (void)didRotateAnimation;

@end
