//
//  SetupFunction.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/18.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "SetupFunction.h"

@implementation SetupFunction

+(SetupFunction *) ShareInstance{
    static SetupFunction *sharedSetupFunctionInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSetupFunctionInstance = [[self alloc] init];
    });
    return sharedSetupFunctionInstance;
}

@end
