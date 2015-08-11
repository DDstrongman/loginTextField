//
//  FriendDBManager.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/3.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FriendDBItem.h"

@interface FriendDBManager : NSObject

@property (nonatomic,strong)FMDatabase *yzFriendDB;

+(FriendDBManager *)ShareInstance;

-(BOOL)creatDatabase:(NSString *)dbname;
-(BOOL)isDBReady;
-(BOOL)isFriendTableExist:(NSString *)tname;
-(BOOL)addFriendObjTablename:(NSString *)tableName andchatobj:(FriendDBItem *)obj;
-(BOOL)updateFriendState:(NSString *)tableName FriendJid:(NSString *)friendJid andState:(NSString *)state;
-(FMResultSet *)SearchMessWithNumber:(NSString *)tableNameJID MessNumber:(NSInteger)messNumber SearchKey:(NSString *)searchKey SearchMethodDescOrAsc:(NSString *)methodDescOrAsc;
-(FMResultSet *)SearchOneFriend:(NSString *)tableName FriendJID:(NSString *)friendJid;
-(FMResultSet *)SearchAllFriend:(NSString *)tableNameJID;
-(NSMutableArray *)getFriendTableName;
-(BOOL)deleteTable:(NSString *)tableName;
-(BOOL)deleteFriendObjTablename:(NSString *)name andinterobj:(NSString  *)jid;
-(void)closeDB;
@end
