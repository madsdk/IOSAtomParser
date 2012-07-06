//
//  AtomDocument.h
//  AtomParser
//
//  Created by Mads Kristensen on 2/9/12.
//  Copyright (c) 2012 Aarhus University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"
#import "Entry.h"

@interface AtomDocument : NSObject

@property (strong, nonatomic) Feed *feed;

@end
