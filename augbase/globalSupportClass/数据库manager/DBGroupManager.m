//
//  DBManager.h
//  YZDoctors
//
//  Created by lishengshu on 15-7-29.
//  Copyright (c) 2015年 Augbase. All rights reserved.
//

#import "DBGroupManager.h"
#import "WriteFileSupport.h"

@implementation DBGroupManager

+(DBGroupManager *)ShareInstance{
    static DBGroupManager *sharedGroupDBManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGroupDBManagerInstance = [[self alloc] init];
    });
    return sharedGroupDBManagerInstance;
}
#warning 新设计的数据库操作函数
#pragma 创建并打开,创建位置在documents中
-(BOOL)creatDatabase:(NSString *)dbname{
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dbname]];
        self.yzGroupDB = [FMDatabase databaseWithPath:dbpath];
        //为数据库设置缓存，提高查询效率
        [self.yzGroupDB setShouldCacheStatements:YES];
        return [self.yzGroupDB open];
}

-(BOOL)isDBReady{
    if(!self.yzGroupDB){
        return NO;
    }
    if (![self.yzGroupDB open]) {
       	return NO;
    }
    return YES;
}

#pragma mark-判断私聊表是否存在,不存在则创建表，tableName即为jid
-(BOOL)isChatTableExist:(NSString *)tname{
    if (![self isDBReady])
        return NO;
    if(![self.yzGroupDB tableExists:tname]){
        NSString *sql=[NSString stringWithFormat:@"create table %@(chatid INTEGER PRIMARY KEY AUTOINCREMENT,personJID TEXT,personNickName TEXT,personImageUrl TEXT,messContent TEXT,messTime TEXT, FromMeOrNot INTEGER,ReadOrNot INTEGER,chatType  INTEGER,messType INTEGER,timeStamp TEXT)",tname];
        BOOL success=[self.yzGroupDB executeUpdate:sql];
        return success;
    }
    else{
        //已经存在
        return YES;
    }
}

