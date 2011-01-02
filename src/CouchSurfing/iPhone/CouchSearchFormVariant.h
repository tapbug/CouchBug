//
//  CouchSearchFormVariant.h
//  CouchSourfing
//
//  Created by Michal Vašíček on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// Varianta vyhledavaciho formulare
//

@protocol CouchSearchFormVariant

- (NSString *)name;

- (NSIndexSet *)sectionsToInsertFrom:(id<CouchSearchFormVariant>)fromVariant;
- (NSIndexSet *)sectionsToRemoveFrom:(id<CouchSearchFormVariant>)fromVariant;
- (NSArray *)rowsToInsertFrom:(id<CouchSearchFormVariant>)fromVariant;
- (NSArray *)rowsToRemoveFrom:(id<CouchSearchFormVariant>)fromVariant;


- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)createCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
