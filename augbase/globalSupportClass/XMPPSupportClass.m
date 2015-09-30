//
//  XMPPSupportClass.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "XMPPSupportClass.h"

#import "WriteFileSupport.h"

@implementation XMPPSupportClass

@synthesize xmppStream;

#pragma xmppsupport单实例初始化
+(XMPPSupportClass *) ShareInstance;{
    static XMPPSupportClass *sharedXMPPManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedXMPPManagerInstance = [[self alloc] init];
    });
    return sharedXMPPManagerInstance;
}

//初始化XMPPStream
-(void)setupStream{
    if (xmppStream ==nil) {
        xmppStream = [[XMPPStream alloc] init];
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
}

-(void)goOnline{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [[self xmppStream] sendElement:presence];
    
}

-(void)goOffline{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)boolConnect:(NSString *)userName{
    NSLog(@"开始连接Bool");
    password = @"123456";//设定死的，为xmpp服务器的密码，用户密码为web端的
    isOpen = YES;
    [self setupStream];
    if ([xmppStream isConnected]) {
        return YES;
    }
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    //设置服务器
    [xmppStream setHostName:httpServer];
    //连接服务器
    NSError *error = nil;
    [xmppStream connectWithTimeout:20.0 error:&error];
    if (error) {
        NSLog(@"can't connect %@", httpServer);
        return NO;
    }
    return YES;
}

- (void)connect:(NSString *)userName{
    password = @"123456";
    isOpen = YES;
    NSLog(@"开始连接");
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    if (![self.xmppStream isConnected]) {
        XMPPJID *jid = [XMPPJID jidWithString:userName];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:httpServer];
        NSLog(@"jid===%@",jid);
        NSError *error = nil;
        if (![xmppStream connectWithTimeout:20.0 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        }
    }
}

#pragma mark-断开连接
-(void)disconnect{
    NSLog(@"断开连接");
    [self goOffline];
    [xmppStream disconnect];
    isOpen = YES;
}

#pragma 设定时间内连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"登录验证");
    NSError *error = nil;
    //验证密码
    if (isOpen) {
        [[self xmppStream] authenticateWithPassword:password error:&error];
        isOpen = NO;
    }
}

#pragma 连接超时
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    if (error!=nil) {
        NSLog(@"登录超时");
    }
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self goOnline];
    NSLog(@"登录成功");
    [_connectXMPPDelegate ConnectXMPPResult:YES];
}

#pragma mark-登录验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"登录失败");
    [_connectXMPPDelegate ConnectXMPPResult:NO];
}

#pragma mark-接受消息，接收消息后需要加一个noticifacation或者delegate来提醒消息界面刷新
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    _messArray = [NSMutableArray array];
    [_messArray removeAllObjects];
    NSString *messContent = [[message elementForName:@"body"]stringValue];//发送内容的主题必须是body，xmpp需求
    NSString *messTime = [[message elementForName:@"messTime"]stringValue];
    NSString *timeStamp = [[message elementForName:@"timeStamp"]stringValue];
    NSString *personJID = [[message elementForName:@"personJID"]stringValue];
    NSString *toPersonJID = [[message elementForName:@"toPersonJID"]stringValue];
    NSString *personNickName = [[message elementForName:@"personNickName"]stringValue];
    NSString *personImageUrl = [[message elementForName:@"personImageUrl"]stringValue];
    NSString *chatType = [[message elementForName:@"chatType"]stringValue];
    NSString *messType = [[message elementForName:@"messType"]stringValue];
    
