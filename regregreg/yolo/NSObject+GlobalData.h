//
//  NSObject+GlobalData.h
//  yolo
//
//  Created by Vikram Mullick on 10/19/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
{
    NSString *test;
}


@property (nonatomic, retain) NSString *message;

+ (GlobalData*)sharedGlobalData;

// global function
- (void) myFunc;

@end
