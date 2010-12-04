//
//  ImageDownloader.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSImageDownloaderDelegate;

@interface CSImageDownloader : NSObject {
    id<CSImageDownloaderDelegate> _delegate;
    NSMutableData *_data;
    NSURLConnection *_connection;
    NSInteger _position;
}

@property (nonatomic, assign) id<CSImageDownloaderDelegate> delegate;

- (void)downloadWithSrc:(NSString *)src position:(NSInteger)position;

@end

@protocol CSImageDownloaderDelegate <NSObject>

- (void)imageDownloader:(CSImageDownloader *)imageDownloader didDownloadImage:(UIImage *)image forPosition:(NSInteger)position;

@end