//    NSString *ReadOrNot = [[message elementForName:@"ReadOrNot"]stringValue];
//    NSString *FromMeOrNot = [[message elementForName:@"FromMeOrNot"]stringValue];
    
    DBItem *chatItem = [[DBItem alloc]init];
    chatItem.messContent = messContent;
    chatItem.messVoiceTime = messTime;
    chatItem.timeStamp = timeStamp;
    chatItem.personJID = personJID;
    chatItem.toPersonJID = toPersonJID;
    chatItem.personNickName = personNickName;
    chatItem.personImageUrl = personImageUrl;
    
    chatItem.chatType = [chatType intValue];
    chatItem.messType = [messType intValue];
    
    chatItem.FromMeOrNot = 1;
    chatItem.ReadOrNot = 0;
    
    if (chatItem.chatType == 0) {
        [[DBManager ShareInstance] creatDatabase:DBName];
        [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,personJID]];
        [[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,personJID] andchatobj:chatItem];
        [[DBManager ShareInstance] closeDB];
    }else{
        if ([personJID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"]]) {
            
        }else{
            [[DBGroupManager ShareInstance] creatDatabase:GroupChatDBName];
            [[DBGroupManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,toPersonJID]];
            [[DBGroupManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,toPersonJID] andchatobj:chatItem];
            [[DBGroupManager ShareInstance] closeDB];
        }
    }
    
    [_receiveMessDelegate ReceiveMessArray:personJID ChatItem:chatItem];
}

#pragma mark-  好友在线状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"获取好友状态:%@",presence);
    NSString *presenceFromUser = [[presence from] user];
    //收到好友请求也调用
    NSString *presenceType = [presence type];
    //available
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
    [[FriendDBManager ShareInstance] isFriendTableExist:StrangerTBName];
    if ([presenceType isEqualToString:@"available"]) {
        [[FriendDBManager ShareInstance] updateFriendState:YizhenFriendName FriendJid:presenceFromUser andState:@"1"];
    }else if ([presenceType isEqualToString:@"subscribe"]){
        FriendDBItem *fItem = [[FriendDBItem alloc]init];
        fItem.friendJID = presenceFromUser;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,presenceFromUser,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
        jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *friendInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            fItem.friendAge = [[friendInfo objectForKey:@"age"] stringValue];
            fItem.friendGender = [[friendInfo objectForKey:@"gender"] stringValue];
            fItem.friendName = [friendInfo objectForKey:@"nickname"];
            NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[friendInfo objectForKey:@"picture"]];
            imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer=[AFHTTPRequestSerializer serializer];
            [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:presenceFromUser Contents:responseObject];
                fItem.friendImageUrl = [NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,presenceFromUser];
                fItem.friendOnlineOrNot = @"2";
                [[FriendDBManager ShareInstance]addFriendObjTablename:StrangerTBName andchatobj:fItem];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取图片信息失败");
            }];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取jid信息失败");
        }];
    }else{
        [[FriendDBManager ShareInstance] updateFriendState:YizhenFriendName FriendJid:presenceFromUser andState:@"0"];
    }
}

