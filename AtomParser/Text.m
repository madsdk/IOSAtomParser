//
//  Text.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Text.h"


@implementation Text

@synthesize type;
@synthesize content;

- (id)init {
	self = [super init];
	return self;
}

- (void)dealloc {
	self.content = nil;
}

- (id)copyWithZone:(NSZone *)zone {
	Text* textCopy = [[Text allocWithZone:zone] init];
	textCopy.type = self.type;
	textCopy.content = [self.content copyWithZone:zone];
	return textCopy;
}

@end
