//
//  XMPPSupportClass.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface XMPPSupportClass : NSObject

{
    
//    XMPPStream *xmppStream;
    NSString *password;  //密码
    BOOL isOpen;  //xmppStream是否开着
    
}

@property (nonatomic,strong) XMPPStream *xmppStream;

//单实例化
+(XMPPSupportClass *)ShareInstance;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

@end
