//
//  Content.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/15/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//
// Note about the content class
// ----------------------------
// In the most common case, the type attribute is either text, html, xhtml, 
// in which case the content element is defined identically to other text 
// constructs, which are described here.
// 
// Otherwise, if the src attribute is present, it represents the URI of where 
// the content can be found. The type attribute, if present, is the media type
// of the content.
// 
// Otherwise, if the type attribute ends in +xml or /xml, then an xml document
// of this type is contained inline.
// 
// Otherwise, if the type attribute starts with text, then an escaped document 
// of this type is contained inline.
// 
// Otherwise, a base64 encoded document of the indicated media type is contained
// inline.

#import <Foundation/Foundation.h>


@interface Content : NSObject <NSCopying> {
	NSString* type; //see note above.
	NSURL* src; //if present, it represents the URI of where the content can be found
	NSString* content; //if present, contains the actual content.
}

@property(nonatomic, strong) NSString* type;
@property(nonatomic, strong) NSURL* src;
@property(nonatomic, strong) NSString* content;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
