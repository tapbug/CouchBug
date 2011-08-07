//
//  CSImageCrop.h
//  CouchSurfing
//
//  Created on 6/22/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSImageCropper : NSObject {
    
}

+ (UIImage*)scaleToSize:(CGSize)targetSize image:(UIImage *)sourceImage;

@end
