//
//  Category.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/15/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Category.h"


@implementation Category

@synthesize term;
@synthesize scheme;
@synthesize label; 

- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	self.term = nil;
	self.scheme = nil;
	self.label = nil;
}

- (id)copyWithZone:(NSZone *)zone {
	Category* categoryCopy = [[Category allocWithZone:zone] init];
	categoryCopy.term = [self.term copyWithZone:zone];
	categoryCopy.scheme = [self.scheme copyWithZone:zone];
	categoryCopy.label = [self.label copyWithZone:zone];
	return categoryCopy;
}

@end
