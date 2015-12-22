//
//  DBManager.h
//  YZDoctors
//
//  Created by lishengshu on 15-7-29.
//  Copyright (c) 2015年 Augbase. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

+(DBManager *)ShareInstance{
    static DBManager *sharedDBManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedDBManagerInstance = [[self alloc] init];
    });
    return sharedDBManagerInstance;
}
#warning 新设计的数据库操作函数
#pragma 创建并打开,创建位置在documents中
-(BOOL)creatDatabase:(NSString *)dbname{
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dbname]];
        self.yzdcdb = [FMDatabase databaseWithPath:dbpath];
        //为数据库设置缓存，提高查询效率
        [self.yzdcdb setShouldCacheStatements:YES];
        return [self.yzdcdb open];
}

-(BOOL)isDBReady{
    if(!self.yzdcdb){
        return NO;
    }
    if (![self.yzdcdb open]) {
       	return NO;
    }
    return YES;
}

#pragma mark-判断私聊表是否存在,不存在则创建表，tableName即为jid
-(BOOL)isChatTableExist:(NSString *)tname{
    if (![self isDBReady])
        return NO;
    if(![self.yzdcdb tableExists:tname]){
        NSString *sql=[NSString stringWithFormat:@"create table %@(chatid INTEGER PRIMARY KEY AUTOINCREMENT,personJID TEXT,personNickName TEXT,personImageUrl TEXT,messTableUrl TEXT,messTableTitle TEXT,messContent TEXT,messTime TEXT, FromMeOrNot INTEGER,ReadOrNot INTEGER,chatType  INTEGER,messType INTEGER,timeStamp TEXT)",tname];
        BOOL success=[self.yzdcdb executeUpdate:sql];
        return success;
    }
    else{
        //已经存在
        return YES;
    }
}
#pragma mark-判断群聊表是否存在,不存在则创建表，tableName即为jid
-(BOOL)isGroupChatTableExist:(NSString *)tname{
    if (![self isDBReady])
        return NO;
    if(![self.yzdcdb tableExists:tname]){
        NSString *sql=[NSString stringWithFormat:@"create table %@(chatid INTEGER PRIMARY KEY AUTOINCREMENT,personJID TEXT,personNickName TEXT,personImageUrl TEXT,messTableUrl TEXT,messTableTitle TEXT,messContent TEXT, FromMeOrNot INTEGER,ReadOrNot INTEGER,chatType  INTEGER,messType INTEGER,timeStamp TEXT)",tname];
        BOOL success=[self.yzdcdb executeUpdate:sql];
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
    NSString *personJID = obj.toPersonJID;
    NSString *personNickName = obj.personNickName;
    NSString *personImageUrl = obj.personImageUrl;
    NSString *messTableUrl = obj.messTableUrl;
    NSString *messTableTitle = obj.messTableTitle;
    NSInteger chatType = obj.chatType;
    NSInteger messType = obj.messType;
    NSInteger ReadOrNot = obj.ReadOrNot;
    NSInteger FromMeOrNot = obj.FromMeOrNot;
    NSString *timeStamp = obj.timeStamp;
    NSString *messContent = obj.messContent;
    NSString *messTime = obj.messVoiceTime;
    FMResultSet *messWithTime;
#warning 此处的limit 0,%ld表示从第一台哦开始，取％ld条数据，0可以自己修改为想要的数据或是传入
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@ where timeStamp = '%@'",tableName,timeStamp];
    
    if (isexit) {
        messWithTime = [self.yzdcdb executeQuery:searchsql];
        BOOL isReady = YES;
        while ([messWithTime next]){
            isReady = NO;
        }
        if (isReady) {
            //存在表
            NSString *insertsql = [NSString stringWithFormat:@"INSERT INTO %@ (personJID, personNickName,personImageUrl,messTableTitle,messTableUrl,messContent,messTime,FromMeOrNot,ReadOrNot,chatType,messType,timeStamp) VALUES ('%@','%@','%@','%@','%@','%@','%@',%ld,%ld,%ld,%ld,'%@')",tableName,personJID,personNickName,personImageUrl,messTableTitle,messTableUrl,messContent,messTime,(long)FromMeOrNot,(long)ReadOrNot,(long)chatType,(long)messType,timeStamp];
            if ([self.yzdcdb executeUpdate:insertsql]) {
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

-(BOOL)addGroupChatobjtablename:(NSString *)tableName andchatobj:(DBItem *)obj{
    BOOL isexit = [self isGroupChatTableExist:tableName];
    NSString *personJID = obj.personJID;
    NSString *personNickName = obj.personNickName;
    NSString *personImageUrl = obj.personImageUrl;
    NSInteger chatType = obj.chatType;
    NSInteger messType = obj.messType;
    NSString *timeStamp = obj.timeStamp;
    NSString *messContent = obj.messContent;
    NSInteger ReadOrNot = obj.ReadOrNot;
    NSInteger FromMeOrNot = obj.FromMeOrNot;
    return YES;
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
        messWithNumber = [self.yzdcdb executeQuery:searchsql];
    }
    return messWithNumber;
}
//查询没读的讯息数目,名称设定为readornot,没读取的itemValue为0
-(FMResultSet *)SearchMessNotReadNumber:(NSString *)tableName ItemName:(NSString *)itemName ItemValue:(NSInteger)itemValue{
    FMResultSet *messWithNumber;
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=%ld",tableName,itemName,(long)itemValue];
    if ([self isChatTableExist:tableName]) {
        messWithNumber = [self.yzdcdb executeQuery:searchsql];
    }
    return messWithNumber;
}

-(BOOL)SetNotReadToRead:(NSString *)tableName{
    BOOL res;
//    NSString *upxdatesql = [NSString stringWithFormat:@"UPDATE %@ SET ReadOrNot=1 where ReadOrNot=0",tableName];
    NSString *updatesql = [NSString stringWithFormat:@"UPDATE %@ set ReadOrNot = 1 where ReadOrNot = 0",tableName];
    if ([self.yzdcdb open]) {
        if ([self isChatTableExist:tableName]) {
            res = [self.yzdcdb executeUpdate:updatesql];
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
    tableNameSet = [self.yzdcdb executeQuery:searchsql];
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
    if (![_yzdcdb executeUpdate:sqlstr])
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
        issuccess = [self.yzdcdb executeUpdate:insertsql];
    }
    return issuccess;
}

-(void)closeDB{
    [self.yzdcdb close];
}

#warning 易诊旧的数据库操作函数


#warning 此处的创建基本废弃，创建用isExist函数来判断是否存在，不存在自动创建
#pragma mark-创建新表聊天列表**************************
-(BOOL)creatChatTablename:(NSString *)name{
    if (![self isDBReady])
        return NO;
    if(![self.yzdcdb tableExists:name]){
        //内容 isme   是否显示时间标签 内容数据  创建时间
        NSString *sql=[NSString stringWithFormat:@"create table %@(chatid INTEGER PRIMARY KEY AUTOINCREMENT,mycontent TEXT, isme INTEGER,type  INTEGER,displaytime TEXT,mydataname TEXT,creattime TEXT,sendsuccess TEXT)",name];
        BOOL success=[self.yzdcdb executeUpdate:sql];
        return success;
    }
    else{
        return NO;
    }
    return YES;
}

#pragma mark-检测最近联系人列表是否存在
-(FMResultSet *)Totestwhetherajid:(NSString *)jid andtablename:(NSString *)tname{
    
    [self isChatTableExist:tname];
    FMResultSet *rs;
    //查询全部
    NSString *searchsql=[NSString stringWithFormat:@"SELECT  * FROM %@ where jid='%@'",tname,jid];
    //order by creattime asc
    if ([self isChatTableExist:tname]) {
        rs = [self.yzdcdb executeQuery:searchsql];
    }
    return rs;
}

#pragma mark-检测___聊天列表是否存在
-(FMResultSet *)checkchattableview:(ChatSupportItem *)obj andtableviename:(NSString *)tname{
    [self isChatTableExist:tname];
    FMResultSet *rs;
    //查询全部
    NSString *searchsql=[NSString stringWithFormat:@"SELECT  * FROM %@ where mycontent='%@' and  isme=%d and type=%d and displaytime='%@' and creattime='%@'",tname,obj.mycontent,obj.isme,obj.mytype,obj.displaytime,obj.creattime];
    //order by creattime asc
    if ([self isChatTableExist:tname]) {
        rs = [self.yzdcdb executeQuery:searchsql];
    }
    return rs;
}

#pragma 检查数据库 是否被打开
-(BOOL)isDBOpen{
    return [self.yzdcdb open];
}



#pragma mark-患者端最近联系人 表?????????????????????????????????
-(BOOL)creatDianTablename:(NSString *)name{
    if (!self.yzdcdb) {
        [self creatDatabase:DBName];
    }
    if (![self.yzdcdb open]) {
       	return NO;
    }
    //为数据库设置缓存，提高查询效率
    [self.yzdcdb setShouldCacheStatements:YES];
    if(![self.yzdcdb tableExists:name]){
        /*
         dcjid :jid
         dcnickname :name
         chatnum :消息条数
         */
        NSString *sql=[NSString stringWithFormat:@"create table %@(chtaid INTEGER PRIMARY KEY AUTOINCREMENT,dcjid TEXT, dcnickname TEXT,chatnum TEXT)",name];
        BOOL success=[self.yzdcdb executeUpdate:sql];
        return success;
    }
    else{
        return NO;
    }
    return YES;
}

#pragma mark-检查最近联系人表
-(BOOL)dbtableisexist2:(NSString *)tname{
    //UPDATE  %@  set mycontect = ?,lasttime =? ,chattype =? ,lastchattype =? ,where jid=
    [self isDBOpen];
    [self.yzdcdb setShouldCacheStatements:YES];
    if(![self.yzdcdb tableExists:tname]){
        //不存在就
        NSString *sql=[NSString stringWithFormat:@"create table %@(chtaid INTEGER PRIMARY KEY AUTOINCREMENT,dcjid TEXT, dcnickname TEXT,chatnum TEXT)",tname];
        BOOL success=[self.yzdcdb executeUpdate:sql];
        return success;
    }
    else{
        //已经存在
        return YES;
    }
}

#pragma mark-插入最近联系人
-(BOOL)addinterobjTablename:(NSString *)name andinterobj:(DBItem *)obj{
    //检查表是否存在
    BOOL isexit=[self dbtableisexist2:name];
//    NSString *jid=obj.jid;
//    NSString *nickname=obj.nickname;
    //检测jid 是否已经插入
    //不需要检查了 直接插入
//    if (isexit) {
//        NSString *insertsql=[NSString stringWithFormat:@"INSERT INTO %@ (dcjid,dcnickname,chatnum) VALUES (?,?,?)",name];
//        if ([self.yzdcdb executeUpdate:insertsql,jid,nickname,@"1"]) {
//            //插入成功
//            return YES;
//        }
//        else{
//            return NO;
//        }
//    }
//    else{
//        return NO;
//    }
    return YES;
}

#pragma mark-更新最近联系人数据量
-(BOOL)updateinterobjTablename:(NSString *)name andinterobj:(DBItem *)obj  andnum:(NSString *)num{
    //检查表是否存在
    BOOL isexit=[self dbtableisexist2:name];
//    NSString *jid=obj.jid;
//    NSString *nickname=obj.nickname;
//    //检测jid 是否已经插入
//    //不需要检查了 直接插入
//    if (isexit) {
//        NSString *insertsql=[NSString stringWithFormat:@"UPDATE  %@  set chatnum = ?,dcnickname =?  where dcjid='%@' ",name,jid];
//        //查询 +1
//        //更新的数据
//        if ([self.yzdcdb executeUpdate:insertsql,num,nickname]) {
//            //插入成功
//            return YES;
//        }
//        else{
//            return NO;
//        }
//    }
//    else{
//        return NO;
//    }
    return YES;
}

#pragma mark-查询某个最近联系人
-(FMResultSet *)checkfriendableview:(NSString *)dcjid andtableviename:(NSString *)name{
    FMResultSet *rs=[[FMResultSet alloc] init];
    NSString *searchsql=[NSString stringWithFormat:@"SELECT  * FROM %@ where dcjid='%@'",name,dcjid];
    rs = [self.yzdcdb executeQuery:searchsql];
    BOOL n=[rs next];
    if (n==NO) {
        return nil;
        
    }
    return rs;
}

#pragma mark-查询全部数据
-(FMResultSet *)Allinterydbtablename:(NSString *)tname{
    FMResultSet *rs;
    if ([self isDBOpen]) {
        NSString *searchsql=[NSString stringWithFormat:@"SELECT  * FROM %@  ",tname];
        rs = [self.yzdcdb executeQuery:searchsql];
        
    }
    return rs;
}

#pragma 删除db文件即可
-(void)deleteDB{
    
}

@end