#pragma mark-插入聊天列表 或者更新------------------------|*|*|*|*|*|
-(BOOL)addChatobjTablename:(NSString *)tableName andchatobj:(DBItem *)obj{
    BOOL isexit = [self isChatTableExist:tableName];
    NSString *personJID = obj.personJID;
    NSString *personNickName = obj.personNickName;
    NSString *personImageUrl = obj.personImageUrl;
    NSInteger chatType = obj.chatType;
    NSInteger messType = obj.messType;
    NSInteger ReadOrNot = obj.ReadOrNot;
    NSInteger FromMeOrNot = obj.FromMeOrNot;
    NSString *timeStamp = obj.timeStamp;
    NSString *messContent = obj.messContent;
    NSString *messTime = obj.messVoiceTime;//yyyy-MM-dd HH:mm:ss EEE
    
    if (isexit) {
        NSDate *fromDate = [self changeStringToDate:timeStamp];
        [[DBGroupManager ShareInstance] creatDatabase:GroupChatDBName];
        FMResultSet *lastMessResult = [[DBGroupManager ShareInstance]SearchMessWithNumber:tableName MessNumber:1 SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
        NSString *lastTime;
        int number = 0;
        while ([lastMessResult next]){
            lastTime = [lastMessResult stringForColumn:@"timeStamp"];
            number++;
        }
        NSDate *endDate = [self changeStringToDate:lastTime];
        
        NSTimeInterval secondsInterval= [fromDate timeIntervalSinceDate:endDate];
        NSLog(@"secondsInterval=  %lf",secondsInterval);
        
        if (number != 0&&secondsInterval>0) {
            //存在表
            NSString *insertsql = [NSString stringWithFormat:@"INSERT INTO %@ (personJID, personNickName,personImageUrl,messContent,messTime,FromMeOrNot,ReadOrNot,chatType,messType,timeStamp) VALUES ('%@','%@','%@','%@','%@',%ld,%ld,%ld,%ld,'%@')",tableName,personJID,personNickName,personImageUrl,messContent,messTime,(long)FromMeOrNot,(long)ReadOrNot,(long)chatType,(long)messType,timeStamp];
            if ([self.yzGroupDB executeUpdate:insertsql]) {
                //插入成功
                NSLog(@"插入成功");
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    return YES;
}

-(NSDate *)changeStringToDate:(NSString *)dateString{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];
    NSDate *fromdate=[format dateFromString:dateString];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    NSLog(@"date=%@",fromDate);
    return  fromDate;
}

#pragma mark-查询数据
#warning 取材方式
//while ([messWithNumber next]) {
//obj.mycontent = [messWithNumber stringForColumn:@"key"];

//查询固定数额的讯息,推荐设置第一次为倒数10条，之后递增，searchKey推荐为主键chatid，tableName为默认Yizhen+jid值,SearchMethodDescOrAsc推荐desc
-(FMResultSet *)SearchMessWithNumber:(NSString *)tableNameJID MessNumber:(NSInteger)messNumber SearchKey:(NSString *)searchKey SearchMethodDescOrAsc:(NSString *)methodDescOrAsc{
    FMResultSet *messWithNumber;
#warning 此处的limit 0,%ld表示从第一台哦开始，取％ld条数据，0可以自己修改为想要的数据或是传入
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ order by %@ %@ limit 0,%ld) order by %@ ASC",tableNameJID,searchKey,methodDescOrAsc,(long)messNumber,searchKey];
    if ([self isChatTableExist:tableNameJID]) {
        messWithNumber = [self.yzGroupDB executeQuery:searchsql];
    }
    return messWithNumber;
}
//查询没读的讯息数目,名称设定为readornot,没读取的itemValue为0
-(FMResultSet *)SearchMessNotReadNumber:(NSString *)tableName ItemName:(NSString *)itemName ItemValue:(NSInteger)itemValue{
    FMResultSet *messWithNumber;
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%ld",tableName,itemName,(long)itemValue];
    if ([self isChatTableExist:tableName]) {
        messWithNumber = [self.yzGroupDB executeQuery:searchsql];
    }
    return messWithNumber;
}

-(BOOL)SetNotReadToRead:(NSString *)tableName{
    BOOL res;
//    NSString *upxdatesql = [NSString stringWithFormat:@"UPDATE %@ SET ReadOrNot=1 where ReadOrNot=0",tableName];
    NSString *updatesql = [NSString stringWithFormat:@"UPDATE %@ set ReadOrNot = 1 where ReadOrNot = 0",tableName];
    if ([self.yzGroupDB open]) {
        if ([self isChatTableExist:tableName]) {
            res = [self.yzGroupDB executeUpdate:updatesql];
        }
    }
    return res;
}

#pragma 获取所有表名,获取的是表名的jid
-(NSMutableArray *)getAllTableName{
    NSMutableArray *tableMessName = [NSMutableArray array];
//    NSMutableArray *tableFriendName = [NSMutableArray array];
//    NSMutableDictionary *tableNameDic = [NSMutableDictionary dictionaryWithCapacity:0];
    FMResultSet  *tableNameSet;
     NSString *searchsql=[NSString stringWithFormat:@"SELECT NAME FROM sqlite_master WHERE type='table' order by name"];
    tableNameSet = [self.yzGroupDB executeQuery:searchsql];
    while ([tableNameSet next]) {
        if (![[tableNameSet stringForColumn:@"name"] isEqualToString:@"sqlite_sequence"]) {
            NSString *tableStringName = [tableNameSet stringForColumn:@"name"];
            if ([tableStringName rangeOfString:YizhenTableName].location != NSNotFound) {
                NSArray *array = [tableStringName componentsSeparatedByString:@"_"];
                [tableMessName addObject:array[1]];
            }
        }
    }
    return tableMessName;
}

#pragma 删除表
-(BOOL)deleteTable:(NSString *)tableName{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_yzGroupDB executeUpdate:sqlstr])
    {
        NSLog(@"删除错误");
        return NO;
    }
    return YES;
}

#pragma 删除数据
-(BOOL)deleteinterobjTablename:(NSString *)name andinterobj:(NSString  *)jid{
    BOOL isexit=[self dbtableisexist2:name];
    BOOL issuccess;
    if (isexit) {
        NSString *insertsql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE dcjid='%@'",name,jid];
        issuccess = [self.yzGroupDB executeUpdate:insertsql];
    }
    return issuccess;
}

-(void)closeDB{
    [self.yzGroupDB close];
}

#pragma 检查数据库 是否被打开
-(BOOL)isDBOpen{
    return [self.yzGroupDB open];
}

#pragma mark-检查最近联系人表
-(BOOL)dbtableisexist2:(NSString *)tname{
    //UPDATE  %@  set mycontect = ?,lasttime =? ,chattype =? ,lastchattype =? ,where jid=
    [self isDBOpen];
    [self.yzGroupDB setShouldCacheStatements:YES];
    if(![self.yzGroupDB tableExists:tname]){
        //不存在就
        NSString *sql=[NSString stringWithFormat:@"create table %@(chtaid INTEGER PRIMARY KEY AUTOINCREMENT,dcjid TEXT, dcnickname TEXT,chatnum TEXT)",tname];
        BOOL success=[self.yzGroupDB executeUpdate:sql];
        return success;
    }
    else{
        //已经存在
        return YES;
    }
}

#pragma 删除db文件即可
-(void)deleteDB{
    NSString *dir = [self dirDoc];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@%@",dir,GroupChatDBName,@".sqlite"];
    [[WriteFileSupport ShareInstance]removePicture:filePath];
}

//获取documents路径
-(NSString *)dirDoc
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
