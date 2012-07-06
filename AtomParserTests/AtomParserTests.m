//
//  AtomParserTests.m
//  AtomParserTests
//
//  Created by Mads Kristensen on 2/24/12.
//  Copyright (c) 2012 Aarhus University. All rights reserved.
//

#import "AtomParserTests.h"

@implementation AtomParserTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testParseInvalidFeedElement
{
    // Invalid XML. TouchXML uses the recover option so this error should be caught by the AtomParser itself.
    NSString *invalidAtomXML =@"<atom></foo>";
    NSError *error;
    AtomDocument *doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNil(doc, @"doc should be nil");
    STAssertTrue([error.domain isEqualToString:ATOMPARSERERRORDOMAIN] && error.code == ValidationError, @"Unexpected error domain or code");    
    if (error) NSLog(@"%@", error);
    
    // Valid XML but invalid Atom feed (it should start with a <feed> element).
    invalidAtomXML = @"<atom></atom>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNil(doc, @"doc should be nil");
    STAssertTrue(error.domain == ATOMPARSERERRORDOMAIN && error.code == ValidationError, @"Unexpected error domain or code");
    if (error) NSLog(@"%@", error);

    // Should be caught because of missing id field.
    invalidAtomXML = @"<feed></feed>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertTrue(error.domain == ATOMPARSERERRORDOMAIN && error.code == ValidationError, @"Unexpected error domain or code");
    if (error) NSLog(@"%@", error);

    // Should be caught because of missing title field.
    invalidAtomXML = @"<feed><id>someidiguess</id></feed>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertTrue(error.domain == ATOMPARSERERRORDOMAIN && error.code == ValidationError, @"Unexpected error domain or code");
    if (error) NSLog(@"%@", error);
    
    // Should be caught because of missing updated field.
    invalidAtomXML = @"<feed><id>someidiguess</id><title>My feed</title></feed>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertTrue(error.domain == ATOMPARSERERRORDOMAIN && error.code == ValidationError, @"Unexpected error domain or code");
    if (error) NSLog(@"%@", error);

    // Should be caught because of malformed updated field.
    invalidAtomXML = @"<feed><id>someidiguess</id><title>My feed</title><updated>sometime</updated></feed>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertTrue(error.domain == ATOMPARSERERRORDOMAIN && error.code == ParseError, @"Unexpected error domain or code");
    if (error) NSLog(@"%@", error);    

    // Should be caught because of malformed author field.
    invalidAtomXML = @"<feed><id>someidiguess</id><title>My feed</title><updated>2012-01-17T01:23:45Z</updated><author></author></feed>";
    error = nil;
    doc = [AtomParser parseString:invalidAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertNil(doc.feed.authors, @"No authors should be present.");
    if (error) NSLog(@"%@", error);    
}

- (void)testParseValidFeedElement
{
    NSString *validAtomXML = @"<feed><id>someidiguess</id><title>My feed</title><updated>2012-01-17T01:23:45Z</updated><author><name>Somepony</name><uri>http://equestriadaily.com</uri><email>me@somewhere.com</email></author></feed>";
    NSError *error = nil;
    AtomDocument *doc = [AtomParser parseString:validAtomXML error:&error];
    STAssertNotNil(doc, @"doc should not be nil");
    STAssertTrue([doc.feed._id isEqualToString:@"someidiguess"], @"ID parsed incorrectly");
    STAssertTrue([doc.feed.title.content isEqualToString:@"My feed"], @"Title parsed incorrectly");
    STAssertTrue([[[doc.feed.authors objectAtIndex:0] name] isEqualToString:@"Somepony"], @"Author name incorrectly parsed.");
    STAssertTrue([[[[doc.feed.authors objectAtIndex:0] uri] absoluteString] isEqualToString:@"http://equestriadaily.com"], @"Author URL incorrectly parsed.");
    STAssertTrue([[[doc.feed.authors objectAtIndex:0] email] isEqualToString:@"me@somewhere.com"], @"Author email incorrectly parsed.");
    if (error) NSLog(@"%@", error);    
}

@end
