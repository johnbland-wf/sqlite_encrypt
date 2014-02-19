//
//  NSString+Helpers.h
//  couchbase
//
//  Created by Bryan Hales on 2/18/14.
//  Copyright (c) 2014 WebFilings, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*) arguments;

@end