-(void)confirmAddFriend:(NSString *)addJID{
    if (_xmppRosterDataStorage == nil) {
        _xmppRosterDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    }
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppReconnect=[[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [xmppReconnect activate:self.xmppStream];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterDataStorage];
    [xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [xmppRoster activate:self.xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",addJID,httpServer]];
    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    [[FriendDBManager ShareInstance]deleteFriendObjTablename:StrangerTBName andinterobj:addJID];
    [self getMyQueryRoster];
}

#pragma 发送状态失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
    NSLog(@"发送状态失败");
}

#pragma 新版本发送文本类型的消息delegate，发送音频文件等则将message转为文件上传中转网站后的url即可。其中0为text，1为图片，2为语音
-(BOOL)sendMess:(DBItem *)allContents toUserJID:(NSString *)friendUserJid FromUserJID:(NSString *)myJID{
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];//发送内容的主题必须是body，xmpp需求
    NSXMLElement *timeStamp = [NSXMLElement elementWithName:@"timeStamp"];
    NSXMLElement *personJID = [NSXMLElement elementWithName:@"personJID"];
    NSXMLElement *toPersonJID = [NSXMLElement elementWithName:@"toPersonJID"];
    NSXMLElement *personNickName = [NSXMLElement elementWithName:@"personNickName"];
    NSXMLElement *personImageUrl = [NSXMLElement elementWithName:@"personImageUrl"];
    NSXMLElement *chatType = [NSXMLElement elementWithName:@"chatType"];
    NSXMLElement *messType = [NSXMLElement elementWithName:@"messType"];
    NSXMLElement *ReadOrNot = [NSXMLElement elementWithName:@"ReadOrNot"];
    NSXMLElement *FromMeOrNot = [NSXMLElement elementWithName:@"FromMeOrNot"];
    NSXMLElement *messTime = [NSXMLElement elementWithName:@"messTime"];
    
    if (allContents.messType == 1) {
#warning 在这里要加入delegate刷新，因为获取图片使用了多线程，无法直接return获取必要信息，暂时测试用其他代替
        allContents.messContent = [self uploadPic:allContents.messPic];
    }else if(allContents.messType == 2){
        allContents.messContent = [self uploadMP3:allContents.messVoice];
    }
    
    [body setStringValue:allContents.messContent];
    [personJID setStringValue:allContents.personJID];
    [toPersonJID setStringValue:allContents.toPersonJID];
    [timeStamp setStringValue:allContents.timeStamp];
    [personNickName setStringValue:allContents.personNickName];
    [personImageUrl setStringValue:allContents.personImageUrl];
    [messTime setStringValue:allContents.messVoiceTime];
    
    [messType setStringValue:[NSString stringWithFormat:@"%ld",(long)allContents.messType]];//文本信息
    [chatType setStringValue:[NSString stringWithFormat:@"%ld",(long)allContents.chatType]];//私聊
    
    [FromMeOrNot setStringValue:@"0"];
    [ReadOrNot setStringValue:@"1"];
    
    NSXMLElement *TextMessage = [NSXMLElement elementWithName:@"message"];//发送消息的最外层xml，必须是message。xmpp的要求
    if (allContents.chatType == 0) {
        [TextMessage addAttributeWithName:@"type" stringValue:@"chat"];
    }else{
        [TextMessage addAttributeWithName:@"type" stringValue:@"groupchat"];
    }
    NSString *to;
    if (allContents.chatType == 0) {
        to = [NSString stringWithFormat:@"%@@%@",friendUserJid,httpServer];
    }else{
        to = [NSString stringWithFormat:@"%@@%@.%@",friendUserJid,@"conference",httpServer];
    }
    [TextMessage addAttributeWithName:@"to" stringValue:to];
    [TextMessage addChild:body];
    [TextMessage addChild:timeStamp];
    [TextMessage addChild:personJID];
    [TextMessage addChild:toPersonJID];
    [TextMessage addChild:personNickName];
    [TextMessage addChild:personImageUrl];
    [TextMessage addChild:chatType];
    [TextMessage addChild:messType];
    [TextMessage addChild:FromMeOrNot];
    [TextMessage addChild:ReadOrNot];
    [TextMessage addChild:messTime];
    
    [self.xmppStream sendElement:TextMessage];//发送在线信息
    
    
//    [self sendapns:allContents ToPerson:friendUserJid];
    if (allContents.chatType == 0) {
        [[DBManager ShareInstance] creatDatabase:DBName];
        [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid]];
        if ([[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid] andchatobj:allContents]) {
            [[DBManager ShareInstance] closeDB];
            return YES;
        }else{
            [[DBManager ShareInstance] closeDB];
            return NO;
        }
    }else{
        [[DBManager ShareInstance] creatDatabase:GroupChatDBName];
        [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid]];
        if ([[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid] andchatobj:allContents]) {
            [[DBManager ShareInstance] closeDB];
            return YES;
        }else{
            [[DBManager ShareInstance] closeDB];
            return NO;
        }
    }
}

#pragma mark-发送失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    if (error != nil) {
        NSLog(@"发送消息失败");
    }
}

#pragma 初始化聊天室创建或者加入
-(void)setUpChatRoom:(NSString *)ROOM_JID NickName:(NSString *)nickName{
    NSLog(@"创建聊天室");
//    XMPPRoomMemoryStorage * _roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    
    XMPPRoomCoreDataStorage *_roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    if (_roomMemory==nil) {
        _roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    }
    XMPPJID *roomJID = [XMPPJID jidWithString:ROOM_JID];
    
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_roomMemory jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [self setupStream];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    [xmppRoom configureRoomUsingOptions:nil];//修改聊天室信息
    [self configNewRoom:xmppRoom];
    NSXMLElement *chatHistory;
    
    [xmppRoom joinRoomUsingNickname:nickName history:chatHistory password:@""];
}

