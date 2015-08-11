//
//  DBManager.h
//  YZDoctors
//
//  Created by lishengshu on 15-7-29.
//  Copyright (c) 2015年 Augbase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DBItem.h"
#import "ChatSupportItem.h"

@interface DBManager : NSObject

+(DBManager *)ShareInstance;

@property (nonatomic,strong)FMDatabase *yzdcdb;

#pragma 新的设计将要用到的函数
-(BOOL)creatDatabase:(NSString *)dbname;
-(BOOL)isDBReady;
//因为查询效率的问题，每个联系人私聊和每个群组的群聊消息都要用一个表保存，即每个联系人一个表，每个群一个表,查询是否存在该表，存在返回yes,不存在自动创建并返回创建结果成功与否
-(BOOL)isChatTableExist:(NSString *)tname;
//创建群聊表，元素少许不同，具体参照DBItem
-(BOOL)isGroupChatTableExist:(NSString *)tname;
-(BOOL)addChatobjTablename:(NSString *)tableName andchatobj:(DBItem *)obj;
-(BOOL)addGroupchatobjTablename:(NSString *)tableName andchatobj:(DBItem *)obj;
//搜寻倒数几个mess，主要用于定量刷新数据
-(FMResultSet *)SearchMessWithNumber:(NSString *)tableNameJID MessNumber:(NSInteger)messNumber SearchKey:(NSString *)searchKey SearchMethodDescOrAsc:(NSString *)methodDescOrAsc;
//查询没读的讯息数目,名称设定为readornot
-(FMResultSet *)SearchMessNotReadNumber:(NSString *)tableName ItemName:(NSString *)itemName ItemValue:(NSInteger)itemValue;
//获取所有表名
-(NSMutableArray *)getAllTableName;
//删除联系表
-(BOOL)deleteTable:(NSString *)tableName;
//删除一条数据
-(BOOL)deleteinterobjTablename:(NSString *)name andinterobj:(NSString  *)jid;
//设置已读
-(BOOL)SetNotReadToRead:(NSString *)tableName;
//数据库是否打开
-(BOOL)isDBOpen;
-(void)closeDB;




@end
