//
//  FriendDBManager.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/3.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FriendDBManager.h"
#import "FriendDBItem.h"

@implementation FriendDBManager

+(FriendDBManager *)ShareInstance{
    static FriendDBManager *sharedFriendDBManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedFriendDBManagerInstance = [[self alloc] init];
    });
    return sharedFriendDBManagerInstance;
}

#pragma 创建并打开,创建位置在documents中
-(BOOL)creatDatabase:(NSString *)dbname{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dbname]];
    self.yzFriendDB = [FMDatabase databaseWithPath:dbpath];
    //为数据库设置缓存，提高查询效率
    [self.yzFriendDB setShouldCacheStatements:YES];
    return [self.yzFriendDB open];
}

-(BOOL)isDBReady{
    if(!self.yzFriendDB){
        return NO;
    }
    if (![self.yzFriendDB open]) {
       	return NO;
    }
    return YES;
}

#pragma mark-判断私聊表是否存在,不存在则创建表，tableName即为jid
-(BOOL)isFriendTableExist:(NSString *)tname{
    if (![self isDBReady])
        return NO;
    if(![self.yzFriendDB tableExists:tname]){
        NSString *sql=[NSString stringWithFormat:@"create table %@(chatid INTEGER PRIMARY KEY AUTOINCREMENT,friendJID TEXT,friendName TEXT,friendRealName TEXT,friendImageUrl TEXT,friendDescribe TEXT,friendAge TEXT,friendGender TEXT,friendSimilarity TEXT,friendOnlineOrNot TEXT)",tname];
        BOOL success=[self.yzFriendDB executeUpdate:sql];
        return success;
    }
    else{
        //已经存在
        return YES;
    }
}
#pragma mark-插入好友列表 或者更新------------------------|*|*|*|*|*|
-(BOOL)addFriendObjTablename:(NSString *)tableName andchatobj:(FriendDBItem *)obj{
    [self isFriendTableExist:tableName];
    NSString *friendJid = obj.friendJID;
    NSString *firendName = obj.friendName;
    NSString *firendRealName = obj.friendRealName;
    NSString *friendImageUrl = obj.friendImageUrl;
    NSString *friendDescribe = obj.friendDescribe;
    NSString *friendAge = obj.friendAge;
    NSString *friendGender = obj.friendGender;
    NSString *friendSimilarity = obj.friendSimilarity;
    NSString *friendOnlineOrNot = obj.friendOnlineOrNot;
    FMResultSet *searchResult = [self SearchOneFriend:tableName FriendJID:friendJid];
    NSLog(@"searchResult === %@",searchResult);
    int tempNumber = 0;
    while ([searchResult next]) {
        tempNumber++;
    }
    if (tempNumber == 0) {
        //不存在重复
        NSString *insertsql = [NSString stringWithFormat:@"INSERT INTO %@ (friendJID, friendName,friendRealName,friendImageUrl,friendDescribe,friendAge,friendGender,friendSimilarity,friendOnlineOrNot) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,friendJid,firendName,firendRealName,friendImageUrl,friendDescribe,friendAge,friendGender,friendSimilarity,friendOnlineOrNot];
        NSLog(@"insertsql===%@",insertsql);
        if ([self.yzFriendDB executeUpdate:insertsql]) {
            //插入成功
            NSLog(@"插入成功");
            return YES;
        }
        else{
            return NO;
        }
    }else{
        NSString *updatesql=[NSString stringWithFormat:@"UPDATE %@ set friendJID = '%@',friendName = '%@' ,friendRealName = '%@',friendImageUrl = '%@' ,friendDescribe = '%@' ,friendAge = '%@',friendGender = '%@',friendSimilarity = '%@' where friendJID = '%@'",tableName,friendJid,firendName,firendRealName,friendImageUrl,friendDescribe,friendAge,friendGender,friendSimilarity,friendJid];
        
        if ([self.yzFriendDB executeUpdate:updatesql]) {
            return YES;
        }
        else{
            return NO;
        }
    }
}

-(BOOL)updateFriendState:(NSString *)tableName FriendJid:(NSString *)friendJid andState:(NSString *)state{
    NSString *updatesql=[NSString stringWithFormat:@"UPDATE %@ set friendOnlineOrNot = '%@' where friendJID = '%@'",tableName,state,friendJid];
    if ([self.yzFriendDB executeUpdate:updatesql]) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark-查询数据
#warning 取材方式
//while ([messWithNumber next]) {
//obj.mycontent = [messWithNumber stringForColumn:@"key"];

//查询固定数额的讯息,推荐设置第一次为倒数10条，之后递增，searchKey推荐为主键，tableName为默认Yizhen+jid值,SearchMethodDescOrAsc推荐desc
-(FMResultSet *)SearchMessWithNumber:(NSString *)tableNameJID MessNumber:(NSInteger)messNumber SearchKey:(NSString *)searchKey SearchMethodDescOrAsc:(NSString *)methodDescOrAsc{
    FMResultSet *messWithNumber;
#warning 此处的limit 0,%ld表示从第一台哦开始，取％ld条数据，0可以自己修改为想要的数据或是传入
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@ order by %@ %@ limit 0,%ld ",tableNameJID,searchKey,methodDescOrAsc,(long)messNumber];
    if ([self isFriendTableExist:tableNameJID]) {
        messWithNumber = [self.yzFriendDB executeQuery:searchsql];
    }
    return messWithNumber;
}

-(FMResultSet *)SearchOneFriend:(NSString *)tableName FriendJID:(NSString *)friendJid{
    FMResultSet *messWithNumber;
#warning 此处的limit 0,%ld表示从第一台哦开始，取％ld条数据，0可以自己修改为想要的数据或是传入
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@ where friendJID = '%@'",tableName,friendJid];
    if ([self isFriendTableExist:tableName]) {
        messWithNumber = [self.yzFriendDB executeQuery:searchsql];
    }
    return messWithNumber;
}

-(FMResultSet *)SearchAllFriend:(NSString *)tableNameJID{
    FMResultSet *messWithNumber;
#warning 此处的limit 0,%ld表示从第一台哦开始，取％ld条数据，0可以自己修改为想要的数据或是传入
    NSString *searchsql=[NSString stringWithFormat:@"SELECT * FROM %@",tableNameJID];
    if ([self isFriendTableExist:tableNameJID]) {
        messWithNumber = [self.yzFriendDB executeQuery:searchsql];
    }
    return messWithNumber;
}

#pragma 获取所有表名,获取的是表名的jid
-(NSMutableArray *)getFriendTableName{
    NSMutableArray *tableMessName = [NSMutableArray array];
    //    NSMutableArray *tableFriendName = [NSMutableArray array];
    //    NSMutableDictionary *tableNameDic = [NSMutableDictionary dictionaryWithCapacity:0];
    FMResultSet  *tableNameSet;
    NSString *searchsql=[NSString stringWithFormat:@"SELECT NAME FROM sqlite_master WHERE type='table' order by name"];
    tableNameSet = [self.yzFriendDB executeQuery:searchsql];
    while ([tableNameSet next]) {
        if (![[tableNameSet stringForColumn:@"name"] isEqualToString:@"sqlite_sequence"]) {
            NSString *tableStringName = [tableNameSet stringForColumn:@"name"];
            if ([tableStringName rangeOfString:YizhenFriendName].location != NSNotFound) {
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
    if (![_yzFriendDB executeUpdate:sqlstr])
    {
        NSLog(@"删除错误");
        return NO;
    }
    return YES;
}

#pragma 删除数据
-(BOOL)deleteFriendObjTablename:(NSString *)name andinterobj:(NSString  *)jid{
    BOOL isexit=[self isFriendTableExist:name];
    BOOL issuccess;
    if (isexit) {
        NSString *deletesql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE friendJID='%@'",name,jid];
        issuccess = [self.yzFriendDB executeUpdate:deletesql];
        NSLog(@"deletesql==%@",deletesql);
    }
    return issuccess;
}

-(void)closeDB{
    [self.yzFriendDB close];
}

@end
