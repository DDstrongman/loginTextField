//
//  Drug.h
//  Yizhen-2.28
//
//  Created by ramy on 14-3-6.
//  Copyright (c) 2014年 jpx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drug : NSObject<NSCoding,NSCopying>


@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *starttime;
@property (nonatomic,strong)NSString *endtime;
@property (nonatomic,assign) BOOL iskang;
@property (nonatomic,strong)NSString *mhid;
@property (nonatomic,strong)NSString *mid;
@property (nonatomic,assign)BOOL isuse;

@end
