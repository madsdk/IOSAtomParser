//
//  Generator.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/18/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Generator.h"


@implementation Generator

@synthesize uri;
@synthesize version;
@synthesize content;

- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	self.uri = nil;
	self.version = nil;
	self.content = nil;
}

- (id)copyWithZone:(NSZone *)zone {
	Generator* generatorCopy = [[Generator allocWithZone:zone] init];
	generatorCopy.uri = [self.uri copyWithZone:zone];
	generatorCopy.version = [self.version copyWithZone:zone];
	generatorCopy.content = [self.content copyWithZone:zone];
	return generatorCopy;
}

@end
