//
//  CouchSourfer.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CouchSourfer : NSObject {
    NSString *_name;
    NSString *_imageSrc;
    UIImage *_image;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageSrc;
@property (nonatomic, retain) UIImage *image;

@end
