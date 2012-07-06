//
//  Generator.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/18/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Generator : NSObject < NSCopying > {
	NSURL* uri;
	NSString* version;
	NSString* content;
}

@property(nonatomic, strong) NSURL* uri;
@property(nonatomic, strong) NSString* version;
@property(nonatomic, strong) NSString* content;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
