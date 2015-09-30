//
//  XMPPSupportClass.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//



#import <Foundation/Foundation.h>

#import "DBItem.h"

#import "XMPP.h"
#import "XMPPMUC.h"
#import "XMPPReconnect.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import <XMPPRoom.h>
#import <XMPPRoomMemoryStorage.h>
#import <XMPPRoomCoreDataStorage.h>

#import "DBManager.h"
#import "DBGroupManager.h"
#import "FriendDBManager.h"
#import "ChatSupportItem.h"

@protocol ReceiveMessDelegate <NSObject>

@required//必须实现的代理方法

-(void)ReceiveMessArray:(NSString *)receiveJID ChatItem:(DBItem *)chatItem;//传递收到的消息，用类作为array中元素，具体类包含信息查看chatsupportitem.h
@optional//不必须实现的代理方法

@end

@protocol ConnectXMPPDelegate <NSObject>
@required
-(void)ConnectXMPPResult:(BOOL)result;//xmpp服务器连接成功

@end

@protocol GetFriendListDelegate <NSObject>
@required
-(void)GetFriendListDelegate:(BOOL)result;//xmpp服务器连接成功

@end

@protocol GroupMemberListDelegate <NSObject>
@required
-(void)GroupMemberList:(NSMutableArray *)result;//获取群用户

@end

@interface XMPPSupportClass : NSObject

{
//    XMPPStream *xmppStream;
    NSString *password;  //密码,均为123456
    BOOL isOpen;  //xmppStream是否开着
    
    XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
    XMPPRoom *xmppRoom;//聊天室
}

@property (nonatomic,weak)  id<ReceiveMessDelegate> receiveMessDelegate;
@property (nonatomic,weak)  id<ConnectXMPPDelegate> connectXMPPDelegate;
@property (nonatomic,weak)  id<GetFriendListDelegate> getFriendListDelegate;
@property (nonatomic,weak)  id<GroupMemberListDelegate> groupMemberListDelegate;

@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPRosterCoreDataStorage  *xmppRosterDataStorage;

//单实例化
+(XMPPSupportClass *)ShareInstance;

//是否连接
-(void)connect:(NSString *)userName;//用用户名和Server拼接的jid名
-(BOOL)boolConnect:(NSString *)userName;//获得是否连接的bool值
//断开连接
-(void)disconnect;
//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;
//发送文字图片，音频等信息 MessType  0:文字  1:图片 2:音频;发送群消息和私聊消息共用一个，发送群消息即发送给群jid的消息
-(BOOL)sendMess:(DBItem *)allContents toUserJID:(NSString *)friendUserJid FromUserJID:(NSString *)myJID;
//发送音频图片信息的时候上传服务器之后返回url，发送url文本信息过去
-(NSString *)uploadPic:(UIImage *)image;
-(NSString *)uploadMP3:(NSData *)mp3;

@property (nonatomic,strong) NSMutableArray *messArray;

//获取好友列表
-(void)getMyQueryRoster;
//添加好友
-(void)addfriend:(NSString *)keyjid;
-(void)confirmAddFriend:(NSString *)addJID;
//删除好友
-(void)removeFriend:(NSString *)friendJID;
//初始化聊天室
-(void)setUpChatRoom:(NSString *)ROOM_JID NickName:(NSString *)nickName;

-(void)leaveChatRoom:(NSString *)ROOM_JID;

-(void)inviteFriendToChatRoom:(NSString *)friendJID Message:(NSString *)message;

@end
