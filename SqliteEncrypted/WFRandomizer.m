//
//  WFRandomizer.m
//  couchbase
//
//  Created by Bryan Hales on 2/18/14.
//  Copyright (c) 2014 WebFilings, LLC. All rights reserved.
//

#import "WFRandomizer.h"

@interface WFRandomizer ()

@property (strong, nonatomic) NSArray *randomThings;

@end

@implementation WFRandomizer

+ (WFRandomizer *)sharedInstance {
    static dispatch_once_t once;
    static WFRandomizer *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (id)init {
    self = [super init];

    if (self) {
        self.randomThings = @[@"Rabbit", @"Dove", @"Turtle", @"Plate", @"Tomato", @"Tiger", @"Cow", @"Cat", @"Chain",
                              @"Chance", @"Eyeliner", @"Harbor", @"Iron", @"Oyster", @"Suede", @"Time", @"Tub", @"Spoon",
                              @"Chocolate", @"Giraffe", @"Fork", @"Squirrel", @"Computer", @"Dolphin", @"Carrots", @"Sofa",
                              @"Whale", @"Bananas", @"Bottle", @"Milk", @"Spectacles", @"Sheep", @"Phone", @"Beef",
                              @"Shark", @"Brocolli", @"Knife", @"Apple", @"Zebra", @"Fish", @"Drawer", @"Hamster", @"Crow",
                              @"Chicken", @"Bed", @"Egg", @"Lamp", @"Bread", @"Orange", @"Rat", @"Rhino", @"Panda", @"Lion"
                              @"Dog", @"Fridge"]; //, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @23, @45, @78, @3245, @229080];
    }

    return self;
}

- (id)randomItem {
    int index = [self randomNumber:self.randomThings.count];
    return [self.randomThings objectAtIndex:index];
}

- (int)randomNumber {
    // Defaults to 1 - 20
    return [self randomNumber:20] + 1;
}

- (int)randomNumber:(int)max {
    return arc4random() % max;
}

- (NSDictionary *)randomDictionary {
    return [self randomDictionaryWithNumberOfKeys:5];
}

- (NSDictionary *)randomDictionaryWithNumberOfKeys:(int)numberOfKeys {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:numberOfKeys];

    for (int i=0; i<numberOfKeys;i++) {
        [result setObject:[self randomItem] forKey:[self randomItem]];
    }

    return result;
}

@end