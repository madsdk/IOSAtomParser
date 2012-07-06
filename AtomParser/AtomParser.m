//
//  AtomParser.m
//  AtomParser
//
//  Created by Mads Kristensen on 2/8/12.
//  Copyright (c) 2012 Aarhus University. All rights reserved.
//

#import "AtomParser.h"
#import "TouchXML.h"

@interface AtomParser()

+ (void)reportError:(NSString *)errorMessage error:(NSError *)error;

+ (Text *)parseTextElement:(CXMLElement *)textElement;
+ (Feed *)parseFeedElement:(CXMLElement *)element error:(NSError **)error;
+ (NSDate *)parseDateElement:(CXMLElement *)dateElement error:(NSError **)error;
+ (Person *)parsePersonElement:(CXMLElement *)personElement error:(NSError **)error;
+ (Entry *)parseEntry:(CXMLElement *)entryElement error:(NSError **)error;
+ (NSArray *)parseEntries:(NSArray *)entryElements error:(NSError **)error;
+ (Content *)parseContent:(CXMLElement *)contentElement error:(NSError **)error;
+ (Link *)parseLink:(CXMLElement *)linkElement error:(NSError **)error;
+ (NSArray *)parseLinks:(NSArray *)linkElements error:(NSError **)error;

@end

@implementation AtomParser

+ (AtomDocument *)parseURL:(NSURL *)url error:(NSError **)error
{
    // Start by fetching the data from the given URL.
    NSData *feedData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:error];
    if (feedData == nil) {
        // Error fetching feed data.
        [self reportError:@"Error fetching feed data." error:*error];
        return nil;
    }

    return [self parseData:feedData withEncoding:NSUTF8StringEncoding error:error];
}

+ (AtomDocument *)parseString:(NSString *)atomString error:(NSError **)error
{
    return [self parseData:[atomString dataUsingEncoding:NSASCIIStringEncoding] withEncoding:NSASCIIStringEncoding error:error];
}

+ (AtomDocument *)parseData:(NSData *)data withEncoding:(NSStringEncoding)encoding error:(NSError **)error;
{
    CXMLDocument *xmlDocument = [[CXMLDocument alloc] initWithData:data encoding:encoding options:CXMLDocumentTidyXML error:error];
    if (xmlDocument == nil) {
        [self reportError:@"Error parsing XML document." error:*error];
        return nil;
    }
    
    // Start by creating the Feed element.
    AtomDocument *atomDoc = [[AtomDocument alloc] init];
    CXMLElement *feedElement = [xmlDocument rootElement];
    if (![[[feedElement name] lowercaseString] isEqualToString:@"feed"]) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"Error validating XML. Root element was not a feed." error:nil];
        return nil;
    }
    
    // Parse the feed element.
    if ((atomDoc.feed = [self parseFeedElement:feedElement error:error]) == nil) {
        return nil;
    }
        
    return atomDoc;
}


#pragma mark - Private methods.

+ (void)reportError:(NSString *)errorMessage error:(NSError *)error
{
    if (error) {
        NSLog(@"AtomParser: %@ [Original error: %@]", errorMessage, error.localizedDescription);
    }
    else {
        NSLog(@"AtomParser: %@", errorMessage);
    }
}

+ (Feed *)parseFeedElement:(CXMLElement *)feedElement error:(NSError **)error
{
    Feed *feed = [[Feed alloc] init];
        
    // Read required attributes (id, title, updated).
    // ---------- id ----------
    NSArray *elements = [feedElement elementsForName:@"id"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple Feed->Id elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];
        feed._id = [element stringValue];
    }
    
    // ---------- title ----------
    elements = [feedElement elementsForName:@"title"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple Feed->Title elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];
        feed.title = [self parseTextElement:element];        
    }
    
    // ---------- updated ----------
    elements = [feedElement elementsForName:@"updated"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple Feed->Updated elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];   
        feed.updated = [self parseDateElement:element error:error];
        feed.updatedString = [element stringValue];
    }
    
    // Parse the author element(s). There may be none, but in that case all entry elements MUST contain at least one author element.
    elements = [feedElement elementsForName:@"author"];
    NSMutableArray *authors = [NSMutableArray array];
    for (CXMLElement *personElement in elements) {
        Person *person = [self parsePersonElement:personElement error:error];
        if (person) {
            [authors addObject:person];
        }
    }
    
    // If no authors are successfully parsed use nil instead of an empty array.
    if ([authors count] == 0) {
        feed.authors = nil;
    }
    else {
        feed.authors = [NSArray arrayWithArray:authors];
    }
        
    // TODO: parse optional attributes here.
    
    // Parse the entries of the feed.
    NSArray *entries = [feedElement elementsForName:@"entry"];
    feed.entries = [self parseEntries:entries error:error];
    
    return feed;
}

