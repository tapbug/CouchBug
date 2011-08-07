//
//  ProfileRequest.m
//  CouchSurfing
//
//  Created on 6/12/11.
//  Copyright 2011 tapbug. All rights reserved.
//

#import "HomeRequest.h"
#import "LoginInformation.h"
#import "TouchXML.h"
#import "RegexKitLite.h"
#import "NSData+UTF8.h"

@interface HomeRequest ()

@property (nonatomic, assign) id<LoginInformation> loginInformation;

@property (nonatomic, retain) MVUrlConnection *homeConnection;
@property (nonatomic, retain) LoginRequest *loginRequest;

@property (nonatomic, retain) NSMutableDictionary *profileDictionary;

@end

@implementation HomeRequest

@synthesize delegate = _delegate;
@synthesize loginInformation = _loginInformation;
@synthesize homeConnection = _homeConnection;
@synthesize loginRequest = _loginRequest;
@synthesize profileDictionary = _profileDictionary;

- (id)initWithLoginInformation:(id<LoginInformation>)loginInformation {
    self = [super init];
    if (self) {
        self.loginInformation = loginInformation;
    }
    return self;
}

- (void)dealloc {
    self.homeConnection.delegate = nil;
    self.homeConnection = nil;
    self.loginRequest.delegate = nil;
    self.loginRequest = nil;
    self.profileDictionary = nil;
    [super dealloc];
}

- (void)loadProfile {
    self.homeConnection = [[[MVUrlConnection alloc] initWithUrlString:@"http://www.couchsurfing.org/home.html?default_language=en"] autorelease];
    self.homeConnection.delegate = self;
    [self.homeConnection sendRequest];
}

#pragma mark MVUrlConnectionDelegate methods

- (void)connection:(MVUrlConnection *)connection didFinnishLoadingWithResponseData:(NSData *)responseData {
    NSDictionary *ns = [NSDictionary dictionaryWithObject:@"http://www.w3.org/1999/xhtml" forKey:@"x"];
    CXMLDocument * doc = [[CXMLDocument alloc] initWithData:[responseData dataByCleanUTF8] options:CXMLDocumentTidyHTML error:nil];
    if (connection == self.homeConnection) {
        self.profileDictionary = [NSMutableDictionary dictionary];
        CXMLNode *isNotLoggedNode = [doc nodeForXPath:@"//*[@id='auth_loginaction']" error:nil];
        if (isNotLoggedNode) {
            if (self.loginRequest == nil) {
                self.loginRequest = [[[LoginRequest alloc] init] autorelease];
                self.loginRequest.delegate = self;
                self.loginRequest.username = self.loginInformation.username;
                self.loginRequest.password = self.loginInformation.password;
                [self.loginRequest login];
            } else {
                //todo request failed (zmena api, neni spojeni ...)
            }
            return;
        }
        
        //  Zjisteni poctu CouchSurferu na webu
        NSArray *visitorsCountNodes = [doc nodesForXPath:@"//*[text()='Online Visitors']/following-sibling::*//*[number(text())=text()]/text()" error:nil];
        if ([visitorsCountNodes count] == 2) {
            NSInteger sumVisitors = [[[visitorsCountNodes objectAtIndex:0] stringValue] integerValue];
            NSInteger nonLoggedVisitors = [[[visitorsCountNodes objectAtIndex:1] stringValue] integerValue];
            NSInteger loggedVisitors = sumVisitors - nonLoggedVisitors;
            
            [self.profileDictionary setObject:[NSString stringWithFormat:@"%d", loggedVisitors] forKey:@"loggedVisitors"];            
        }        
        
        //  Zjisteni poctu visitu meho profilu a zjisteni od kdy jsem clenem
        NSArray *profilesViewNodes = [doc nodesForXPath:@"//*[text()='My Profile at a Glance']/../following-sibling::*//text()" namespaceMappings:ns error:nil];
        for (CXMLNode *profileNode in profilesViewNodes) {
            NSString *profileViewsRegex = @"^([0-9,]+) profile views since(.+?)$";
            NSString *profileString = [profileNode stringValue];
            NSString *profileViews = [profileString stringByMatching:profileViewsRegex capture:1];
            NSString *memberSince = [profileString stringByMatching:profileViewsRegex capture:2];
            if (profileViews != nil) {
                [self.profileDictionary setObject:profileViews forKey:@"profileViews"];
            }
            if (memberSince != nil) {
                [self.profileDictionary setObject:memberSince forKey:@"memberSince"];
            }
            
            //2 Pending Friend Request
            NSString *pendingFriendsString = [profileNode stringValue];
            NSString *pendingFriends = [pendingFriendsString stringByMatching:@"([0-9]+) Pending Friend" capture:1];
            if (pendingFriends != nil) {
                [self.profileDictionary setObject:pendingFriends forKey:@"pendingFriends"];
            }
        }
        
        NSArray *bubbleNodes = [doc nodesForXPath:@"//*[@class='item_bubble']" namespaceMappings:ns error:nil];
        for (CXMLNode *bubbleNode in bubbleNodes) {
            NSString *href = [[[bubbleNode nodesForXPath:@".//x:a/@href" namespaceMappings:ns error:nil] lastObject] stringValue];
            NSString *value = [[[bubbleNode nodesForXPath:@".//x:a/text()" namespaceMappings:ns error:nil] lastObject] stringValue];
            if ([href stringByMatching:@"messages"] != nil) {
                [self.profileDictionary setObject:value forKey:@"messagesCount"];
            } else if([href stringByMatching:@"couchmanager"] != nil) {
                [self.profileDictionary setObject:value forKey:@"couchRequestCount"];
            }
        }
		
		//	Avatar obrazek a Jmeno a Prijmeni
		NSString *personalImgNodeQuery = [NSString stringWithFormat:@"//x:a[contains(@href, '/people/%@')][contains(@class, 'profile-image')]/x:img", self.loginInformation.username];
        CXMLNode *personalImgNode = [[doc nodesForXPath:personalImgNodeQuery namespaceMappings:ns error:nil] lastObject];
        NSString *avatarUrl = [[[personalImgNode nodeForXPath:@"./@src" error:nil] stringValue] stringByReplacingOccurrencesOfString:@"_t_" withString:@"_m_"];
        NSString *name = [[personalImgNode nodeForXPath:@"./@alt" error:nil] stringValue];
        
        if (avatarUrl != nil) {
            [self.profileDictionary setObject:avatarUrl forKey:@"avatar"];            
        }
        
        if (name != nil) {
            [self.profileDictionary setObject:name forKey:@"name"];            
        }
        
        if ([self.delegate respondsToSelector:@selector(profileRequest:didLoadProfile:)]) {
            [self.delegate profileRequest:self didLoadProfile:self.profileDictionary];
            self.profileDictionary = nil;
        }
    }
	
	[doc release]; doc = nil;
}

#pragma Mark LoginRequestDelegate

- (void)loginRequestDidFinnishLogin:(LoginRequest *)request {
    [self loadProfile];
}

- (void)loginRequestDidFail:(LoginRequest *)request {
    if ([self.delegate respondsToSelector:@selector(profileRequestFailedToLogin:)]) {
        [self.delegate profileRequestFailedToLogin:self];
    }
}

@end
