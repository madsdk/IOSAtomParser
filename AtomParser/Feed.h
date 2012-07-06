//
//  Feed.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Text.h"
#import "Generator.h"

@interface Feed : NSObject < NSCopying > {
	// Required elements.
	NSString* _id; //Identifies the feed using a universally unique and permanent URI.
	Text* title; //Contains a human readable title for the feed. Often the same as the title of the associated website. This value should not be blank. 
	NSDate* updated; //Indicates the last time the feed was modified in a significant way. 
    NSString *updatedString; // The RTF3339 string representation.

	// Recommended elements.
	NSArray* authors; //Names one author of the feed. A feed may have multiple author elements. A feed must contain at least one author element unless all of the entry elements contain at least one author element.
	NSArray* links; //Identifies a related Web page.
	
	// Optional elements.
	NSArray* categories; //Specifies a category that the feed belongs to. A feed may have multiple category elements.
	NSArray* contributors; //Names one contributor to the feed. An feed may have multiple contributor elements. 
	Generator* generator;
	NSURL* icon;
	NSURL* logo;
	Text* rights;
	Text* subtitle;
    
    // Entries.
    NSArray *entries;
}

@property(nonatomic, strong) NSString* _id;
@property(nonatomic, strong) Text* title;
@property(nonatomic, strong) NSDate* updated;
@property(nonatomic, strong) NSString *updatedString;
@property(nonatomic, strong) NSArray* authors;
@property(nonatomic, strong) NSArray* links;
@property(nonatomic, strong) NSArray* categories;
@property(nonatomic, strong) NSArray* contributors;
@property(nonatomic, strong) Generator* generator;
@property(nonatomic, strong) NSURL* icon;
@property(nonatomic, strong) NSURL* logo;
@property(nonatomic, strong) Text* rights;
@property(nonatomic, strong) Text* subtitle;
@property(nonatomic, strong) NSArray *entries;

- (id)init;
- (void)dealloc;

- (BOOL)isValid;

- (id)copyWithZone:(NSZone *)zone;

@end
