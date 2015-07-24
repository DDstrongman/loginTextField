//
//  UIDTOKEN.h
//  Yizhen2
//
//  Created by Jpxin on 14-6-16.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDTOKEN : NSObject
@property (nonatomic,strong)NSString *frienddbname;

@property (nonatomic,strong)NSString *myjid;
@property (nonatomic,strong)NSString *allcrads;//化验单集
@property (nonatomic,strong)NSString *aboutcard;//相关病例

@property (nonatomic,strong)NSString *BASICurl;


@property (nonatomic,strong)NSString *tmpurl;
@property (nonatomic,strong)NSString *bbsUrl1;
@property (nonatomic,strong)NSString *bbsUrl2;

//我的时间线
@property (nonatomic,strong)NSString *cardurl;



@property (nonatomic,strong)NSString *dbname;

@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *token;

@property (nonatomic,strong)NSString *nickname;

@property (nonatomic,strong)NSString *currentChat;

+(UIDTOKEN *)getme;

@end
