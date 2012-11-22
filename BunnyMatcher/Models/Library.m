//
//  Library.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 11/22/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "Library.h"

NSString* LIBRARY_TOPIC_FRUITS = @"fruits";
NSString* LIBRARY_TOPIC_STATES = @"states";
NSString* LIBRARY_TOPIC_ANIMALS = @"animals";

@implementation Library

@synthesize topics;

- (void) loadDefaultTopics {
    NSString *states = @"Alabama,Alaska,American Samoa,Arizona,Arkansas,California,Colorado,Connecticut,Delaware,District of Columbia,Florida,Georgia,Guam,Hawaii,Idaho,Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Maryland,Massachusetts,Michigan,Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,New Hampshire,New Jersey,New Mexico,New York,North Carolina,North Dakota,Northern Marianas Islands,Ohio,Oklahoma,Oregon,Pennsylvania,Puerto Rico,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Vermont,Virginia,Virgin Islands,Washington,West Virginia,Wisconsin,Wyoming";
    NSString *animals = @"aardvark,alligator,armadillo,badger,boar,camel,cat,cow,dog,donkey,elephant,elk,fish,fox,frog,goat,horse,iguana,jaguar,kangaroo,lamb,lion,mole,ox,panda,pig,reindeer,seal,sheep,tiger,turtle,wolf,zebra";
    NSString *fruit = @"Apple,Apricot,Avocado,Banana,Breadfruit,Blackberry,Blueberry,Cherry,Clementine,Date,Dragonfruit,Durian,Fig,Gooseberry,Grape,Grapefruit,Guava,Huckleberry,Jackfruit,Kiwi,Lemon,Lime,Lychee,Mandarine,Mango,Cantaloupe,Honeydew melon,Watermelon,Nectarine,Orange,Peach,Pear,Plum,Pineapple,Pomegranate,Pomelo,Raspberry,Rambutan,Star fruit,Strawberry,Tangerine,Tomato";

    NSDictionary *contentDictionary = @{
        LIBRARY_TOPIC_FRUITS: states,
        LIBRARY_TOPIC_ANIMALS: animals,
        LIBRARY_TOPIC_STATES: fruit
    };
    
    NSMutableArray *defaultTopics = [NSMutableArray arrayWithCapacity: [contentDictionary count]];
    for(NSString *topicName in contentDictionary) {
        NSString *contentString = [contentDictionary objectForKey: topicName];
        NSArray *names = [contentString componentsSeparatedByString:@","];
        [defaultTopics addObject: [Topic topicWithName: topicName andItemNames: names]];
    }
    self.topics = defaultTopics;
}

- (Topic*) topicWithName: (NSString*) name {
    for (Topic *topic in self.topics) {
        if([topic.name isEqualToString: name]) return topic;
    }
    return nil;
}

- (NSArray*) topicNames {
    NSMutableArray *names = [NSMutableArray arrayWithCapacity: self.topics.count];
    for (Topic *topic in self.topics) {
        [names addObject: topic.name];
    }
    return names;
}

+ (Library*) sharedInstance {
    static Library *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Library alloc] init];
        [instance loadDefaultTopics];
    });
    return instance;
}

@end
