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
    UIImage *image = [UIImage imageWithData:self.data];
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

@end