+ (Text *)parseTextElement:(CXMLElement *)textElement
{
    Text *text = [[Text alloc] init];

    // Set the 'type' attribute.
    CXMLNode *typeAttribute = [textElement attributeForName:@"type"];
    if (typeAttribute) {
        NSString *textTypeString = [[textElement attributeForName:@"type"] stringValue];
        if ([textTypeString caseInsensitiveCompare:@"text"] == 0) {
            text.type = TEXTTYPE_TEXT;
        }
        else if ([textTypeString caseInsensitiveCompare:@"html"] == 0) {
            text.type = TEXTTYPE_HTML;
        }
        else if ([textTypeString caseInsensitiveCompare:@"xhtml"] == 0) {
            text.type = TEXTTYPE_XHTML;
        }
    }
    else {
        // The Text element has no type attribute. Default is "text". 
        text.type = TEXTTYPE_TEXT;
    }
    
    // Add the contents.
    text.content = [textElement stringValue];
    
    return text;
}

// The method below was taken from https://github.com/mwaterfall/MWFeedParser/blob/master/Classes/NSDate%2BInternetDateTime.m
// It has been altered slightly. The license is ok.
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString {
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
        // Process date
        NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];

        // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
        // - see https://devforums.apple.com/thread/45837
        if (RFC3339String.length > 20) {
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                     withString:@""
                                                                        options:0
                                                                          range:NSMakeRange(20, RFC3339String.length-20)];
        }
        if (!date) { // 1996-12-19T16:39:57-0800
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date) { // 1937-01-01T12:00:27.87+0020
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date) { // 1937-01-01T12:00:27
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);
    }
    return date;
}

+ (NSDate *)parseDateElement:(CXMLElement *)dateElement error:(NSError **)error
{
/*
    NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
    [rfc3339DateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'-'ZZ':'ZZ"];
    [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate *date = [rfc3339DateFormatter dateFromString:[dateElement stringValue]];
 */

    NSDate *date = [AtomParser dateFromRFC3339String:[dateElement stringValue]];
    if (date == nil) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ParseError userInfo:nil];
        [self reportError:[NSString stringWithFormat:@"Error parsing date string (%@).", [dateElement stringValue]] error:nil];
    }
    
    return date;
}

+ (Person *)parsePersonElement:(CXMLElement *)personElement error:(NSError **)error
{
    Person *person = [[Person alloc] init];
    
    // The only required element is the name.
    NSArray *elements = [personElement elementsForName:@"name"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"Missing or multiple Person->Name elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];
        person.name = [element stringValue];
    }

    // Look for URI and email element.
    elements = [personElement elementsForName:@"uri"];
    if ([elements count] > 0) {
        // There should be only one URI element.
        if ([elements count] != 1) {
            *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
            [self reportError:@"More than one Person->URI element found." error:nil];
        }
        CXMLElement *element = [elements objectAtIndex:0];
        // Try to generate an NSURL.
        if ((person.uri = [NSURL URLWithString:[element stringValue]]) == nil) {
            *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
            [self reportError:@"Invalid URI given in Person->URI element." error:nil];
        }
    }

    elements = [personElement elementsForName:@"email"];
    if ([elements count] > 0) {
        // There should be only one email element.
        if ([elements count] != 1) {
            *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
            [self reportError:@"More than one Person->Email element found." error:nil];
        }
        CXMLElement *element = [elements objectAtIndex:0];
        person.email = [element stringValue];
    }
    
    // NOTE: Extended atributes are not parsed a.t.m.
    
    // Check that at least one of name, uri, or email are set - otherwise return nil.
    if (person.name == nil && person.email == nil && person.uri == nil) {
        person = nil;
    }

    return person;
}


+ (NSArray *)parseEntries:(NSArray *)entryElements error:(NSError **)error 
{
    NSMutableArray *entries = [NSMutableArray array];
    for (CXMLElement *entryElement in entryElements) {
        Entry *entry = [self parseEntry:entryElement error:error];
        if (entry) {
            [entries addObject:entry];
        }
    }
    
    // If no entries are available simply return nil (instead of an empty array).
    if ([entries count] == 0) {
        return nil;
    }
    else {
        return [NSArray arrayWithArray:entries];
    }
}

