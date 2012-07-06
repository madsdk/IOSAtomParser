//
//  Entry.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"
#import "Person.h"
#import "Text.h"
#import "Content.h"
#import "Link.h"
#import "Entry.h"


@interface Entry : NSObject <NSCopying> {
	// Required Atom fields.
	NSString* _id;
	Text* title;
	NSDate* updated;
    NSString* updatedString;
	
	// Recommended Atom fields.
	NSArray* authors;
	Content* content;
	NSArray* links;
	Text* summary;
	
	// Optional Atom fields. 
	NSArray* categories;
	NSArray* contributors;
	NSDate* published;
    NSString* publishedString;
	Feed *source;
	Text* rights;
}

@property(nonatomic, strong) NSString* _id;
@property(nonatomic, strong) Text* title;
@property(nonatomic, strong) NSDate* updated;
@property(nonatomic, strong) NSString *updatedString;
@property(nonatomic, strong) NSArray* authors;
@property(nonatomic, strong) Content* content;
@property(nonatomic, strong) NSArray* links;
@property(nonatomic, strong) Text* summary;
@property(nonatomic, strong) NSArray* categories;
@property(nonatomic, strong) NSArray* contributors;
@property(nonatomic, strong) NSDate* published;
@property(nonatomic, strong) NSString* publishedString;
@property(nonatomic, strong) Feed* source;
@property(nonatomic, strong) Text* rights;

- (id)init;
- (void)dealloc;

- (BOOL)isValid;

- (id)copyWithZone:(NSZone *)zone;

@end