#pragma 初始化聊天室成功的delegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    NSLog(@"创建聊天室成功");
}

-(void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"加入聊天室成功");
    [xmppRoom fetchConfigurationForm];
//    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
//    [xmppRoom fetchModeratorsList];
//    [self inviteFriendToChatRoom:@"p21308@115.29.143.102" Message:@"test"];
}

-(void)leaveChatRoom:(NSString *)ROOM_JID{
    NSLog(@"离开聊天室");
    [xmppRoom deactivate];//离开聊天室
}

-(void)inviteFriendToChatRoom:(NSString *)friendJID Message:(NSString *)message{
    NSLog(@"发出群邀请");
    [xmppRoom inviteUser:[XMPPJID jidWithString:friendJID] withMessage:message];
}

-(void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message{
    NSLog(@"收到群邀请");
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm{
//    NSXMLElement *newConfig = [configForm copy];
//    
//    NSArray* fields = [newConfig elementsForName:@"field"];
//    
//    for (NSXMLElement *field in fields) {
//        
//        NSString *var = [field attributeStringValueForName:@"var"];
//        
//        if ([var isEqualToString:@"muc#roomconfig_openroom"]) {
//            
//            [field removeChildAtIndex:0];
//            
//            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
//            
//        }
//        
//    }
//    
//    [sender configureRoomUsingOptions:newConfig];
    
}

// 收到禁止名单列表
-(void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items{
    NSLog(@"收到禁止名单列表:%@",items);
}
// 收到好友名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items{
    NSLog(@"收到好友名单列表:%@",items);
}
// 收到主持人名单列表
- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items{
    NSLog(@"收到主持人名单列表:%@",items);
}
//房间不存在，调用委托
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError{
    NSLog(@"房间不存在，调用委托");
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError{
    NSLog(@"群信息获取失败");
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError{
    NSLog(@"群信息获取失败");
}
//其他delegate，离开聊天室
- (void)xmppRoomDidLeave:(XMPPRoom *)sender{
    NSLog(@"离开聊天室");
}
//新人入群
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSLog(@"新人入群");
    NSString *jid = occupantJID.user;
    NSString *domain = occupantJID.domain;
    NSString *resource = occupantJID.resource;
    NSString *presenceType = [presence type];
    NSString *userId = [sender myRoomJID].user;
    NSString *presenceFromUser = [[presence from] user];
    
    NSLog(@"在线用户：%@-jid=%@,domain=%@,resource=%@,当前用户:%@ ,出席用户:%@,presenceType:%@",occupantJID,jid,domain,resource,userId,presenceFromUser,presenceType);
    
    
//    if (![presenceFromUser isEqualToString:userId]) {
//        //对收到的用户的在线状态的判断在线状态
//        
//        //在线用户
//        if ([presenceType isEqualToString:@"available"]) {
//            NSString *buddy = [NSString stringWithFormat:@"%@@%@", presenceFromUser, @"1"];
//            //            [chatDelegate newBuddyOnline:buddy];//用户列表委托
//        }
//        
//        //用户下线
//        else if ([presenceType isEqualToString:@"unavailable"]) {
//            //            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, OpenFireHostName]];//用户列表委托
//        }
//    }
}
//有人退出
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSLog(@"有人退出");
    NSString *jid = occupantJID.user;
    NSString *domain = occupantJID.domain;
    NSString *resource = occupantJID.resource;
    NSString *presenceType = [presence type];
    NSString *userId = [sender myRoomJID].user;
    NSString *presenceFromUser = [[presence from] user];
    NSLog(@"occupantDidLeave----jid=%@,domain=%@,resource=%@,当前用户:%@ ,出席用户:%@,presenceType:%@",jid,domain,resource,userId,presenceFromUser,presenceType);
}

//房间人员加入
-(void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence{
    NSString *jid = occupantJID.user;
    NSString *domain = occupantJID.domain;
    NSString *resource = occupantJID.resource;
    NSString *presenceType = [presence type];
    NSString *userId = [sender myRoomJID].user;
    NSString *presenceFromUser = [[presence from] user];
    NSLog(@"occupantDidUpdate----jid=%@,domain=%@,resource=%@,当前用户:%@ ,出席用户:%@,presenceType:%@",jid,domain,resource,userId,presenceFromUser,presenceType);
}

//有人群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
    
}

#pragma 上传图片和音频，并返回url
-(NSString *)uploadPic:(UIImage *)image{
    NSString *yzuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"];
    NSString *yztoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *uurl=[NSString stringWithFormat:@"%@v2/chat/historymsg/multipart?uid=%@&token=%@&fileType=%@",Baseurl,yzuid,yztoken,@"png"];
    //得到图片的data
    NSData *data= UIImageJPEGRepresentation(image , compress);
    
    NSData *received =  [[HttpManager ShareInstance] httpPostSupport:uurl PostName:data FileType:@"image/png" FileTrail:@"pic"];
    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
    NSString *fileName = [source objectForKey:@"fileName"];
    return fileName;
}

-(NSString *)uploadMP3:(NSData *)mp3{
    NSString *yzuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"];
    NSString *yztoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *uurl=[NSString stringWithFormat:@"%@v2/chat/historymsg/multipart?uid=%@&token=%@&fileType=%@",Baseurl,yzuid,yztoken,@"mp3"];
   
    NSData *received =  [[HttpManager ShareInstance] httpPostSupport:uurl PostName:mp3 FileType:@"video/mp4" FileTrail:@"mp3"];
    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
    NSString *fileName = [source objectForKey:@"fileName"];
    return fileName;
}

#pragma 获取好友列表
-(void)getMyQueryRoster{
    NSLog(@"获取好友列表");
    //    self.myfriendnames=[NSMutableArray arrayWithCapacity:10];
    NSError *error = [[NSError alloc] init];
    
    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    //本地
    //    [iq addAttributeWithName:@"to" stringValue:@"admin@jiapeixindemacbook-pro.local"];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"admin@%@",httpServer]];
    [iq addAttributeWithName:@"id" stringValue:@"friends"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    if (error==nil) {
        
    }
    else{
        
    }
    [self.xmppStream sendElement:iq];
}
//
-(void)addfriend:(NSString *)keyjid{
    if (_xmppRosterDataStorage == nil) {
        _xmppRosterDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    }
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppReconnect=[[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [xmppReconnect activate:self.xmppStream];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterDataStorage];
    [xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [xmppRoster activate:self.xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",keyjid,httpServer]];
// [presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    //发送好友请求
    [xmppRoster subscribePresenceToUser:jid];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,keyjid,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            FriendDBItem *fdItem = [[FriendDBItem alloc]init];
            fdItem.friendName = [source objectForKey:@"nickname"];
            fdItem.friendGender = [source objectForKey:@"gender"];
            fdItem.friendAge = [source objectForKey:@"age"];
            fdItem.friendDescribe = @"test";
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            fdItem.friendImageUrl = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,yizhenImageFile,keyjid];
            fdItem.friendJID = keyjid;
            fdItem.friendOnlineOrNot = @"0";
            [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
            [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
            [[FriendDBManager ShareInstance] addFriendObjTablename:YizhenFriendName andchatobj:fdItem];
            
            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
            imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#warning 此处的获取好友头像可以变成lazyloading以便进一步优化效率
                [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:keyjid Contents:responseObject];
            }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"获取图片信息失败");
            }];
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败：%@",error);
    }];
}
#pragma mark 删除好友,取消加好友，或者加好友后需要删除
- (void)removeFriend:(NSString *)friendJID{
    if (_xmppRosterDataStorage == nil) {
        _xmppRosterDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    }
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppReconnect=[[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [xmppReconnect activate:self.xmppStream];
    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterDataStorage];
    [xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    [xmppRoster activate:self.xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendJID,httpServer]];
    [xmppRoster removeUser:jid];
    [[FriendDBManager ShareInstance] deleteFriendObjTablename:YizhenFriendName andinterobj:friendJID];
}

#pragma 好友请求列表,获取好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
#warning 这里的好友判断条件需要进一步优化，会加自己为好友
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                NSString *name = xmppJID.description;
                NSRange range = [name rangeOfString:@"@"];
                if (range.location != NSNotFound) {
                    name = [name substringToIndex:range.location];
                }
                NSLog(@"获取好友列表成功：jid===%@,name===%@",jid,name);
                [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
                [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                NSString *url = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,name,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    if (res == 0) {
                        FriendDBItem *fdItem = [[FriendDBItem alloc]init];
                        fdItem.friendName = [source objectForKey:@"nickname"];
                        fdItem.friendGender = [source objectForKey:@"gender"];
                        fdItem.friendAge = [source objectForKey:@"age"];
                        fdItem.friendDescribe = @"test";
                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentsDirectory = [paths objectAtIndex:0];
                        fdItem.friendImageUrl = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory,yizhenImageFile,name];
                        fdItem.friendJID = name;
                        fdItem.friendOnlineOrNot = @"0";
                        [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
                        [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
                        [[FriendDBManager ShareInstance] addFriendObjTablename:YizhenFriendName andchatobj:fdItem];
                        
                        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                        NSLog(@"imageurl === %@",imageurl);
                        imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                        [manager GET:imageurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
#warning 此处的获取好友头像可以变成lazyloading以便进一步优化效率
                            [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:name Contents:responseObject];
                            [_getFriendListDelegate GetFriendListDelegate:YES];
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"获取图片信息失败");
                            [_getFriendListDelegate GetFriendListDelegate:NO];
                        }];
                    }else{
                        [_getFriendListDelegate GetFriendListDelegate:NO];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"WEB端登录失败：%@",error);
                    [_getFriendListDelegate GetFriendListDelegate:NO];
                }];
            }
        }
    }
    return YES;
}

//- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    //取得好友状态
//    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
//    //请求的用户
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSLog(@"presenceType:%@",presenceType);
//    
//    NSLog(@"presence2:%@  sender2:%@",presence,sender);
//    
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    //接收添加好友请求
//    [xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
//    NSLog(@"接收到的好友添加请求===%@",jid);
//}

#pragma mark-发送离线消息 ——————————————————————————————————
-(void)sendapns:(DBItem *)messObj ToPerson:(NSString *)personJid{
    NSString *url = [NSString stringWithFormat:@"%@chat/sendofflinemsg",Baseurl];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&clienttype=%@&clientid=%@&msgtype=%ld&msg=%@&sendtime=%@",url,[userDefault valueForKey:@"userJID"],[userDefault valueForKey:@"userToken"],@"1",@"1686",(long)messObj.messType,messObj.messContent,messObj.timeStamp];
    NSLog(@"uurl===%@",uurl);
    NSLog(@"发送中文的方法"); 
    uurl=[uurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:uurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"离线消息返回:%@",source);
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res====%d",res);
        if (res==0) {
            //离线消息发送成功
            NSLog(@"离线消息发送成功");
        }
        else if (res==15){
            NSLog(@"离线消息发送出错");
        }
        else{
            NSLog(@"离线消息发送失败");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            [self networkAnomaly];
    }];
}

