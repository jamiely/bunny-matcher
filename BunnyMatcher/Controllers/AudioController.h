//
//  AudiController.h
//  BunnyMatcher
//
//  Created by Jamie Ly on 12/13/12.
//  Copyright (c) 2012 Jamie Ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioController : NSObject
- (void) playURL: (NSURL*) url;
+ (AudioController*) sharedInstance;
@end