+ (Entry *)parseEntry:(CXMLElement *)entryElement error:(NSError **)error
{
    Entry *entry = [[Entry alloc] init];
        
    // Read required attributes (id, title, updated).
    // ---------- id ----------
    NSArray *elements = [entryElement elementsForName:@"id"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple Entry->Id elements." error:nil];
        return nil;
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];
        entry._id = [element stringValue];
    }
    
    // ---------- title ----------
    elements = [entryElement elementsForName:@"title"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple entry->Title elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];
        entry.title = [self parseTextElement:element];        
    }
    
    // ---------- updated ----------
    elements = [entryElement elementsForName:@"updated"];
    if ([elements count] != 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"No or multiple entry->Updated elements." error:nil];
    }
    else {
        CXMLElement *element = [elements objectAtIndex:0];   
        entry.updated = [self parseDateElement:element error:error];
        entry.updatedString = [element stringValue];
    }

    // Read the content of the entry.
    elements = [entryElement elementsForName:@"content"];
    // Report an error if multiple content elements are found.
    if ([elements count] > 1) {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"Multiple entry->content elements found." error:nil];        
    }
    // If we have any content elements (also when there are too many) store the first one.
    if ([elements count] > 0) {
        CXMLElement *contentElement = [elements objectAtIndex:0];
        entry.content = [self parseContent:contentElement error:error];
    }
    
    // ---------- links ----------
    elements = [entryElement elementsForName:@"link"];
    if ([elements count] > 0) {
        entry.links = [self parseLinks:elements error:error];
    }
    
    // ---------- author ----------
    // Parse the author element(s). There may be none, but in that case all entry elements MUST contain at least one author element.
    elements = [entryElement elementsForName:@"author"];
    NSMutableArray *authors = [NSMutableArray array];
    for (CXMLElement *personElement in elements) {
        Person *person = [self parsePersonElement:personElement error:error];
        if (person) {
            [authors addObject:person];
        }
    }
    
    // If no authors are successfully parsed use nil instead of an empty array.
    if ([authors count] == 0) {
        entry.authors = nil;
    }
    else {
        entry.authors = [NSArray arrayWithArray:authors];
    }

    // ---------- published ----------
    elements = [entryElement elementsForName:@"published"];
    if ([elements count] > 0) {
        CXMLElement *element = [elements objectAtIndex:0];
        entry.published = [self parseDateElement:element error:error];
        entry.publishedString = [element stringValue];
    }
    
    
    // TODO: parse all the missing elements... 
    
    
    return entry;
}

+ (Content *)parseContent:(CXMLElement *)contentElement error:(NSError **)error
{
    Content *content = [[Content alloc] init];
    
    // ---------- type ----------
    CXMLNode *typeAttr = [contentElement attributeForName:@"type"];
    if (typeAttr) {
        content.type = [typeAttr stringValue];
    }

    // ---------- src ----------
    CXMLNode *srcAttr = [contentElement attributeForName:@"src"];
    if (srcAttr) {
        content.type = [NSURL URLWithString:[srcAttr stringValue]];
    }

    // ---------- content ----------
    content.content = [contentElement stringValue];
    
    return content;
}

+ (NSArray *)parseLinks:(NSArray *)linkElements error:(NSError **)error
{
    NSMutableArray *links = [NSMutableArray array];
    
    for (CXMLElement *linkElement in linkElements) {
        Link *link = [self parseLink:linkElement error:error];
        if (link) {
            [links addObject:link];
        }
    }
    
    // If no entries are available simply return nil (instead of an empty array).
    if ([links count] == 0) {
        return nil;
    }
    else {
        return [NSArray arrayWithArray:links];
    }
}

+ (Link *)parseLink:(CXMLElement *)linkElement error:(NSError **)error
{
    Link *link = [[Link alloc] init];
    CXMLNode *node;
    
    // ---------- href ----------
    node = [linkElement attributeForName:@"href"];
    if (node) {
        link.href = [NSURL URLWithString:[node stringValue]];
    }
    else {
        *error = [NSError errorWithDomain:ATOMPARSERERRORDOMAIN code:ValidationError userInfo:nil];
        [self reportError:@"Missing href attribute in link element." error:nil];
    }

    // ---------- rel ----------
    node = [linkElement attributeForName:@"rel"];
    if (node) {
        link.rel = [node stringValue];
    }

    // ---------- type ----------
    node = [linkElement attributeForName:@"type"];
    if (node) {
        link.type = [node stringValue];
    }

    // ---------- hreflang ----------
    node = [linkElement attributeForName:@"hreflang"];
    if (node) {
        link.hreflang = [node stringValue];
    }

    // ---------- title ----------
    node = [linkElement attributeForName:@"title"];
    if (node) {
        link.title = [node stringValue];
    }

    // ---------- length ----------
    node = [linkElement attributeForName:@"length"];
    if (node) {
        link.length = [[node stringValue] intValue];
    }
    
    return link;
}

@end
