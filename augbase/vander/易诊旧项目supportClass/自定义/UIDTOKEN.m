//
//  UIDTOKEN.m
//  Yizhen2
//
//  Created by Jpxin on 14-6-16.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//
#import "UIDTOKEN.h"

@implementation UIDTOKEN

+(UIDTOKEN *)getme{
    static UIDTOKEN *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

@end
