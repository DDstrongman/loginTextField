//
//  Drug.m
//  Yizhen-2.28
//
//  Created by ramy on 14-3-6.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import "Drug.h"

@implementation Drug
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"NAME"];
    [aCoder encodeObject:self.starttime forKey:@"STARTTIME"];
    [aCoder encodeObject:self.endtime forKey:@"ENDTIME"];
    
    [aCoder encodeBool:self.iskang forKey:@"ISKANG"];
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        
        self.name=[aDecoder decodeObjectForKey:@"NAME"];
        self.starttime=[aDecoder decodeObjectForKey:@"STARTTIME"];
        self.endtime=[aDecoder decodeObjectForKey:@"ENDTIME"];
        self.iskang=[[aDecoder decodeObjectForKey:@"ISKANG"] boolValue];
        
        
        
    }
    return self;
}
-(id)copyWithZone:(NSZone *)zone{
    Drug *drug=[[[self class] allocWithZone:zone] init];
    drug.name=[self.name copyWithZone:zone];
    drug.starttime=[self.starttime copyWithZone:zone];
    drug.endtime=[self.endtime copyWithZone:zone];
    drug.iskang=self.iskang;
    
    return drug;
}
@end
