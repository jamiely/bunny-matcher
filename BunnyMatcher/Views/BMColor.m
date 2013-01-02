//
//  BMColor.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/31/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import "BMColor.h"

@implementation BMColor

+ (UIColor*) grassColor {
    static UIColor* color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:0 green:0.9 blue:0.5 alpha: 1];
    });
    return color;
}
+ (UIColor*) patchHighlightColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor blueColor];
    });
    return color;
}
+ (UIColor*) patchColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed: 0.3 green: 0.6 blue: 0.1 alpha: 1];
    });
    return color;
}
+ (UIColor*) patchTextColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor whiteColor];
    });
    return color;
}
+ (UIColor*) positiveScoreColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            color = [UIColor whiteColor];
        }
        else {
            color = [UIColor blackColor];
        }
    });
    return color;
}
+ (UIColor*) negativeScoreColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor redColor];
    });
    return color;
}
+ (UIColor*) characterBackgroundColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor clearColor];
    });
    return color;
}
@end
