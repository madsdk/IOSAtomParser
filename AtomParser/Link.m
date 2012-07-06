//
//  Link.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Link.h"


@implementation Link

@synthesize rel;
@synthesize href;
@synthesize type;
@synthesize hreflang;
@synthesize title;
@synthesize length;

- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	self.rel = nil;
	self.href = nil;
	self.type = nil;
	self.hreflang = nil;
	self.title = nil;
}

- (id)copyWithZone:(NSZone *)zone {
	Link* linkCopy = [[Link allocWithZone:zone] init];
	linkCopy.rel = [self.rel copyWithZone:zone];
	linkCopy.href = [self.href copyWithZone:zone];
	linkCopy.type = [self.type copyWithZone:zone];
	linkCopy.hreflang = [self.hreflang copyWithZone:zone];
	linkCopy.title = [self.title copyWithZone:zone];
	linkCopy.length = self.length;
	return linkCopy;
}

@end
