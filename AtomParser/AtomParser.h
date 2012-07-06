//
//  AtomParser.h
//  AtomParser
//
//  Created by Mads Kristensen on 2/8/12.
//  Copyright (c) 2012 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtomDocument.h"

#define ATOMPARSERERRORDOMAIN @"mads.dk.AtomParser"

enum AtomParserErrors {
    NotImplemented = 0,
    ValidationError = 1, 
    ParseError = 2
    };

@interface AtomParser : NSObject

+ (AtomDocument *)parseURL:(NSURL *)url error:(NSError **)error;
+ (AtomDocument *)parseString:(NSString *)atomString error:(NSError **)error;
+ (AtomDocument *)parseData:(NSData *)data withEncoding:(NSStringEncoding)encoding error:(NSError **)error;

@end
