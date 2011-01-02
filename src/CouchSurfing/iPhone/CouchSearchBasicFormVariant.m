//
//  CouchSearchBasicFormVariant.m
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CouchSearchBasicFormVariant.h"

@interface CouchSearchBasicFormVariant ()

@property (nonatomic, retain) NSArray *items;

@end


@implementation CouchSearchBasicFormVariant

@synthesize items = _items;

- (id)init {
    if (self = [super init]) {
        self.items = [NSArray arrayWithObjects:
                      NSLocalizedString(@"Has Couch?", @"form label"),
                      NSLocalizedString(@" Allowing at least", @"form label"),
                      NSLocalizedString(@"Keywords", @"form label"),
                      NSLocalizedString(@"Location text", @"form label"),
                      NSLocalizedString(@"Location", @"form label"),
                      NSLocalizedString(@"In the region", @"form label"),
                      NSLocalizedString(@"Exclude the selected city from the search", @"form label"),
                      nil
                      ];
    }
    
    return self;
}

- (void)dealloc {
    self.items = nil;
    [super dealloc];
}

- (NSString *)name {
    return  NSLocalizedString(@"Basic", @"Basic search form variant");
}

- (NSIndexSet *)sectionsToInsertFrom:(id <CouchSearchFormVariant>)fromVariant {
    return nil;
}

- (NSIndexSet *)sectionsToRemoveFrom:(id <CouchSearchFormVariant>)fromVariant {
    return nil;
}

- (NSArray *)rowsToInsertFrom:(id <CouchSearchFormVariant>)fromVariant {
    return nil;
}

- (NSArray *)rowsToRemoveFrom:(id <CouchSearchFormVariant>)fromVariant {
    if ([[fromVariant name] isEqualToString:@"Advanced"]) {
        return [NSArray arrayWithObjects:
                [NSIndexPath indexPathForRow:2 inSection:0],
                [NSIndexPath indexPathForRow:3 inSection:0],
                [NSIndexPath indexPathForRow:4 inSection:0],
                [NSIndexPath indexPathForRow:5 inSection:0],
                [NSIndexPath indexPathForRow:6 inSection:0],
                [NSIndexPath indexPathForRow:8 inSection:0],
                [NSIndexPath indexPathForRow:9 inSection:0],
                [NSIndexPath indexPathForRow:10 inSection:0],
                [NSIndexPath indexPathForRow:11 inSection:0],
                [NSIndexPath indexPathForRow:12 inSection:0],
                [NSIndexPath indexPathForRow:13 inSection:0],
                [NSIndexPath indexPathForRow:14 inSection:0],
                [NSIndexPath indexPathForRow:15 inSection:0],
                nil
                ];
    }
    return nil;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)createCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
}

@end