-(NSString *)gettime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *strUrl = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *newdate=[strUrl substringToIndex:8];
    return newdate;
    
}

#pragma 成功与失败的反应函数
-(void)creatsuccess:(NSString *)success{
    
}
    
-(void)creatfaile:(NSString *)success{
    
}

-(void)configNewRoom:(XMPPRoom *)xmppGroupRoom{
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    NSXMLElement *p;
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];//永久房间
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_maxusers"];//最大用户
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1000"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_changesubject"];//允许改变主题
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_openroom"];//公共房间
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    p = [NSXMLElement elementWithName:@"field" ];
    [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_allowinvites"];//允许邀请
    [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
    [x addChild:p];
    
    /*
     p = [NSXMLElement elementWithName:@"field" ];
     [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomname"];//房间名称
     [p addChild:[NSXMLElement elementWithName:@"value" stringValue:self.roomTitle]];
     [x addChild:p];
     
     p = [NSXMLElement elementWithName:@"field" ];
     [p addAttributeWithName:@"var" stringValue:@"muc#roomconfig_enablelogging"];//允许登录对话
     [p addChild:[NSXMLElement elementWithName:@"value" stringValue:@"0"]];
     [x addChild:p];
     */
    
    [xmppGroupRoom configureRoomUsingOptions:x];
}

@end

