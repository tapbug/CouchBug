//
//  CouchSearchRequest.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchRequest.h"
#import "XpathFinder.h"
#import "CouchSourfer.h"

NSString * const CouchSearchRequestHasCouchYes = @"Y";
NSString * const CouchSearchRequestHasCouchDefinitely = @"D";
NSString * const CouchSearchRequestHasCouchMaybe = @"M";
NSString * const CouchSearchRequestHasCouchCoffeeMaybe = @"CM";
NSString * const CouchSearchRequestHasCouchCoffeDrink = @"C";
NSString * const CouchSearchRequestHasCouchNo = @"N";
NSString * const CouchSearchRequestHasCouchTraveling = @"T";

static NSString * const xpathBaseFormat = @"/html/body/div[2]/div/table/tr/td/table[2]/tr%@/td/table/tr";

@interface CouchSearchRequest ()

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *data;

- (NSString *)parameter:(NSString *)parameter value:(NSString *)value;
- (NSString *)sourfersCountQuery;
- (NSString *)sourfersValueQueryFor:(NSString *)append position:(NSInteger)position;

@end


@implementation CouchSearchRequest

@synthesize delegate = _delegate;
@synthesize connection = _connection;
@synthesize data = _data;
@synthesize hasCouch = _hasCouch;
@synthesize maxSurfers = _maxSurfers;
@synthesize keyword = _keyword;
@synthesize keywordOrAnd = _keywordOrAnd;
@synthesize cityCountry = _cityCountry;
@synthesize regionId = _regionId;
@synthesize countryId = _countryId;
@synthesize stateId = _stateId;
@synthesize cityId = _cityId;
@synthesize radius = _radius;
@synthesize radiusType = _radiusType;    


- (void)send {
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.couchsurfing.org/mapsurf.html?SEARCH[skip]=25&SEARCH[show]=25"]];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSMutableString *bodyString = [NSMutableString string];
    
    [bodyString appendString:[self parameter:@"has_couch" value:self.hasCouch]];
    [bodyString appendString:[self parameter:@"max_surfers" value:self.maxSurfers]];
    [bodyString appendString:[self parameter:@"keyword" value:self.keyword]];
    [bodyString appendString:[self parameter:@"keyword_search_or_and" value:self.keywordOrAnd]];
    [bodyString appendString:[self parameter:@"city_country" value:self.cityCountry]];
    [bodyString appendString:[self parameter:@"region_id" value:self.regionId]];
    [bodyString appendString:[self parameter:@"country_id" value:self.countryId]];
    [bodyString appendString:[self parameter:@"state_id" value:self.stateId]];
    [bodyString appendString:[self parameter:@"city_id" value:self.cityId]];
    [bodyString appendString:[self parameter:@"radius" value:self.radius]];
    [bodyString appendString:[self parameter:@"radius_type" value:self.radiusType]];

    [bodyString appendString:[self parameter:@"skip" value:@"25"]];
    [bodyString appendString:[self parameter:@"show" value:@"5"]];    
    
    [bodyString appendString:[self parameter:@"action" value:@"List surfers on next page..."]];
    [bodyString appendString:@"form=basic"];
        
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:bodyData];
    self.connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)dealloc {
    self.connection = nil;
    self.data = nil;
    self.hasCouch = nil;
    self.maxSurfers = nil;
    self.keyword = nil;
    self.keywordOrAnd = nil;
    self.cityCountry = nil;
    self.regionId = nil;
    self.countryId = nil;
    self.stateId = nil;
    self.cityId = nil;
    self.radius = nil;
    self.radiusType = nil;
    [super dealloc];
}

#pragma mark NSURLConnectionDelegate methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *xpathNameAppend = @"/td[2]/b/font/a";
    NSString *xpathImageAppend = @"/td[1]/a/img/@src";    
    
    XPathFinder *xpathFinder = [[[XPathFinder alloc] initWithData:self.data] autorelease];
    NSInteger sourfersCount = [xpathFinder numberOfNodesForXPath:[self sourfersCountQuery]];
    
    NSMutableArray *sourfers = [NSMutableArray arrayWithCapacity:sourfersCount];
    for (int i = 1; i <= sourfersCount; i++) {
        NSString *name = [xpathFinder nodeValueForXPath:[self sourfersValueQueryFor:xpathNameAppend position:i]];
        NSString *imageSrc = [xpathFinder nodeValueForXPath:[self sourfersValueQueryFor:xpathImageAppend position:i]];
        
        CouchSourfer *sourfer = [[[CouchSourfer alloc] init] autorelease];
        sourfer.name = name;
        sourfer.imageSrc = [imageSrc stringByReplacingOccurrencesOfString:@"_t_" withString:@"_m_"];
        [sourfers addObject:sourfer];
    }
    
    if ([self.delegate respondsToSelector:@selector(couchSearchRequest:didRecieveResult:)]) {
        [self.delegate couchSearchRequest:self didRecieveResult:sourfers];
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
    return [NSString stringWithFormat:@"SEARCH%@%@%@=%@&", @"%5B",parameter, @"%5D", value];
}

//  Vrati dotaz na pocet uzivatelu
- (NSString *)sourfersCountQuery {
    return [NSString stringWithFormat:xpathBaseFormat, @""];
}

//  Vrati dotaz na jakoukoliv hodnotu uzivatele zadanou poddotazem ve stringu append
- (NSString *)sourfersValueQueryFor:(NSString *)append position:(NSInteger)position{
    return [[NSString stringWithFormat:xpathBaseFormat, [NSString stringWithFormat:@"[%i]", position]] stringByAppendingString:append];
}

@end