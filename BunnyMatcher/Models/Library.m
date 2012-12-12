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
NSString* LIBRARY_TOPIC_DESSERTS = @"desserts";

@implementation Library

- (void) loadDefaultTopics {
    NSString *states = @"Alabama,Alaska,American Samoa,Arizona,Arkansas,California,Colorado,Connecticut,Delaware,District of Columbia,Florida,Georgia,Guam,Hawaii,Idaho,Illinois,Indiana,Iowa,Kansas,Kentucky,Louisiana,Maine,Maryland,Massachusetts,Michigan,Minnesota,Mississippi,Missouri,Montana,Nebraska,Nevada,New Hampshire,New Jersey,New Mexico,New York,North Carolina,North Dakota,Northern Marianas Islands,Ohio,Oklahoma,Oregon,Pennsylvania,Puerto Rico,Rhode Island,South Carolina,South Dakota,Tennessee,Texas,Utah,Vermont,Virginia,Virgin Islands,Washington,West Virginia,Wisconsin,Wyoming";
    NSString *animals = @"aardvark,alligator,armadillo,badger,boar,camel,cat,cow,dog,donkey,elephant,elk,fish,fox,frog,goat,horse,iguana,jaguar,kangaroo,lamb,lion,mole,ox,panda,pig,reindeer,seal,sheep,tiger,turtle,wolf,zebra";
    NSString *fruit = @"Apple,Apricot,Avocado,Banana,Breadfruit,Blackberry,Blueberry,Cherry,Clementine,Date,Dragonfruit,Durian,Fig,Gooseberry,Grape,Grapefruit,Guava,Huckleberry,Jackfruit,Kiwi,Lemon,Lime,Lychee,Mandarine,Mango,Cantaloupe,Honeydew melon,Watermelon,Nectarine,Orange,Peach,Pear,Plum,Pineapple,Pomegranate,Pomelo,Raspberry,Rambutan,Star fruit,Strawberry,Tangerine,Tomato";
    NSString *desserts = @"Ambrosia,Angel food cake,Apple crisp,Apple dumpling,Apple pie,Bacon sundae,Banana pudding,Banana split,Bananas Foster,Blondie (confection),Boston cream pie,Bread pudding,Brown Betty (dessert),Caramel,Carrot cake,Chocolate brownie,Chocolate chip cookie,Chocolate-covered potato chips,Chocolate-covered bacon,Cobbler (food),Corn cookie,Cottage Pudding,Crumble,Cupcake,Cupcone,Dirt cake,Doughnut,Fried Coke,Fried dough,Fudge,Funnel cake,German chocolate cake,Golden Opulence Sundae,Gooey butter cake,Hostess CupCake,Hot milk cake,Hummingbird cake,Ice cream cone,Icebox cake,Italian ice,Kentucky jam cake,King cake,Lemon meringue pie,Macaroon,Marshmallow creme,Neapolitan ice cream,Panocha,Parfait (food),Persimmon pudding,Pound cake,Pudding,Red velvet cake,Scotcheroos,S'more,Stack cake,Strawberry Delight,Strawberry rhubarb pie,Sundae,Twinkie,Waldorf pudding,Whoopie pie";

    NSDictionary *contentDictionary = @{
        LIBRARY_TOPIC_FRUITS: fruit,
        LIBRARY_TOPIC_ANIMALS: animals,
        LIBRARY_TOPIC_STATES: states,
        LIBRARY_TOPIC_DESSERTS: desserts
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

- (Topic*) topicAfter: (Topic*) topic {
    NSInteger index = [self.topics indexOfObject: topic];
    if(index == NSNotFound) {
        return nil;
    }
    
    NSInteger nextIndex = (index + 1) % self.topics.count;
    return [self.topics objectAtIndex: nextIndex];
}

- (void) loadFromFile: (NSString*) filepath {
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile: filepath
                                                  encoding: NSUTF8StringEncoding
                                                     error: &error];
    if(error) {
        self.topics = @[];
        NSLog(@"Error loading library file: %@", error);
        return;
    }
    
    [self loadFromString: content];
}

- (void) loadFromString: (NSString*) content {
    NSMutableArray *newTopics = [NSMutableArray array];
    // otherwise continue loading
    NSArray *lines = [content componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *words = [line componentsSeparatedByString: @"|"];
        if(words.count < 2) continue;
        
        NSString *name = [words objectAtIndex: 0];
        NSArray *itemNames = [words subarrayWithRange: NSMakeRange(1, words.count-1)];
        Topic *topic = [Topic topicWithName:name andItemNames:itemNames];
        [newTopics addObject: topic];
    }
    
    self.topics = newTopics;
}

- (Topic*) randomTopic {
    NSInteger count = self.topics.count;
    return count == 0 ? nil : [self.topics objectAtIndex: arc4random_uniform(count)];
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
