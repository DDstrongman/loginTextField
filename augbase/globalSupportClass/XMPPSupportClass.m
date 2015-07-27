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

-(void)setupStream{
    
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    
}

-(void)goOnline{
    
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
    
}

-(void)goOffline{
    
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
    
}

-(BOOL)connect{
    
    [self setupStream];
    
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [defaults stringForKey:@"USERID"];
    NSString *pass = [defaults stringForKey:@"PASS"];
    NSString *server = [defaults stringForKey:@"SERVER"];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (userId == nil || pass == nil) {
        return NO;
    }
    
    //设置用户
    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    //设置服务器
    [xmppStream setHostName:server];
    //密码
    password = pass;
    
    //连接服务器
    NSError *error = nil;
//    [xmppStream connectWithTimeout:<#(NSTimeInterval)#> error:<#(NSError *__autoreleasing *)#>]
    if (![xmppStream connectWithTimeout:30.0 error:&error]) {
        NSLog(@"cant connect %@", server);
        return NO;
    }
    
    return YES;
    
}

-(void)disconnect{
    
    [self goOffline];
    [xmppStream disconnect];
    
}

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    isOpen = YES;
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:password error:&error];
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self goOnline];
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    //    NSLog(@"message = %@", message);
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    //消息接收到的时间
//    [dict setObject:[Statics getCurrentTime] forKey:@"time"];
    
    //消息委托(这个后面讲)
//    [messageDelegate newMessageReceived:dict];
    
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    //    NSLog(@"presence = %@", presence);
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            //用户列表委托(后面讲)
//            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
//            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
        }
        
    }
    
}

