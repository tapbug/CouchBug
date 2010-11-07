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
    
    UIImage *image = [self scaleToSize:CGSizeMake(50, 50) image:[UIImage imageWithData:self.data]];
    
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

- (UIImage*)scaleToSize:(CGSize)maxSize image:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    
    size_t originalWidth = CGImageGetWidth(cgImage);
    size_t originalHeight = CGImageGetHeight(cgImage);
    
    CGFloat widthRatio = maxSize.width / originalWidth;
    CGFloat heightRatio = maxSize.height / originalHeight;
    
    CGFloat newWidth;
    CGFloat newHeight;
    
    if (widthRatio < 1) {
        newWidth = originalWidth * widthRatio;
        newHeight = originalHeight * widthRatio;
        
        CGFloat newHeightRatio = maxSize.height / newHeight;
        
        if (newHeightRatio < 1) {
            newWidth *= newHeightRatio;
            newHeight *= newHeightRatio;
        }
    } else if (heightRatio < 1) {
        newWidth = originalWidth * heightRatio;
        newHeight = originalHeight * heightRatio;
        
        CGFloat newWidthRatio = maxSize.width / newWidth;
        
        if (newWidth < 1) {
            newWidth *= newWidthRatio;
            newHeight *= newWidthRatio;
        }
    } else {
        newWidth = originalWidth;
        newHeight = originalHeight;
    }

    CGSize size = CGSizeMake(newWidth, newHeight);
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}


@end
