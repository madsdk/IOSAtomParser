//
//  Entry.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Entry.h"


@implementation Entry

@synthesize _id;
@synthesize title;
@synthesize updated;
@synthesize updatedString;
@synthesize authors;
@synthesize content;
@synthesize links;
@synthesize summary;
@synthesize categories;
@synthesize contributors;
@synthesize published;
@synthesize publishedString;
@synthesize source;
@synthesize rights;

- (id)init {
	self = [super init];
	if (self) {
//		authors = [[NSMutableArray alloc] init];
//		links = [[NSMutableArray alloc] init];
//		categories = [[NSMutableArray alloc] init];
//		contributors = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	self._id = nil;
	self.title = nil;
	self.updated = nil;
	self.authors = nil;
	self.content = nil;
	self.links = nil;
	self.summary = nil;
	self.categories = nil;
	self.contributors = nil;
	self.published = nil;
	self.source = nil;
	self.rights = nil;
}

- (BOOL)isValid {
	return (self._id != nil && self.title != nil && self.updated != nil);
}

- (id)copyWithZone:(NSZone *)zone
{
    Entry *entryCopy = [[Entry alloc] init];
    entryCopy._id = [self._id copyWithZone:zone];
    entryCopy.title = [self.title copyWithZone:zone];
    entryCopy.updated = [self.updated copyWithZone:zone];
    entryCopy.authors = [self.authors copyWithZone:zone];
    entryCopy.content = [self.content copyWithZone:zone];
    entryCopy.links = [self.links copyWithZone:zone];
    entryCopy.summary = [self.summary copyWithZone:zone];
    entryCopy.categories = [self.categories copyWithZone:zone];
    entryCopy.contributors = [self.contributors copyWithZone:zone];
    entryCopy.published = [self.published copyWithZone:zone];
    entryCopy.source = [self.source copyWithZone:zone];
    entryCopy.rights = [self.rights copyWithZone:zone];
    return entryCopy;
}

@end
