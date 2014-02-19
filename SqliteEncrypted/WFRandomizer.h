//
//  WFRandomizer.h
//  couchbase
//
//  Created by Bryan Hales on 2/18/14.
//  Copyright (c) 2014 WebFilings, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFRandomizer : NSObject

+ (WFRandomizer *)sharedInstance;
- (NSDictionary *)randomDictionary;
- (NSDictionary *)randomDictionaryWithNumberOfKeys:(int)numberOfKeys;
- (id)randomItem;
- (int)randomNumber;
- (int)randomNumber:(int)max;

@end