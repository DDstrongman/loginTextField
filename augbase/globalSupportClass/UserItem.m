//
//  UserItem.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem


#pragma xmppsupport单实例初始化
+(UserItem *) ShareInstance{
    static UserItem *sharedUserInfoInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserInfoInstance = [[self alloc] init];
    });
    return sharedUserInfoInstance;
}

@end
