//
//  InstructionsViewController.m
//  BunnyMatcher
//
//  Created by Jamie Ly on 1/1/13.
//  Copyright (c) 2013 Jamie Ly. All rights reserved.
//

#import "InstructionsViewController.h"


@implementation InstructionsViewController

- (void)viewDidLoad {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"instructions"
                                         withExtension: @"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL: url];
    [self.webView loadRequest: request];
}

@end
