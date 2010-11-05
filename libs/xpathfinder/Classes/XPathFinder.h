//
//  XPathFinder.h
//  XPathFinder
//
//  Created by Yves Vogl on 25.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <libxml/parser.h>
#import <libxml/HTMLparser.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>


@interface XPathFinder : NSObject {	
	xmlDocPtr XMLDocument;	
	xmlXPathContextPtr XPathContext;
}


-(id)initWithData:(NSData *)anXMLDocument;

/*
 * Counts nodes which match the given XPath expression
 */
-(NSUInteger)numberOfNodesForXPath:(NSString *)path;

/*
 * Returns the value of the first node which matches the given XPath expression
 */
-(NSString *)nodeValueForXPath:(NSString *)path;

@end
