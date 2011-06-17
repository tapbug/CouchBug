//
//  CouchSearchRequest.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchRequest.h"
#import "CouchSurfer.h"

#import "TouchXML.h"
#import "JSONKit.h"
#import "RegexKitLite.h"

#import "iconv.h"

@interface CouchSearchRequest ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)parameter:(NSString *)parameter value:(NSString *)value key:(NSString *)key;
- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value;

- (NSData *)cleanUTF8:(NSData *)data;

@end


@implementation CouchSearchRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;
@synthesize data = _data;

@synthesize page = _page;
@synthesize location = _location;
@synthesize mapEdges = _mapEdges;
@synthesize couchStatuses = _couchStatuses;
@synthesize ageLow = _ageLow;
@synthesize ageHigh = _ageHigh;
@synthesize maxSurfers = _maxSurfers;
@synthesize languageId = _languageId;
@synthesize lastLoginDays = _lastLoginDays;
@synthesize male = _male;
@synthesize female = _female;
@synthesize severalPeople = _severalPeople;
@synthesize hasPhoto = _hasPhoto;
@synthesize wheelchairAccessible = _wheelchairAccessible;
@synthesize username = _username;
@synthesize keyword = _keyword;

- (void)send {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.couchsurfing.org/search/get_results"]];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSMutableString *bodyString = [NSMutableString string];
    
    [bodyString appendString:[self parameter:@"page" value:self.page]];
    [bodyString appendString:[self parameter:@"order_by" value:@"default"]];
    [bodyString appendString:[self parameter:@"encoded_data" value:@""]];
    
    NSString *locationEncoded = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                NULL,
                                                                                (CFStringRef)self.location,
                                                                                NULL,
                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                kCFStringEncodingUTF8 );
    
    [bodyString appendString:[self parameter:@"location" value:locationEncoded]];
    [bodyString appendString:[self parameter:@"search" value:@"Search!"]];
    
    if ([self.couchStatuses count] ==0) {
        [bodyString appendString:[self parameter:@"couchstatus_all" value:@"1"]];
    } else {
        for (int i = 0; i < [self.couchStatuses count]; i++) {
            [bodyString appendString:[self parameter:@"couchstatuses"
                                               value:[self.couchStatuses objectAtIndex:i] 
                                                 key:[NSString stringWithFormat:@"%d", i]]];
        }
    }
    
    [bodyString appendString:[self parameter:@"age_low" value:self.ageLow]];
    [bodyString appendString:[self parameter:@"age_high" value:self.ageHigh]];
    [bodyString appendString:[self parameter:@"max_surfers" value:self.maxSurfers]];
    [bodyString appendString:[self parameter:@"language_id" value:self.languageId]];
    [bodyString appendString:[self parameter:@"last_login_days" value:self.lastLoginDays]];
    [bodyString appendString:[self parameter:@"male" value:self.male]];
    [bodyString appendString:[self parameter:@"female" value:self.female]];
    [bodyString appendString:[self parameter:@"several_people" value:self.severalPeople]];
    [bodyString appendString:[self parameter:@"has_photo" value:self.hasPhoto]];
    [bodyString appendString:[self parameter:@"wheelchair_accessible" value:self.wheelchairAccessible]];
    [bodyString appendString:[self parameter:@"username" value:self.username]];    
    [bodyString appendString:[self parameter:@"keyword" value:self.keyword]];
    [bodyString appendString:[self parameter:@"submitted" value:@"manual"]];
    [bodyString appendString:[self parameter:@"submit_button" value:@"submit"]];
    [bodyString appendString:[self parameter:@"search_type" value:@"user"]];
    [bodyString appendString:[self parameter:@"data_only" value:@"false"]];
    [bodyString appendString:[self parameter:@"csstandart_request" value:@"true"]];
    [bodyString appendString:[self lastParameter:@"type" value:@"html"]];
    
    //podivat se na zbytek parametru

    [urlRequest setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1 FirePHP/0.5" forHTTPHeaderField:@"User-Agent"];
    [urlRequest setValue:@"text/javascript, text/html, application/xml, text/xml, */*" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"cs,en-us;q=0.7,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    
    [urlRequest setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [urlRequest setValue:@"ISO-8859-2,utf-8;q=0.7,*;q=0.7" forHTTPHeaderField:@"Accept-Charset"];    
    [urlRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setValue:@"1.7" forHTTPHeaderField:@"X-Prototype-Version"];
    [urlRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:@"http://www.couchsurfing.org/search" forHTTPHeaderField:@"Referer"];
    [urlRequest setValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    [urlRequest setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:bodyData];
    self.connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)dealloc {
    self.connection = nil;
    self.data = nil;

    
    self.page = nil;
    self.location = nil;
    self.mapEdges = nil;
    self.couchStatuses = nil;
    self.ageLow = nil;
    self.ageHigh = nil;
    self.maxSurfers = nil;
    self.languageId = nil;
    self.lastLoginDays = nil;
    self.male = nil;
    self.female = nil;
    self.severalPeople = nil;
    self.hasPhoto = nil;
    self.wheelchairAccessible = nil;
    self.username = nil;
    self.keyword = nil;

    [super dealloc];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error;
    NSString *responseString = [[[NSString alloc] initWithData:[self cleanUTF8:self.data] encoding:NSUTF8StringEncoding] autorelease];
    NSString *responseRepairedString = [responseString stringByReplacingOccurrencesOfRegex:@"<(br|img)(.*?)/?>" withString:@"<$1$2 />"];
    NSData *responseData = [responseRepairedString dataUsingEncoding:NSUTF8StringEncoding];
    
    CXMLDocument *doc = nil;
    doc = [[CXMLDocument alloc] initWithData:responseData options:0 error:&error];
    
    NSArray *nodes = [doc nodesForXPath:@"//div[@class='mod simple profile_result_item']" error:&error];
    
    NSMutableArray *surfers = [NSMutableArray array];
    
    for (CXMLNode *node in nodes) {
        CouchSurfer *surfer = [[[CouchSurfer alloc] init] autorelease];
        NSArray *nameNodes = [node nodesForXPath:@".//span[@class='result_username']/a/text()" error:&error];
        if ([nameNodes count] > 0) {
            surfer.name = [[nameNodes objectAtIndex:0] stringValue];
        }
        
        NSArray *imageSrcNodes = [node nodesForXPath:@".//img[@class='profile_result_link_img']/@src" error:&error];
        if ([imageSrcNodes count] > 0) {
            surfer.imageSrc = [[imageSrcNodes objectAtIndex:0] stringValue];
        }
        
        NSArray *iconsInfoNodes = [node nodesForXPath:@".//div[@class='hd']/div[2]//img/@src" error:&error];
        if ([iconsInfoNodes count] > 0) {
            for (CXMLNode *srcNode in iconsInfoNodes) {
                if ([[srcNode stringValue] isEqual:@"/images/icon_couch_travel.gif"]) {
                    surfer.couchStatus = CouchSurferHasCouchTraveling;
                } else if ([[srcNode stringValue] isEqual:@"/images/icon_couch_day.gif"]) {
                    surfer.couchStatus = CouchSurferHasCouchCoffeDrink;
                } else if ([[srcNode stringValue] isEqual:@"/images/icon_couch_maybe.gif"]) {
                    surfer.couchStatus = CouchSurferHasCouchMaybe;
                } else if ([[srcNode stringValue] isEqual:@"/images/icon_couch_yes.gif"]) {
                    surfer.couchStatus = CouchSurferHasCouchYes;
                } else if ([[srcNode stringValue] isEqual:@"/images/icon_couch_no.gif"]) {
                    surfer.couchStatus = CouchSurferHasCouchNo;
                } else if ([[srcNode stringValue] isEqual:@"/images/ambassador-hands.gif"]) {
                    surfer.vouched = YES;
                } else if ([[srcNode stringValue] isEqual:@"/images/flag.png"]) {
                    surfer.ambassador = YES;
                } else if ([[srcNode stringValue] isEqual:@"/images/verification/verified-search-icon.gif"]) {
                    surfer.verified = YES;
                }
            }
        }
        
        NSArray *aboutNodes = [node nodesForXPath:@".//li/div[text()='About']/following-sibling::div[1]/text()" error:&error];
        if ([aboutNodes count] > 0) {
            surfer.about = [[[aboutNodes objectAtIndex:0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        NSArray *basicNodes = [node nodesForXPath:@".//li/div[text()='Basics']/following-sibling::div[1]/text()" error:&error];
        if ([basicNodes count] > 0) {
            surfer.basics = [[[basicNodes objectAtIndex:0] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
        NSArray *profileCountNodes = [node nodesForXPath:@".//ul[@class='profile_count']/li" error:&error];
        if ([profileCountNodes count] > 0) {
            for (CXMLNode *countNode in profileCountNodes) {
                NSString *label = [[[countNode nodeForXPath:@"./text()" error:&error] stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *count = [[countNode nodeForXPath:@"./span/text()" error:&error] stringValue];
                if ([label isEqualToString:@"References"]) {
                    surfer.referencesCount = count;
                } else if ([label isEqualToString:@"Photos"]) {
                    surfer.photosCount = count;
                } else if ([label isEqualToString:@"Reply Rate"]) {
                    surfer.replyRate = count;
                }
            }
        }
        
        [surfers addObject:surfer];
        
    }
        
    if ([self.delegate respondsToSelector:@selector(couchSearchRequest:didRecieveResult:)]) {
        [self.delegate couchSearchRequest:self didRecieveResult:surfers];
    }
    
    self.connection = nil;
    self.data = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

#pragma mark Private methods

//  Vytvori parametr pro pridani do POST body


- (NSString *)parameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@&", parameter, value];
}

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value key:(NSString *)key {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@%@%@%@=%@&", parameter, @"%5B", key, @"%5D", value];
}

- (NSString *)lastParameter:(NSString *)parameter value:(NSString *)value {
    value = value == nil ? @"" : value;
    return [NSString stringWithFormat:@"%@=%@", parameter, value];
}

- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8");
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one);
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"iconv error");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}

@end