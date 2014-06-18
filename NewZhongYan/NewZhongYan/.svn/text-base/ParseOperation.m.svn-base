//
//  ParseOperation.m
//  ZhongYan
//
//  Created by linlin on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ParseOperation.h"
#import "utils.h"
#import "GDataXMLNode.h"
static NSString *kColumnsStr                = @"columns";
static NSString *kColumnStr                 = @"column";
static NSString *kElementStr                = @"element";
static NSString *kReturncodeStr             = @"returncode";
static NSString *kFlowinstanceidStr         = @"flowinstanceid";
static NSString *kStepStr                   = @"step";
static NSString *kFunctionStr               = @"function";

@interface ParseOperation ()
@property (nonatomic, copy) ArrayBlock completionHandler;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, retain) business*aBusiness;
@property (nonatomic, retain) columns *cs;
@property (nonatomic, retain) column  *c;
@property (nonatomic, retain) element *e;
@end


@implementation ParseOperation
@synthesize completionHandler,errorHandler,dataToParse,workingPropertyString,elementsToParse,aBusiness,cs,c,e;
- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler
{
    self = [super init];
    if (self)
    {
        self.dataToParse = data;
        self.completionHandler = handler;
        self.elementsToParse = [NSArray arrayWithObjects:kColumnsStr, kColumnStr, kElementStr, kReturncodeStr,kFlowinstanceidStr,kFunctionStr,kStepStr,nil];
        GDataXMLDocument* doc1 = [[[GDataXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding error:0] autorelease];
        doc = [[DDXMLDocument alloc] initWithData:[doc1 XMLData] options:0 error:0];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [completionHandler release];
    [errorHandler release];
    [dataToParse release];
    [cs release];
    [workingPropertyString release];
    [elementsToParse release];
    [c release];
    [e release];
    [doc release];
    [aBusiness release];
    [super dealloc];
}

// -------------------------------------------------------------------------------
//	main:
//  Given data to parse, use NSXMLParser and process all the top paid apps.
// -------------------------------------------------------------------------------
- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	aBusiness = [[business alloc] init];
    aBusiness.xmlNodes = [doc nodesForXPath:@"//columns" error:nil];
    self.workingPropertyString = [NSMutableString string];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
	[parser setDelegate:self];
    [parser parse];
	if (![self isCancelled])
    {
       self.completionHandler(self.aBusiness);
    }
    
    self.workingPropertyString = nil;
    self.dataToParse = nil;
    
    [parser release];
	[pool release];
}

#pragma mark -
#pragma mark RSS processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:kColumnsStr]) {
        if (!self.cs) {
            self.cs = [[[columns alloc] init] autorelease];
            [self.cs setColumnsDict:attributeDict];
        }
    }else if([elementName isEqualToString:kColumnStr]){
        if (!self.c) {
            self.c = [[[column alloc] init] autorelease];
            [self.c setColumnDict:attributeDict];
        }
    }else if([elementName isEqualToString:kElementStr]){
        if (!self.e && self.c) {
            self.e = [[[element alloc] init] autorelease];
            [self.e setElementDict:attributeDict];
        }
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:kReturncodeStr]){
        [self.aBusiness setReturncode:trimmedString];
        [workingPropertyString setString:@""];
        return;
    }else if([elementName isEqualToString:kFlowinstanceidStr]){
        [self.aBusiness setFlowinstanceid:trimmedString];
        [workingPropertyString setString:@""];
        return;
    }else if([elementName isEqualToString:kStepStr]){
        [self.aBusiness setStep:trimmedString];
        [workingPropertyString setString:@""];
        return;
    }else if([elementName isEqualToString:kColumnStr]){
        [self.c setValue:trimmedString];
        [self.cs.columnsArray addObject:self.c];
        [workingPropertyString setString:@""];
        self.c =nil;
        return;
    }else if([elementName isEqualToString:kElementStr]){
        [self.e setValue:trimmedString];
        [self.c.elementArray addObject:self.e];
        self.e = nil;
        [workingPropertyString setString:@""];
        return ;
    }else if([elementName isEqualToString:kColumnsStr]){
        [self.aBusiness.columnsArray addObject:self.cs];
        [workingPropertyString setString:@""];
        self.cs = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [workingPropertyString appendString:string];
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (errorHandler) {
        self.errorHandler(parseError);
    }
}
@end
