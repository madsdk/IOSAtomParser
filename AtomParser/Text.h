//
//  Text.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//
// Note about the type attribute
// -----------------------------
// If type="text", then this element contains plain text with no entity escaped html.
//
// <title type="text">AT&amp;T bought by SBC!</title>
//
// If type="html", then this element contains entity escaped html.
// 
// <title type="html">
// AT&amp;amp;T bought &lt;b&gt;by SBC&lt;/b&gt;!
// </title>
// 
// If type="xhtml", then this element contains inline xhtml, wrapped in a div element.
// 
// <title type="xhtml">
// <div xmlns="http://www.w3.org/1999/xhtml">
// AT&amp;T bought <b>by SBC</b>!
// </div>
// </title>

#import <Foundation/Foundation.h>

typedef enum {
	TEXTTYPE_TEXT = 0, 
	TEXTTYPE_HTML, 
	TEXTTYPE_XHTML
} TextType;

@interface Text : NSObject < NSCopying > {
	TextType type; // See note above.
	NSString *content; // The content in the specified type.
}

@property(nonatomic, assign) TextType type;
@property(nonatomic, strong) NSString* content;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
