//
//  ImageDownloader.h
//  CouchSurfing
//
//  Created on 11/7/10.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSImageDownloaderDelegate;

@interface CSImageDownloader : NSObject {
    CGSize _sizeToScale;
    
    id<CSImageDownloaderDelegate> _delegate;
    NSMutableData *_data;
    NSURLConnection *_connection;
    NSInteger _position;
}

@property (nonatomic, assign) id<CSImageDownloaderDelegate> delegate;

- (void)downloadWithSrc:(NSString *)src position:(NSInteger)position;

@end

@protocol CSImageDownloaderDelegate <NSObject>

- (void)imageDownloader:(CSImageDownloader *)imageDownloader
	   didDownloadImage:(UIImage *)image
			forPosition:(NSInteger)position;

@end