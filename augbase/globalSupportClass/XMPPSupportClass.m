//
//  XMPPSupportClass.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "XMPPSupportClass.h"



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
    password = @"123456";//设定死的，为xmpp服务器的密码，用户密码为web端的
    [self setupStream];
    if ([xmppStream isConnected]) {
        return YES;
    }
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    //设置服务器
    [xmppStream setHostName:httpServer];
    NSLog(@"httpServer === %@",httpServer);
    //连接服务器
    NSError *error = nil;
    [xmppStream connectWithTimeout:20.0 error:&error];
    NSLog(@"开始连接Bool");
    if (error) {
        NSLog(@"can't connect %@", httpServer);
        return NO;
    }
    return YES;
}

- (void)connect:(NSString *)userName{
    password = @"123456";
    NSLog(@"开始连接");
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];    }
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
}

#pragma 设定时间内连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"登录验证");
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:password error:&error];
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
    NSString *timeStamp = [[message elementForName:@"timeStamp"]stringValue];
    NSString *personJID = [[message elementForName:@"personJID"]stringValue];
    NSString *sendPersonJID = [[message elementForName:@"sendPersonJID"]stringValue];
    NSString *personNickName = [[message elementForName:@"personNickName"]stringValue];
    NSString *personImageUrl = [[message elementForName:@"personImageUrl"]stringValue];
    NSString *chatType = [[message elementForName:@"chatType"]stringValue];
    NSString *messType = [[message elementForName:@"messType"]stringValue];
    
//    NSString *ReadOrNot = [[message elementForName:@"ReadOrNot"]stringValue];
//    NSString *FromMeOrNot = [[message elementForName:@"FromMeOrNot"]stringValue];
    
    DBItem *chatItem = [[DBItem alloc]init];
    chatItem.messContent = messContent;
    chatItem.timeStamp = timeStamp;
    chatItem.personJID = personJID;
    chatItem.sendPersonJID = sendPersonJID;
    chatItem.personNickName = personNickName;
    chatItem.personImageUrl = personImageUrl;
    
    chatItem.chatType = [chatType intValue];
    chatItem.messType = [messType intValue];
    
    chatItem.FromMeOrNot = 1;
    chatItem.ReadOrNot = 0;
#warning 之后必须改为存入本地数据库，这样可以解决所有问题
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,sendPersonJID]];
    [[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,sendPersonJID] andchatobj:chatItem];
    [[DBManager ShareInstance] closeDB];
    [_receiveMessDelegate ReceiveMessArray:sendPersonJID];
}

#pragma mark-  好友在线状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"获取好友状态:%@",presence);
    NSString *presenceFromUser = [[presence from] user];
    //收到好友请求也调用
    NSString *presenceType = [presence type];
    //available
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    if ([presenceType isEqualToString:@"available"]) {
        [[FriendDBManager ShareInstance] updateFriendState:YizhenFriendName FriendJid:presenceFromUser andState:@"1"];
    }else{
        [[FriendDBManager ShareInstance] updateFriendState:YizhenFriendName FriendJid:presenceFromUser andState:@"0"];
    }
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
    NSXMLElement *sendPersonJID = [NSXMLElement elementWithName:@"sendPersonJID"];
    NSXMLElement *personNickName = [NSXMLElement elementWithName:@"personNickName"];
    NSXMLElement *personImageUrl = [NSXMLElement elementWithName:@"personImageUrl"];
    NSXMLElement *chatType = [NSXMLElement elementWithName:@"chatType"];
    NSXMLElement *messType = [NSXMLElement elementWithName:@"messType"];
//    NSXMLElement *messContent = [NSXMLElement elementWithName:@"messContent"];
    NSXMLElement *ReadOrNot = [NSXMLElement elementWithName:@"ReadOrNot"];
    NSXMLElement *FromMeOrNot = [NSXMLElement elementWithName:@"FromMeOrNot"];
    
    
    [body setStringValue:allContents.messContent];
    [personJID setStringValue:allContents.personJID];
    [sendPersonJID setStringValue:allContents.sendPersonJID];
    [timeStamp setStringValue:allContents.timeStamp];
    [personNickName setStringValue:allContents.personNickName];
    [personImageUrl setStringValue:allContents.personImageUrl];
    
    [messType setStringValue:[NSString stringWithFormat:@"%ld",(long)allContents.messType]];//文本信息
    [chatType setStringValue:[NSString stringWithFormat:@"%ld",(long)allContents.chatType]];//私聊
    
    [FromMeOrNot setStringValue:@"0"];
    [ReadOrNot setStringValue:@"1"];
    
    NSXMLElement *TextMessage = [NSXMLElement elementWithName:@"message"];//发送消息的最外层xml，必须是message。xmpp的要求
    [TextMessage addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@%@", friendUserJid,httpServer];
    [TextMessage addAttributeWithName:@"to" stringValue:to];
    [TextMessage addChild:body];
    [TextMessage addChild:timeStamp];
    [TextMessage addChild:personJID];
    [TextMessage addChild:sendPersonJID];
    [TextMessage addChild:personNickName];
    [TextMessage addChild:personImageUrl];
    [TextMessage addChild:chatType];
    [TextMessage addChild:messType];
    [TextMessage addChild:FromMeOrNot];
    [TextMessage addChild:ReadOrNot];
    [self.xmppStream sendElement:TextMessage];//发送在线信息
    NSLog(@"发送信息:%@",TextMessage);
    
    [self sendapns:allContents ToPerson:friendUserJid];
    
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid]];
    if ([[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,friendUserJid] andchatobj:allContents]) {
        [[DBManager ShareInstance] closeDB];
        return YES;
    }else{
        [[DBManager ShareInstance] closeDB];
        return NO;
    }
}

