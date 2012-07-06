//
//  Feed.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Feed.h"
#import "Entry.h"

@implementation Feed

@synthesize _id;
@synthesize title;
@synthesize updated;
@synthesize updatedString;
@synthesize authors;
@synthesize links;
@synthesize categories;
@synthesize contributors;
@synthesize generator;
@synthesize icon;
@synthesize logo;
@synthesize rights;
@synthesize subtitle;
@synthesize entries;

- (id)init {
	self = [super init];
	if (self) {
		authors = [[NSMutableArray alloc] init];
		links = [[NSMutableArray alloc] init];
		categories = [[NSMutableArray alloc] init];
		contributors = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc {
	self._id = nil;
	self.title = nil;
	self.updated = nil;
	self.authors = nil;
	self.links = nil;
	self.categories = nil;
	self.contributors = nil;
	self.generator = nil;
	self.icon = nil;
	self.logo = nil;
	self.rights = nil;
	self.subtitle = nil;
}

- (BOOL)isValid {
	if (self._id != nil && self.title != nil && self.updated != nil) {
        // The feed has an ID, title, and timestamp. Now check the author element. 
        // If no authours are attached to the feed all entries must contain an author element.
        if ([self.authors count] == 0) {
            // If no authours are attached to the feed all entries must contain an author element.
            for (Entry *entry in self.entries) {
                if ([entry.authors count] == 0) {
                    return FALSE;
                }
            }
        }
        return TRUE;
    }
    return FALSE;
}

- (id)copyWithZone:(NSZone *)zone {
	Feed* feedCopy = [[Feed allocWithZone:zone] init];
	feedCopy._id = [self._id copyWithZone:zone];
	feedCopy.title = [self.title copyWithZone:zone];
	feedCopy.updated = [self.updated copyWithZone:zone];
	feedCopy.authors = [[NSMutableArray allocWithZone:zone] initWithArray:self.authors copyItems:TRUE];
	feedCopy.links = [[NSMutableArray allocWithZone:zone] initWithArray:self.links copyItems:TRUE];
	feedCopy.categories = [[NSMutableArray allocWithZone:zone] initWithArray:self.categories copyItems:TRUE];
	feedCopy.contributors = [[NSMutableArray allocWithZone:zone] initWithArray:self.contributors copyItems:TRUE];
	feedCopy.generator = [self.generator copyWithZone:zone];
	feedCopy.icon = [self.icon copyWithZone:zone];
	feedCopy.logo = [self.logo copyWithZone:zone];
	feedCopy.rights = [self.rights copyWithZone:zone];
	feedCopy.subtitle = [self.subtitle copyWithZone:zone];
	return feedCopy;
}

@end
