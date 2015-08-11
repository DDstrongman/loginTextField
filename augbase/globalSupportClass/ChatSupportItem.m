//
//  ChatSupportItem.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/29.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ChatSupportItem.h"

@implementation ChatSupportItem

#pragma ChatObject

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.displaytime forKey:@"DISPLAYTIME"];
    [aCoder encodeObject:self.mycontent forKey:@"MYCONTENT"];
    [aCoder encodeObject:self.mydataname forKey:@"DATANAME"];
    [aCoder encodeObject:self.creattime forKey:@"CREATTIME"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.mytype] forKey:@"MYTYPE"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.isme] forKey:@"ISME"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.displaytime =[aDecoder decodeObjectForKey:@"DISPLAYTIME"];
        self.mycontent =[aDecoder decodeObjectForKey:@"MYCONTENT"];
        self.mydataname =[aDecoder decodeObjectForKey:@"DATANAME"];
        self.creattime =[aDecoder decodeObjectForKey:@"CREATTIME"];
        self.mytype =[[aDecoder decodeObjectForKey:@"MYTYPE"] intValue];
        self.isme =[[aDecoder decodeObjectForKey:@"ISME"] intValue];
    }
    return self;
}

@end
