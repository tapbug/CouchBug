//
//  XPathFinder.m
//  XPathFinder
//
//  Created by Yves Vogl on 25.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "XPathFinder.h"


@implementation XPathFinder

-(id)initWithData:(NSData *)anXMLDocument {
	
	self = [self init];
	
	if (self != nil) {
		
		// Read XML string into memory
		XMLDocument = htmlReadMemory([anXMLDocument bytes], [anXMLDocument length], "", NULL, XML_PARSE_RECOVER);
		
		if (XMLDocument == NULL) {
			return nil;
		}		
		
		// Create XPath context
		XPathContext = xmlXPathNewContext(XMLDocument);		
		
		if (XPathContext == NULL) {
			return nil;
		}
	}
	
	return self;
}

-(void)dealloc {
	xmlFreeDoc(XMLDocument); 
	xmlXPathFreeContext(XPathContext); 
	[super dealloc];	
}

/*
 * Count nodes matchting the given XPath expression
 */
-(NSUInteger)numberOfNodesForXPath:(NSString *)path {
	
	NSUInteger numberOfMatchingNodes = 0;
	
	// Evaluate XPath path expression
	xmlXPathObjectPtr XPathObject = xmlXPathEvalExpression((xmlChar *)[path cStringUsingEncoding:NSUTF8StringEncoding], XPathContext);	
	
	if (XPathObject == NULL) {
		return numberOfMatchingNodes;
	}
	
	// Get array of pointers to the nodes that matched the XPath statement above
	xmlNodeSetPtr nodeSet = XPathObject->nodesetval;	
			
	if (xmlXPathNodeSetIsEmpty(nodeSet)) {
		xmlXPathFreeObject(XPathObject);
		return numberOfMatchingNodes;
	}
	
	numberOfMatchingNodes = XPathObject->nodesetval->nodeNr;
	
	xmlXPathFreeObject(XPathObject);

	
	return numberOfMatchingNodes;
}

/*
 * Get the value of the first node matching the given XPath expression
 */
-(NSString *)nodeValueForXPath:(NSString *)path {
	
	// Evaluate XPath path expression
	xmlXPathObjectPtr XPathObject = xmlXPathEvalExpression((xmlChar *)[path cStringUsingEncoding:NSUTF8StringEncoding], XPathContext);	
	
	if (XPathObject == NULL) {
		return nil;
	}
	
	// Get array of pointers to the nodes that matched the XPath statement above
	xmlNodeSetPtr nodeSet = XPathObject->nodesetval;	
	
	if (xmlXPathNodeSetIsEmpty(nodeSet)) {
		xmlXPathFreeObject(XPathObject);
		return nil;
	}
	
	
	// Get the first result 
	xmlNodePtr currentXMLNode;
	currentXMLNode = XPathObject->nodesetval->nodeTab[0];
	xmlXPathFreeObject(XPathObject);
	
	xmlChar *xmlNodeValue;
	
	// Relevant content within the node…
	if (currentXMLNode->type == XML_TEXT_NODE || currentXMLNode->type == XML_CDATA_SECTION_NODE) { 
		// Get the content
		xmlNodeValue = currentXMLNode->content;
		// Node contains attributes or is an element node
	} else { 
		// Get all information as TEXT / ENTITY_REFs
		xmlNodeValue = xmlNodeListGetString(currentXMLNode->doc, currentXMLNode->children, YES);
	}
		
	NSString *result = NULL;
	
	if (xmlNodeValue != NULL) {
		// Create an autoreleased NSString instance from xmlChar
		result = [NSString stringWithUTF8String:(const char *)xmlNodeValue];
	}
	xmlFree(xmlNodeValue);

	return result;	
}

@end