#pragma 旧版本易诊的xmppDelegate
-(void)setNewxmppstream:(NSString *)uesrname{
    //delegate
    
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    if (![self.xmppStream isConnected]) {
        
        [self.xmppStream setMyJID:[XMPPJID jidWithString:uesrname]];
        //设置服务器
        //本地
        //        [self.xmppStream  setHostName:@"jiapeixindemacbook-pro.local"];
        [self.xmppStream  setHostName:@"115.29.143.102"];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:100 error:&error]) {
        }
    }
    
}
//
//-(void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error{
//    
//}
//
//#pragma mark-发送失败
//-(void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error{
//    if (self.sendfailure) {
//        tmpobj.sendsuccess=@"0";
//        self.sendfailure(tmpobj);
//        
//    }
//}
//#pragma mark-发送消息 ****带img
//- (void)sendMessage:(NSString *) message toUser:(NSString *) user andimagename:(NSString *)imgname andnickname:(NSString *)nickname andjid:(NSString *)jid andchatobj:(ChatObj *)obj{
//    
//    tmpobj=obj;
//    
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    NSXMLElement *timemodel = [NSXMLElement elementWithName:@"timemodel"];
//    NSXMLElement *imgmodel = [NSXMLElement elementWithName:@"imgmodel"];
//    NSXMLElement *nicknamemodel = [NSXMLElement elementWithName:@"nicknamemodel"];
//    NSXMLElement *jidmodel = [NSXMLElement elementWithName:@"jidmodel"];
//    
//    NSXMLElement *message2 = [NSXMLElement elementWithName:@"message"];
//    
//    //  NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
//    //    NSXMLElement *newdata = [NSXMLElement elementWithName:@"newdata"];
//    //    [newdata setStringValue:@"image"];
//    [body setStringValue:message];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currenttime  = [dateFormatter stringFromDate:[NSDate date]];
//    [timemodel setStringValue:currenttime];
//    [imgmodel setStringValue:imgname];
//    [nicknamemodel setStringValue:nickname];
//    [jidmodel setStringValue:jid];
//    
//    
//    
//    [message2 addAttributeWithName:@"type" stringValue:@"chat"];
//    NSString *to = [NSString stringWithFormat:@"%@@115.29.143.102", user];
//    [message2 addAttributeWithName:@"to" stringValue:to];
//    [message2 addChild:body];
//    [message2 addChild:timemodel];
//    [message2 addChild:imgmodel];
//    
//    [message2 addChild:nicknamemodel];
//    [message2 addChild:jidmodel];
//    
//    //   [message2 addChild:newdata];
//    [self.xmppStream sendElement:message2];
//    ;
//    
//    //创建数据库
//    
//    //表名
//    NSString *ttname=[NSString stringWithFormat:@"myfriend%@",[UIDTOKEN getme].myjid];
//    
//    if ([UIDTOKEN getme].myjid!=nil) {
//        
//    }
//    
//    NSString *ss=NSHomeDirectory();
//    
//    
//    [[MyFriendsDB getfriendsdb] creatDatabase:[UIDTOKEN getme].frienddbname];
//    [[MyFriendsDB getfriendsdb].yzdcdb open];
//    Friend *f=[[Friend alloc] init];
//    f.jid=user;
//    //开始检测对方是否在线
//    FMResultSet *rs = [[MyFriendsDB getfriendsdb] checkfriendableview:f andtableviename:ttname];
//    BOOL sendapns=0;
//    if (rs==nil) {
//        //发送apns
//        sendapns=1;
//    }
//    else{
//        NSString *jid=[rs stringForColumn:@"jid"];
//        NSString *mystate=[rs stringForColumn:@"mystate"];
//        if (jid==nil) {
//            //发送apns
//            sendapns=1;
//        }
//        else{
//            if ([mystate isEqualToString:@"0"]) {
//                //发送apns
//                sendapns=1;
//            }
//            else{
//                sendapns=0;
//            }
//        }
//    }
//    if (sendapns==1) {
//        //发送apns
//        SendApns *sss=[[SendApns alloc] init];
//        sss.msgtype=@"0";//文字
//        sss.msg=obj.mycontent;
//        sss.sendtime=obj.creattime;
//        [self sendapns:sss andtouser:user];
//    }
//    else {
//    }
//    [rs close];
//    
//    
//    
//    if (self.sendmessageblock) {
//        self.sendmessageblock(0,message,nil);
//        self.sendmessageblock=nil;
//    }
//    
//    
//}
//- (void)ImagesendMessage:(NSString *) message toUser:(NSString *) user andimagename:(NSString *)imgname andnickname:(NSString *)nickname andjid:(NSString *)jid andchatobj:(ChatObj *)obj
//{
//    tmpobj=obj;
//    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
//    NSXMLElement *message2 = [NSXMLElement elementWithName:@"message"];
//    NSXMLElement *newdata = [NSXMLElement elementWithName:@"newdata"];
//    [newdata setStringValue:@"image"];
//    [body setStringValue:message];
//    NSXMLElement *timemodel = [NSXMLElement elementWithName:@"timemodel"];
//    NSXMLElement *imgmodel = [NSXMLElement elementWithName:@"imgmodel"];
//    NSXMLElement *nicknamemodel = [NSXMLElement elementWithName:@"nicknamemodel"];
//    NSXMLElement *jidmodel = [NSXMLElement elementWithName:@"jidmodel"];
//    [nicknamemodel setStringValue:nickname];
//    [jidmodel setStringValue:jid];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currenttime  = [dateFormatter stringFromDate:[NSDate date]];
//    [timemodel setStringValue:currenttime];
//    [imgmodel setStringValue:imgname];
//    [message2 addAttributeWithName:@"type" stringValue:@"chat"];
//    NSString *to = [NSString stringWithFormat:@"%@@115.29.143.102", user];
//    [message2 addAttributeWithName:@"to" stringValue:to];
//    [message2 addChild:body];
//    [message2 addChild:newdata];
//    [message2 addChild:timemodel];
//    [message2 addChild:imgmodel];
//    [message2 addChild:nicknamemodel];
//    [message2 addChild:jidmodel];
//    [self.xmppStream sendElement:message2];
//    NSString *ttname=[NSString stringWithFormat:@"myfriend%@",[UIDTOKEN getme].myjid];
//    if ([UIDTOKEN getme].myjid==nil) {
//    }
//    [[MyFriendsDB getfriendsdb] creatDatabase:[UIDTOKEN getme].frienddbname];
//    [[MyFriendsDB getfriendsdb].yzdcdb open];
//    Friend *f=[[Friend alloc] init];
//    f.jid=user;
//    //开始检测对方是否在线
//    FMResultSet *rs = [[MyFriendsDB getfriendsdb] checkfriendableview:f andtableviename:ttname];
//    BOOL sendapns=0;
//    if (rs==nil) {
//        //发送apns
//        sendapns=1;
//    }
//    else{
//        NSString *jid=[rs stringForColumn:@"jid"];
//        NSString *mystate=[rs stringForColumn:@"mystate"];
//        if (jid==nil) {
//            //发送apns
//            sendapns=1;
//        }
//        else{
//            if ([mystate isEqualToString:@"0"]) {
//                //发送apns
//                sendapns=1;
//                
//            }
//            else{
//                sendapns=0;
//                
//            }
//        }
//    }
//    
//    if (sendapns==1) {
//        //发送apns
//        SendApns *sss=[[SendApns alloc] init];
//        sss.msgtype=@"1";//图片
//        sss.msg=obj.mycontent;
//        sss.sendtime=obj.creattime;
//        [self sendapns:sss andtouser:user];
//    }
//    else {
//        
//    }
//    
//    
//    
//    
//    if (self.sendmessageblock) {
//        self.sendmessageblock(2,message,self.senddata);
//        
//        self.sendmessageblock=nil;
//    }
//    
//    
//}
//
//
//#pragma mark-接受消息 &&&&&&&&&^^^^^^^^^^^@@@@@@@@@!!!!!!!!!!!!!!***
//- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
//    
//    NSString *creattime = [[message elementForName:@"timemodel"] stringValue];
//    NSString *currentDateStr=creattime;
//    NSString *messageBody = [[message elementForName:@"body"] stringValue];
//    NSString *from = [[message attributeForName:@"from"] stringValue];
//    NSString *newdata = [[message elementForName:@"newdata"] stringValue];
//    NSString *imgname = [[message elementForName:@"imgname"] stringValue];
//    NSString *nickname = [[message elementForName:@"nicknamemodel"] stringValue];
//    NSString *jid = [[message elementForName:@"jidmodel"] stringValue];
//    int key=0;
//    if ([newdata isEqualToString:@"image"]) {
//        key=2;
//    }
//    else if ([newdata isEqualToString:@"sound"]){
//        key=1;
//    }
//    else {
//        key=0;
//    }
//    /************************************************************/
//    //表名
//    //[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid]
//    [[DBManager getdb] creatDatabase:[UIDTOKEN getme].dbname];
//    
//    [[DBManager getdb].yzdcdb open];
//    [[DBManager getdb] creatDianTablename:[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid]];
//    FMResultSet *rs=[[DBManager getdb] checkfriendableview:jid andtableviename:[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid]];
//    BOOL display=NO;
//    if (rs==nil) {
//        display=YES;
//    }
//    else{
//        NSString *jid=[rs stringForColumn:@"dcjid"];
//        if (jid==nil) {
//            display=YES;
//        }
//        else {
//            display=NO;
//        }
//    }
//    /************************************************************/
//    
//    //在其他界面是需要推送 且是自己
//    if ([[UIDTOKEN getme].currentChat isEqualToString:@"1"] &&[[[NSUserDefaults standardUserDefaults] objectForKey:@"xxxxxji"] isEqualToString:jid] ) {
//        //再聊天界面 不做推送和 保存
//    }
//    else{
//        if (nickname==nil) {
//        }
//        else{
//            if (display==YES) {
//                //add
//                [rs close];
//                InterObj *ii=[[InterObj alloc] init];
//                ii.jid=jid;
//                ii.nickname=nickname;
//                [[DBManager getdb] creatDatabase:[UIDTOKEN getme].dbname];
//                [[DBManager getdb].yzdcdb open];
//                [[DBManager getdb] creatDianTablename:[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid]];
//                [[DBManager getdb] addinterobjTablename:[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid] andinterobj:ii];
//            }
//            else{
//                //更新
//                InterObj *ii=[[InterObj alloc] init];
//                ii.jid=[rs stringForColumn:@"dcjid"];
//                ii.nickname=nickname;
//                NSString *num=[rs stringForColumn:@"chatnum"];
//                NSString *newnum=[NSString stringWithFormat:@"%d",[num intValue]+1];
//                [[DBManager getdb] updateinterobjTablename:[NSString stringWithFormat:@"Ddiandian%@",[UIDTOKEN getme].uid] andinterobj:ii andnum:newnum];
//                [rs close];
//                
//                
//            }
//            //推送给其他界面
//            if (self.reloadlately) {
//                self.reloadlately(1);
//                
//            }
//        }
//        
//        
//    }
//    
//    
//    if (self.getmessageblock) {
//        self.getmessageblock(key,messageBody,nil,currentDateStr,imgname,nickname,jid);
//    }
//    
//}
//-(void)disimageview{
//    [imageView removeFromSuperview];
//    
//}
//
//#pragma mark-登录验证失败
//- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
//    NSNotification *notification=[NSNotification notificationWithName:KLOGINFAILURE object:self userInfo:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//    
//}
//- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
//    if (error!=nil) {
//        //网络连接超时
//        NSNotification *notification=[NSNotification notificationWithName:KLOGINFAILURE object:self userInfo:nil];
//        [[NSNotificationCenter defaultCenter]postNotification:notification];
//    }
//    
//    
//}
//#pragma mark-验证身份 回调
//- (void)xmppStreamDidConnect:(XMPPStream *)sender {
//    NSError *error = nil;
//    if (![self.xmppStream authenticateWithPassword:self.password error:&error]) {
//        //验证失败
//        NSNotification *notification=[NSNotification notificationWithName:KLOGINFAILURE object:self userInfo:nil];
//        [[NSNotificationCenter defaultCenter]postNotification:notification];
//    }
//    
//    else{
//        
//    }
//    
//}
//#pragma mark-  好友在线状态
//- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
//    NSString *presenceFromUser = [[presence from] user];
//    //收到好友请求也调用
//    NSString *presenceType = [presence type];
//    //available
//    [MyFriendsDB getfriendsdb];
//    NSString *ttname=[NSString stringWithFormat:@"myfriend%@",[UIDTOKEN getme].myjid];
//    if ([UIDTOKEN getme].myjid!=nil) {
//    }
//    [[MyFriendsDB getfriendsdb] creatDatabase:[UIDTOKEN getme].frienddbname];
//    [[MyFriendsDB getfriendsdb].yzdcdb open];
//    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
//        [[MyFriendsDB getfriendsdb].yzdcdb open];
//        NSString *kk=@"0";
//        if ([presenceType isEqualToString:@"available"]) {
//            //更改
//            kk=@"1";
//        } else if ([presenceType isEqualToString:@"unavailable"]) {
//            //更新
//            kk=@"0";
//        }
//        //准备插入数据
//        //查询是否存在
//        Friend *f=[[Friend alloc] init];
//        f.mystate=kk;
//        f.jid=presenceFromUser;
//        //插入
//        FMResultSet *rs = [[MyFriendsDB getfriendsdb] checkfriendableview:f andtableviename:ttname];
//        if (rs==nil) {
//            [rs close];
//            //更改
//            [[MyFriendsDB getfriendsdb] addFriendTablename:ttname andchatobj:f];
//            
//        }
//        else{
//            //更新
//            [rs close];
//            [[MyFriendsDB getfriendsdb] updateFriendTablename:ttname andchatobj:f];
//            
//        }
//        
//    }
//    else{
//        
//    }
//    
//    
//    
//    
//}
//
//#pragma mark-断开连接
//- (void)disconnect {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
//    [self.xmppStream sendElement:presence];
//    [self.xmppStream disconnect];
//}
//#pragma mark-上线
//- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
//    //已经登陆
//    [self goline];
//    
//}
//-(void)goline{
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
//    [self.xmppStream sendElement:presence];
//    //登录成功
//    NSNotification *notification=[NSNotification notificationWithName:KLOGINSUCCESS object:self userInfo:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//    // [self getMyQueryRoster];
//    
//}
//-(void)getMyQueryRoster{
//    
//    self.myfriendnames=[NSMutableArray arrayWithCapacity:10];
//    NSError *error = [[NSError alloc] init];
//    
//    NSXMLElement *query = [[NSXMLElement alloc] initWithXMLString:@"<query xmlns='jabber:iq:roster'/>"error:&error];
//    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
//    XMPPJID *myJID = self.xmppStream.myJID;
//    [iq addAttributeWithName:@"from" stringValue:myJID.description];
//    //本地
//    //    [iq addAttributeWithName:@"to" stringValue:@"admin@jiapeixindemacbook-pro.local"];
//    [iq addAttributeWithName:@"to" stringValue:@"admin@115.29.143.102"];
//    [iq addAttributeWithName:@"id" stringValue:@"friends"];
//    [iq addAttributeWithName:@"type" stringValue:@"get"];
//    [iq addChild:query];
//    if (error==nil) {
//    }
//    else{
//    }
//    NSError *kk=error;
//    [self.xmppStream sendElement:iq];
//}
//- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
//{
//    [self.myfriendnames removeAllObjects];
//    if ([@"result" isEqualToString:iq.type]) {
//        NSXMLElement *query = iq.childElement;
//        if ([@"query" isEqualToString:query.name]) {
//            NSArray *items = [query children];
//            for (NSXMLElement *item in items) {
//                NSString *jid = [item attributeStringValueForName:@"jid"];
//                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
//                NSString *name=xmppJID.description;
//                NSRange range=[name rangeOfString:@"@"];
//                if (range.location !=NSNotFound) {
//                    name=[name substringToIndex:range.location];
//                    
//                }
//                [self.myfriendnames addObject:name];
//                
//                //全部好友
//                //    [self.mydatas addObject:name];
//            }}}
//    
//    //发送通知
//    NSNotification *notification=[NSNotification notificationWithName:Kffffffffff object:self userInfo:nil];
//    [[NSNotificationCenter defaultCenter]postNotification:notification];
//    
//    if (self.myrload) {
//        self.myrload(1);
//        
//    }
//    return YES;
//}
//-(void)dissalert:(UIAlertView *)alert{
//    [alert dismissWithClickedButtonIndex:0 animated:YES];
//}
//-(NSString *)gettime{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //设定时间格式,这里可以设置成自己需要的格式
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *strUrl = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    NSString *strUrl2 = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *newdate=strUrl2;
//    newdate=[NSString stringWithFormat:@"%d%@%d",arc4random()%100,newdate,arc4random()%100];
//    return newdate;
//}
//
//#pragma mark-发送图片和语音
//-(void)sendImage:(UIImage *)image andsendMessage:(NSString *) message toUser:(NSString *) user andimgname:(NSString *)newimgname andnickname:(NSString *)nickname andjid:(NSString *)jid andchatobj:(ChatObj *)obj{
//    tmpobj=obj;
//    
//    
//    //上传高清图
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    NSString *yzuid=[UIDTOKEN getme].uid;
//    NSString *yztoken=[UIDTOKEN getme].token;
//    if (yztoken==nil) {
//        yzuid=@"2";
//        yztoken=@"890836ff8accec9d8aa01dca54280060";
//        
//    }
//    
//    //http://192.168.1.106:8080/YizhenServer3/
//    //   NSString *url=[NSString stringWithFormat:@"http://api.augbase.com/YizhenServer3/chat/sendPhoto"];
//    NSDictionary *ddd= @{@"1":@"2"};
//    NSString *url=[NSString stringWithFormat:@"http://api.augbase.com/YizhenServer4/chat/sendphoto"];
//    
//    NSString *ii=[NSString stringWithFormat:@"%@.png",message];
//    
//    //192.168.1.107:8080/YizhenServer3/
//    // NSString *url=[NSString stringWithFormat:@"http://192.168.1.103:8080/YizhenServer3/chat/sendphoto"];
//    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[yzuid,yztoken,ii,[UIDTOKEN getme].myjid] forKeys:@[@"uid",@"token",@"name",@"ji"]];
//    NSData *data=UIImageJPEGRepresentation(image, 0.35);
//    [manager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"image" fileName:message mimeType:@"png"];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        int res=[[dic objectForKey:@"res"] intValue];
//        if (res==0) {
//            [self ImagesendMessage:message toUser:user andimagename:newimgname andnickname:nickname andjid:jid andchatobj:tmpobj];
//            
//        }
//        else{
//            if (self.sendfailure) {
//                tmpobj.sendsuccess=@"0";
//                self.sendfailure(tmpobj);
//                
//            }
//        }
//        
//        
//        
//        
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (self.sendfailure) {
//            tmpobj.sendsuccess=@"0";
//            self.sendfailure(tmpobj);
//            
//        }
//        
//        
//    }];
//    
//    
//    
//    
//}
//
//-(void)sendMp3:(NSData *)mp3 andsendMessage:(NSString *) message toUser:(NSString *) user{
//    
//}
//
//-(void)addfriend:(NSString *)keyjid{
//    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    xmppReconnect=[[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    [xmppReconnect activate:self.xmppStream];
//    xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:[MyXmppManage standXmppmanage].xmppRosterDataStorage ];
//    [xmppRoster removeDelegate:self delegateQueue:dispatch_get_main_queue()];
//    xmppRoster.autoFetchRoster = YES;
//    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
//    [xmppRoster activate:self.xmppStream];
//    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",keyjid,@"115.29.143.102"]];
//    // [presence addAttributeWithName:@"subscription" stringValue:@"好友"];
//    //发送好友请求
//    [xmppRoster subscribePresenceToUser:jid];
//}
//#pragma mark-发送离线消息 ——————————————————————————————————
//-(void)sendapns:(SendApns *)sendobj andtouser:(NSString *)sendname{
//    NSString *url = [NSString stringWithFormat:@"%@chat/sendofflinemsg",Baseurl];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setTimeoutInterval:100];
//    NSString *pppid;
//    NSString *kkkkkk=[NSString stringWithFormat:@"%@-%@",[UIDTOKEN getme].myjid,sendname];
//    pppid=[[NSUserDefaults standardUserDefaults] objectForKey:kkkkkk];
//    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&clienttype=%@&clientid=%@&msgtype=%@&msg=%@&sendtime=%@",url,[UIDTOKEN getme].uid,[UIDTOKEN getme].token,@"1",pppid,sendobj.msgtype,sendobj.msg,sendobj.sendtime];
//    NSMutableDictionary *dcic=[NSMutableDictionary dictionary];
//    uurl=[uurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if (pppid!=NULL) {
//        [manager POST:uurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            int res=[[source objectForKey:@"res"] intValue];
//            if (res==0) {
//                //离线消息发送成功
//                
//            }
//            else if (res==15){
//                
//            }
//            else{
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self networkAnomaly];
//        }];
//    }
//    else{
//        [self networkAnomaly];
//        
//    }
//    
//    
//    
//    
//    
//}
//-(void)networkAnomaly{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"出问题鸟" message:@"啦啦啦啦啦" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
//}
//-(void)creatsuccess:(NSString *)success{
//    [HUD hide:YES];
//    
//    HUD = [[MBProgressHUD alloc] initWithView:JWindow];
//    [JWindow addSubview:HUD];
//    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new勾.png"]];
//    HUD.mode = MBProgressHUDModeCustomView;
//    HUD.labelText = success;
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:1];
//    
//}
//-(void)creatfaile:(NSString *)success{
//    [HUD hide:YES];
//    
//    HUD = [[MBProgressHUD alloc] initWithView:JWindow];
//    [JWindow addSubview:HUD];
//    HUD.mode = MBProgressHUDModeText;
//    
//    HUD.labelText = success;
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:1];
//    
//}

@end

