//
//  AdBannerViewOverlap.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdBannerViewOverlap.h"

@interface AdBannerViewOverlap ()

- (void)showWithAnimation;
- (void)hideWithAnimation;
- (void)setHidden;
- (void)setShown;
- (void)adHiddenCauseOfRotation:(NSString *)animationID 
					   finished:(NSNumber *)finished
						context:(void *)context;

@end

@implementation AdBannerViewOverlap

@synthesize adBannerView = _adBannerView;

- (id)initWithContentView:(UIView *)contentView
{
	if ((self = [super init])) {
		_contentView = contentView;
		_ownerView = [_contentView superview];
		
		_adBannerView = [[[ADBannerView alloc] init] autorelease];
		_adBannerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
		_adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:
														ADBannerContentSizeIdentifierPortrait,
														ADBannerContentSizeIdentifierLandscape,
														nil];
		[_ownerView addSubview:_adBannerView];
		
		[self setHidden];

	}
	
	return self;
}

- (void)setAdLoaded:(BOOL)loaded
{
	if (_adLoaded == NO && loaded == YES) {
		[self showWithAnimation];
	} else if (_adLoaded == YES && loaded == NO){
		[self hideWithAnimation];
	}
	_adLoaded = loaded;
}

- (BOOL)adLoaded
{
	return _adLoaded;
}

- (void)setCurrentContentSize
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (UIInterfaceOrientationIsPortrait(orientation)) {
		_adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	} else {
		_adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	}
}

- (void)willRotateAnimation:(UIInterfaceOrientation)toInterfaceOrientation
				   duration:(NSTimeInterval)duration;
{
	if (_adLoaded) {
		[UIView beginAnimations:@"hideBanner" context:[NSNumber numberWithInt:toInterfaceOrientation]];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDuration:duration];
		[UIView setAnimationDidStopSelector:@selector(adHiddenCauseOfRotation:finished:context:)];
		[self setHidden];
		[UIView commitAnimations];
	}
}

- (void)didRotateAnimation
{
	if (_adLoaded) {
		[self showWithAnimation];		
	}
}

#pragma Mark Private methods

- (void)showWithAnimation
{
	[UIView beginAnimations:@"showBanner" context:nil];
	[self setShown];
	[UIView commitAnimations];
}

- (void)hideWithAnimation
{
	[UIView beginAnimations:@"hideBanner" context:nil];
	[self setHidden];
	[UIView commitAnimations];
}

- (void)setHidden
{
	CGRect contentViewFrame = _contentView.frame;
	contentViewFrame.size.height = _ownerView.frame.size.height;
	_contentView.frame = contentViewFrame;
	
	CGRect bannerFrame = _adBannerView.frame;
	bannerFrame.origin.y = _ownerView.frame.size.height;
	_adBannerView.frame = bannerFrame;
}

- (void)setShown
{
	CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:_adBannerView.currentContentSizeIdentifier];
	CGRect contentViewFrame = _contentView.frame;
	contentViewFrame.size.height = _ownerView.frame.size.height - bannerSize.height;
	_contentView.frame = contentViewFrame;
	
	CGRect bannerFrame = _adBannerView.frame;
	bannerFrame.origin.y = _ownerView.frame.size.height - bannerSize.height;
	_adBannerView.frame = bannerFrame;
}

- (void)adHiddenCauseOfRotation:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	UIInterfaceOrientation toOrientation = (UIInterfaceOrientation)([(NSNumber *)context intValue]);
	
	if (UIInterfaceOrientationIsPortrait(toOrientation)) {
		_adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	} else {
		_adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	}	
}

@end
