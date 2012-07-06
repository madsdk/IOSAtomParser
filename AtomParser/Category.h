//
//  Category.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/15/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Category : NSObject < NSCopying > {
	NSString* term; //identifies the category
	NSURL* scheme; //identifies the categorization scheme via a URI. 
	NSString* label; //provides a human-readable label for display
}

@property(nonatomic, strong) NSString* term;
@property(nonatomic, strong) NSURL* scheme;
@property(nonatomic, strong) NSString* label;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
