//
//  NSData+UTF8.m
//  CouchSurfing
//
//  Created by Michal Vašíček on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSData+UTF8.h"
#import "iconv.h"

@implementation NSData (NSData_UTF8)
- (NSData *)dataByCleanUTF8 {
	iconv_t cd = iconv_open("UTF-8", "UTF-8");
	int one = 1;
	iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one);
	
	size_t inbytesleft, outbytesleft;
	inbytesleft = outbytesleft = self.length;
	char *inbuf  = (char *)self.bytes;
	char *outbuf = malloc(sizeof(char) * self.length);
	char *outptr = outbuf;
	if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
		== (size_t)-1) {
		NSLog(@"iconv error");
		return nil;
	}
	NSData *result = [NSData dataWithBytes:outbuf length:self.length - outbytesleft];
	iconv_close(cd);
	free(outbuf);
	return result;
}

@end
