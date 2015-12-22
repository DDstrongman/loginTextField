//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "ChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"

#import "DBItem.h"

#import "DBManager.h"

#import "WriteFileSupport.h"

@implementation ChatModel

-(void)addCellFromDB:(NSString *)userJID MessNumber:(NSInteger)messNumber{
    self.dataSource = [NSMutableArray array];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,userJID]];
    FMResultSet *searchFMSet = [[DBManager ShareInstance] SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,userJID] MessNumber:messNumber SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
    [[FriendDBManager ShareInstance]creatDatabase:FriendDBName];
    FMResultSet *searchFriendImage = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:userJID];
    NSString *personImageFriendUrl;
    NSString *personImageMyUrl = [NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName];
    __block NSString *personImageUrl;
    while ([searchFriendImage next]) {
        personImageFriendUrl = [searchFriendImage stringForColumn:@"friendImageUrl"];
    }
    
    while ([searchFMSet next]) {
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        message.rootNavC = _rootNavC;
        NSString *personJID = [searchFMSet stringForColumn:@"personJID"];
        NSString *personNickName = [searchFMSet stringForColumn:@"personNickName"];
        NSString *messTableUrl = [searchFMSet stringForColumn:@"messTableUrl"];
        NSString *messTableTitle = [searchFMSet stringForColumn:@"messTableTitle"];
        NSString *messContent = [searchFMSet stringForColumn:@"messContent"];
        NSString *messTime = [searchFMSet stringForColumn:@"messTime"];
        NSString *FromMeOrNot = [searchFMSet stringForColumn:@"FromMeOrNot"];
        NSString *chatType = [searchFMSet stringForColumn:@"chatType"];
        NSString *messType = [searchFMSet stringForColumn:@"messType"];
        NSString *timeStamp = [searchFMSet stringForColumn:@"timeStamp"];
        [dataDic setObject:FromMeOrNot forKey:@"from"];
        [dataDic setObject:timeStamp forKey:@"strTime"];
        [dataDic setObject:@"" forKey:@"strName"];
        [dataDic setObject:messType forKey:@"type"];
        if ([FromMeOrNot isEqualToString:@"0"]) {
            personImageUrl = personImageMyUrl;
        }else{
            personImageUrl = personImageFriendUrl;
        }
        if (personImageFriendUrl != nil) {
            [dataDic setObject:personImageUrl forKey:@"strIcon"];
        }
        
        if ([messType isEqualToString:@"0"]) {
            [dataDic setObject:messContent forKey:@"strContent"];
        }else if([messType isEqualToString:@"1"]){
            if ([[WriteFileSupport ShareInstance]isFileExist:[yizhenChatFile stringByAppendingPathComponent:messContent]]) {
                [dataDic setObject:[NSURL URLWithString:messContent] forKey:@"picture"];
            }else{
                [dataDic setObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/chat/%@",messContent]] forKey:@"picture"];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                [manager GET:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/chat/%@",messContent] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSData *picData = responseObject;
                    [[WriteFileSupport ShareInstance]writeData:picData DirName:yizhenChatFile FileName:messContent];
                }failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                    
                }];
            }
        }else if([messType isEqualToString:@"2"]){
            [dataDic setObject:messTime forKey:@"strVoiceTime"];
            NSData *received;
            if ([[WriteFileSupport ShareInstance]isFileExist:[yizhenChatFile stringByAppendingPathComponent:messContent]]) {
                received = [[WriteFileSupport ShareInstance]readData:yizhenChatFile FileName:messContent];
            }else{
                received = [[HttpManager ShareInstance] httpGetSupport:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/chat/%@",messContent]];
                [[WriteFileSupport ShareInstance]writeData:received DirName:yizhenChatFile FileName:messContent];
            }
            [dataDic setObject:received forKey:@"voice"];
        }else if([messType isEqualToString:@"3"]){
            [dataDic setObject:messTableUrl forKey:@"urlContent"];
            [dataDic setObject:messTableTitle forKey:@"urlTitle"];
        }
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [self.dataSource addObject:messageFrame];
    }
}
// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;

@end
