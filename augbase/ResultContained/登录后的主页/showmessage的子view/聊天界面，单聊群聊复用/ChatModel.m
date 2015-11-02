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

- (void)populateRandomDataSource:(NSMutableArray *)messMutableArray {
    self.dataSource = [NSMutableArray array];
    
    [self.dataSource addObjectsFromArray:[self additems:messMutableArray]];
}

- (void)addRandomItemsToDataSource:(NSMutableArray *)messMutableArray{
    
    for (int i=0; i<[messMutableArray count]; i++) {
        [self.dataSource insertObject:[[self additems:messMutableArray] firstObject] atIndex:0];
    }
}

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
//        obj.mycontent = [searchFMSet stringForColumn:@"key"];
        NSString *personJID = [searchFMSet stringForColumn:@"personJID"];
        NSString *personNickName = [searchFMSet stringForColumn:@"personNickName"];
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
        
        if ([messType isEqualToString:@"0"]) {
            [dataDic setObject:messContent forKey:@"strContent"];
            if ([FromMeOrNot isEqualToString:@"0"]) {
                personImageUrl = personImageMyUrl;
            }else{
                personImageUrl = personImageFriendUrl;
            }
            if (personImageFriendUrl != nil) {
                [dataDic setObject:personImageUrl forKey:@"strIcon"];
            }
            
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
            if ([FromMeOrNot isEqualToString:@"0"]) {
                personImageUrl = personImageMyUrl;
            }else{
                personImageUrl = personImageFriendUrl;
            }
            [dataDic setObject:personImageUrl forKey:@"strIcon"];
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
            if ([FromMeOrNot isEqualToString:@"0"]) {
                personImageUrl = personImageMyUrl;
            }else{
                personImageUrl = personImageFriendUrl;
            }
            [dataDic setObject:personImageUrl forKey:@"strIcon"];
            
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

// 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName];
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"Hello,Sister" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}

// 添加聊天item（一个cell内容）
static NSString *previousTime = nil;
- (NSArray *)additems:(NSMutableArray *)messArray
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i=0; i<[messArray count]; i++) {
        NSDictionary *dataDic = [self getDic:i TableArray:messArray];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
        UUMessage *message = [[UUMessage alloc] init];
        [message setWithDict:dataDic];
        [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];
        if (message.showDateLabel) {
            previousTime = dataDic[@"strTime"];
        }
        [result addObject:messageFrame];
    }
    return result;
}

// 如下:群聊（groupChat）
static int dateNum = 10;
- (NSDictionary *)getDic:(NSInteger)indexCount TableArray:(NSMutableArray *)messArray
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    int randomNum = arc4random()%5;
//    if (randomNum == UUMessageTypePicture) {
//        [dictionary setObject:[UIImage imageNamed:[NSString stringWithFormat:@"%zd.jpeg",arc4random()%2]] forKey:@"picture"];
//    }else{
//        // 文字出现概率4倍于图片（暂不出现Voice类型）
        randomNum = UUMessageTypeText;
//    NSMutableArray *tempArray = ;
    [dictionary setObject:((ChatSupportItem *)messArray[indexCount]).messContent forKey:@"strContent"];

//        [dictionary setObject:[self getRandomString] forKey:@"strContent"];
//    }
    NSDate *date = [[NSDate date]dateByAddingTimeInterval:arc4random()%1000*(dateNum++) ];
    [dictionary setObject:@(0) forKey:@"from"];
    [dictionary setObject:@(randomNum) forKey:@"type"];
    [dictionary setObject:[date description] forKey:@"strTime"];
    // 这里判断是否是私人会话、群会话
    int index = _isGroupChat ? arc4random()%6 : 0;
    [dictionary setObject:[self getName:index] forKey:@"strName"];
    [dictionary setObject:[self getImageStr:index] forKey:@"strIcon"];
    
    return dictionary;
}

- (NSString *)getRandomString {
    
    NSString *lorumIpsum = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent non quam ac massa viverra semper. Maecenas mattis justo ac augue volutpat congue. Maecenas laoreet, nulla eu faucibus gravida, felis orci dictum risus, sed sodales sem eros eget risus. Morbi imperdiet sed diam et sodales.";
    
    NSArray *lorumIpsumArray = [lorumIpsum componentsSeparatedByString:@" "];
    
    int r = arc4random() % [lorumIpsumArray count];
    r = MAX(6, r); // no less than 6 words
    NSArray *lorumIpsumRandom = [lorumIpsumArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, r)]];
    
    return [NSString stringWithFormat:@"%@!!", [lorumIpsumRandom componentsJoinedByString:@" "]];
}

- (NSString *)getImageStr:(NSInteger)index{
    NSArray *array = @[@"http://www.120ask.com/static/upload/clinic/article/org/201311/201311061651418413.jpg",
                       @"http://p1.qqyou.com/touxiang/uploadpic/2011-3/20113212244659712.jpg",
                       @"http://www.qqzhi.com/uploadpic/2014-09-14/004638238.jpg",
                       @"http://e.hiphotos.baidu.com/image/pic/item/5ab5c9ea15ce36d3b104443639f33a87e950b1b0.jpg",
                       @"http://ts1.mm.bing.net/th?&id=JN.C21iqVw9uSuD2ZyxElpacA&w=300&h=300&c=0&pid=1.9&rs=0&p=0",
                       @"http://ts1.mm.bing.net/th?&id=JN.7g7SEYKd2MTNono6zVirpA&w=300&h=300&c=0&pid=1.9&rs=0&p=0"];
    return array[index];
}

- (NSString *)getName:(NSInteger)index{
    NSArray *array = @[@"Hi,Daniel",@"Hi,Juey",@"Hey,Jobs",@"Hey,Bob",@"Hah,Dane",@"Wow,Boss"];
    return array[index];
}
@end
