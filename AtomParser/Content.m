//
//  Content.m
//  atom-parser
//
//  Created by Mads Kristensen on 1/15/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import "Content.h"


@implementation Content

@synthesize type;
@synthesize src;
@synthesize content;

- (void)dealloc {
	self.type = nil;
	self.src = nil;
	self.content = nil;
}
- (id)init {
	self = [super init];
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Content *contentCopy = [[Content alloc] init];
    contentCopy.type = [self.type copyWithZone:zone];
    contentCopy.src = [self.src copyWithZone:zone];
    contentCopy.content = [self.content copyWithZone:zone];
    return contentCopy;
}


@end
