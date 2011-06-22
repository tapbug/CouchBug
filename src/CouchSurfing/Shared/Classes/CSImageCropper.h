//
//  CSImageCrop.h
//  CouchSurfing
//
//  Created by Michal Vašíček on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSImageCropper : NSObject {
    
}

+ (UIImage*)scaleToSize:(CGSize)targetSize image:(UIImage *)sourceImage;

@end
