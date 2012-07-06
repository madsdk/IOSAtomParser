//
//  Person.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject < NSCopying > {
	NSString* name; //conveys a human-readable name for the person.
	NSURL* uri; //contains a home page for the person.
	NSString* email; //contains an email address for the person.
}

@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSURL* uri;
@property(nonatomic, strong) NSString* email;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
