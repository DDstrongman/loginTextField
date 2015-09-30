//
//  ChatModel.m
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "GroupChatModel.h"

#import "UUMessage.h"
#import "UUMessageFrame.h"

#import "DBItem.h"

#import "DBGroupManager.h"

#import "WriteFileSupport.h"

@implementation GroupChatModel

static NSString *previousTime = nil;
-(void)addCellFromDB:(NSString *)userJID MessNumber:(NSInteger)messNumber{
    self.dataSource = [NSMutableArray array];
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [[DBGroupManager ShareInstance] creatDatabase:GroupChatDBName];
    [[DBGroupManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,userJID]];
    FMResultSet *searchFMSet = [[DBGroupManager ShareInstance] SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,userJID] MessNumber:messNumber SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
    NSString *personImageMyUrl = [NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName];
    
    while ([searchFMSet next]) {
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        NSString *personImageUrl;
//        obj.mycontent = [searchFMSet stringForColumn:@"key"];
        NSString *personJID = [searchFMSet stringForColumn:@"personJID"];
        NSString *personNickName = [searchFMSet stringForColumn:@"personNickName"];
        NSString *messContent = [searchFMSet stringForColumn:@"messContent"];
        NSString *messTime = [searchFMSet stringForColumn:@"messTime"];
        NSString *FromMeOrNot = [searchFMSet stringForColumn:@"FromMeOrNot"];
        NSString *messType = [searchFMSet stringForColumn:@"messType"];
        NSString *timeStamp = [searchFMSet stringForColumn:@"timeStamp"];
//        NSString *personImageFriendUrl = [searchFMSet stringForColumn:@"personImageUrl"];
        [dataDic setObject:FromMeOrNot forKey:@"from"];
        [dataDic setObject:timeStamp forKey:@"strTime"];
        [dataDic setObject:personNickName forKey:@"strName"];
        [dataDic setObject:messType forKey:@"type"];
        
        
        if ([FromMeOrNot isEqualToString:@"0"]) {
            personImageUrl = personImageMyUrl;
        }else{
            NSString *documentsDirectory = [[WriteFileSupport ShareInstance] dirDoc];
            personImageUrl = [NSString stringWithFormat:@"%@/%@/%@.png",documentsDirectory,yizhenImageFile,personJID];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:personImageUrl]){
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,personJID,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
                [[HttpManager ShareInstance] AFNetGETSupport:jidurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res = [[userInfo objectForKey:@"res"] intValue];
                    if (res == 0) {
                        NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                        [[HttpManager ShareInstance] AFNetGETSupport:imageurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                            [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:personJID Contents:responseObject];
                            [_flushTableDelegate FlushTable:YES];
                        }FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }
        if (personImageUrl != nil) {
            [dataDic setObject:personImageUrl forKey:@"strIcon"];
        }
        
        if ([messType isEqualToString:@"0"]) {
            [dataDic setObject:messContent forKey:@"strContent"];
            [message setWithDict:dataDic];
            [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
            messageFrame.showTime = message.showDateLabel;
            [messageFrame setMessage:message];
            
            if (message.showDateLabel) {
                previousTime = dataDic[@"strTime"];
            }
            [self.dataSource addObject:messageFrame];
        }else if([messType isEqualToString:@"1"]){
            [dataDic setObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/chat/%@",messContent]] forKey:@"picture"];
            [message setWithDict:dataDic];
            [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
            messageFrame.showTime = message.showDateLabel;
            [messageFrame setMessage:message];
            
            if (message.showDateLabel) {
                previousTime = dataDic[@"strTime"];
            }
            [self.dataSource addObject:messageFrame];
        }else{
            [dataDic setObject:messTime forKey:@"strVoiceTime"];
            NSData *received = [[HttpManager ShareInstance] httpGetSupport:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/chat/%@",messContent]];
            [dataDic setObject:received forKey:@"voice"];
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
}

@end
