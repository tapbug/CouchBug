//
//  ImageDownloader.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CSImageDownloader.h"

@interface CSImageDownloader ()

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURLConnection *connection;

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage *)image;

@end


@implementation CSImageDownloader

@synthesize delegate = _delegate;
@synthesize data = _data;
@synthesize connection = _connection;

- (id)init {
    if ((self = [super init])) {
        _sizeToScale = CGSizeMake(61, 61);
    }
    return self;
}

- (id)initWithSize:(CGSize)size {
    if ((self = [super init])) {
        _sizeToScale = size;
    }
    
    return self;
}

- (void)downloadWithSrc:(NSString *)src position:(NSInteger)position {
    _position = position;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    self.connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIImage *image = [self scaleToSize:_sizeToScale image:[UIImage imageWithData:self.data]];
    
    if ([self.delegate respondsToSelector:@selector(imageDownloader:didDownloadImage:forPosition:)]) {
        [self.delegate imageDownloader:self didDownloadImage:image forPosition:_position];
    }
    self.data = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

}

- (void)dealloc {
    self.data = nil;
    self.connection = nil;
    [super dealloc];
}

#pragma mark Private methods

- (UIImage*)scaleToSize:(CGSize)targetSize image:(UIImage *)sourceImage {
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO)	{
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if (widthFactor > heightFactor)
			scaleFactor = widthFactor; // scale to fit height
        else
			scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else {
			if (widthFactor < heightFactor) {
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
			}
		}
	}
	
	UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0); // this will crop
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
    return resultImage;
}


@end
