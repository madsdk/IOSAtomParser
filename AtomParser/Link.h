//
//  Link.h
//  atom-parser
//
//  Created by Mads Kristensen on 1/14/11.
//  Copyright 2011 Aarhus University. All rights reserved.
//
// Note about the rel attribute:
// -----------------------------
// rel contains a single link relationship type. It can be a full URI (see extensibility),
// or one of the following predefined values (default=alternate):
// * alternate: an alternate representation of the entry or feed, for example a permalink 
//   to the html version of the entry, or the front page of the weblog.
// * enclosure: a related resource which is potentially large in size and might require
//   special handling, for example an audio or video recording.
// * related: an document related to the entry or feed.
// * self: the feed itself.
// * via: the source of the information provided in the entry.


#import <Foundation/Foundation.h>


@interface Link : NSObject < NSCopying > {
	NSString* rel; //contains a single link relationship type. See note above.
	NSURL* href; //is the URI of the referenced resource (typically a Web page)
	NSString* type; //indicates the media type of the resource.
	NSString* hreflang; //indicates the language of the referenced resource.
	NSString* title; //human readable information about the link, typically for display purposes.
	int length; //the length of the resource, in bytes.
}

@property(nonatomic, strong) NSString* rel;
@property(nonatomic, strong) NSURL* href;
@property(nonatomic, strong) NSString* type;
@property(nonatomic, strong) NSString* hreflang;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, assign) int length;

- (id)init;
- (void)dealloc;

- (id)copyWithZone:(NSZone *)zone;

@end