#pragma mark-发送失败
-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
    if (error != nil) {
        NSLog(@"发送消息失败");
    }
}

#pragma 初始化聊天室创建或者加入
-(void)setUpChatRoom:(NSString *)ROOM_JID{
    NSLog(@"创建聊天室");
//    XMPPRoomMemoryStorage * _roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    
    XMPPRoomCoreDataStorage *_roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    if (_roomMemory==nil) {
        _roomMemory = [[XMPPRoomCoreDataStorage alloc] init];
    }
    XMPPJID *roomJID = [XMPPJID jidWithString:ROOM_JID];
    
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_roomMemory jid:roomJID dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [xmppRoom configureRoomUsingOptions:nil];//修改聊天室信息
    
    [xmppRoom joinRoomUsingNickname:@"xx聊天室" history:nil password:@""];
}

#pragma 初始化聊天室成功的delegate
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    NSLog(@"创建聊天室成功");
//    [xmppRoom joinRoomUsingNickname:@"xx聊天室" history:nil password:@""];//加入聊天室
//    [xmppRoom deactivate:xmppStream];//离开聊天室
//    [xmppRoom deactivate];//离开聊天室
}

-(void)xmppRoomDidJoin:(XMPPRoom *)sender{
    NSLog(@"加入聊天室成功");
    [xmppRoom fetchConfigurationForm];
    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
    [xmppRoom fetchModeratorsList];
}

-(void)xmppRoomSendMess:(NSString *)roomJid ChatMess:(DBItem *)chatMess FromUser:(NSString *)userJid{
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:chatMess.messContent];
    
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"groupchat"];
    [message addAttributeWithName:@"to" stringValue:userJid];
    [message addChild:body];
    
    [self.xmppStream sendElement:message];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(DDXMLElement *)configForm

{
    
    NSLog(@"config : %@", configForm);
    
    NSXMLElement *newConfig = [configForm copy];
    
    NSArray* fields = [newConfig elementsForName:@"field"];
    
    for (NSXMLElement *field in fields) {
        
        NSString *var = [field attributeStringValueForName:@"var"];
        
        if ([var isEqualToString:@"muc#roomconfig_persistentroom"]) {
            
            [field removeChildAtIndex:0];
            
            [field addChild:[NSXMLElement elementWithName:@"value" stringValue:@"1"]];
            
        }
        
    }
    
    [sender configureRoomUsingOptions:newConfig];
    
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
- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID{
    NSLog(@"新人入群");
}
//有人退出
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID{
  NSLog(@"有人退出");
}
//有人群里发言
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID{
   NSLog(@"有人群里发言");
}

#pragma 上传图片和音频，并返回url
-(void)uploadPicture:(UIImage *)picture{
    //上传高清图
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *yzuid=[UIDTOKEN getme].uid;
    NSString *yztoken=[UIDTOKEN getme].token;
    if (yztoken==nil) {
        yzuid=@"2";
        yztoken=@"890836ff8accec9d8aa01dca54280060";
        
    }
    NSDictionary *ddd= @{@"1":@"2"};
    NSString *url=[NSString stringWithFormat:@"http://api.augbase.com/YizhenServer4/chat/sendphoto"];
    
    NSString *ii=[NSString stringWithFormat:@"%@.png",@"13"];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[yzuid,yztoken,ii,testMineJID
    ] forKeys:@[@"uid",@"token",@"name",@"ji"]];
    NSData *data = UIImageJPEGRepresentation(picture, 0.35);
    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"13" mimeType:@"png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int res=[[dic objectForKey:@"res"] intValue];
        NSLog(@"上传返回:%@",responseObject);
        if (res==0){
            NSLog(@"上传成功");
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
    }];
}

-(void)uploadMP3:(NSData *)mp3{
    
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
}
#pragma mark 删除好友,取消加好友，或者加好友后需要删除
- (void)removeFriend:(NSString *)friendJID
{
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
    
    NSString *url = [NSString stringWithFormat:@"%@chat/sendofflinemsg",Baseurl];
    NSLog(@"离线url===%@",url);
}

#pragma 好友请求列表,获取好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
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
                NSString *url = [NSString stringWithFormat:@"%@user?jid=%@",Baseurl,name];
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
                        fdItem.friendImageUrl = @"test";
                        fdItem.friendJID = name;
                        fdItem.friendOnlineOrNot = @"0";
#warning 加入存入数据库的代码，需要判断是否有重复的
                        [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
                        [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
                        [[FriendDBManager ShareInstance] addFriendObjTablename:YizhenFriendName andchatobj:fdItem];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"WEB端登录失败：%@",error);
                }];
            }
        }
    }
    return YES;
}

#pragma mark-发送离线消息 ——————————————————————————————————
-(void)sendapns:(DBItem *)messObj ToPerson:(NSString *)personJid{
    NSLog(@"发送离线消息");
    NSString *url = [NSString stringWithFormat:@"%@chat/sendofflinemsg",Baseurl];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:30];
#warning 此处之后要改为userDefault获取的自己的jid
    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&clienttype=%@&clientid=%@&msgtype=%ld&msg=%@&sendtime=%@",url,testMineJID,[userDefault valueForKey:@"UserToken"],@"1",@"1686",(long)messObj.messType,messObj.messContent,messObj.timeStamp];
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

#pragma 成功与失败的反应函数
-(void)creatsuccess:(NSString *)success{
    [HUD hide:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:JWindow];
    [JWindow addSubview:HUD];
#warning 此处可以加入图像
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = success;
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}
    
-(void)creatfaile:(NSString *)success{
    [HUD hide:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:JWindow];
    [JWindow addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    
    HUD.labelText = success;
    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}

@end

