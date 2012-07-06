//
//  Person.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Person.h"


@implementation Person

@synthesize name;
@synthesize uri;
@synthesize email;

- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	self.name = nil;
	self.uri = nil;
	self.email = nil;
}

- (id)copyWithZone:(NSZone *)zone {
	Person* personCopy = [[Person allocWithZone:zone] init];
	personCopy.name = [self.name copyWithZone:zone];
	personCopy.uri = [self.uri copyWithZone:zone];
	personCopy.email = [self.email copyWithZone:zone];
	return personCopy;
}

@end
