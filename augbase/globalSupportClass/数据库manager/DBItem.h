//
//  DBItem.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/29.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBItem : NSObject

//InsertObject,数据库保存的主要信息
#pragma 新的设计,主要用于数据库中保存收到的信息，用户不需要区分是否最后一次传输或是状态，因为是类似微信的收发信息的im工具,每个用户私聊和每个群的群聊都使用一个table来分装
#pragma 私聊
#warning 此处的UID是否需要需要慎重考虑
//@property (nonatomic,strong) NSString *personUID;//person Web端的uid

//person xmpp端的JID,xmpp服务器类似uid的东西，唯一区分用户
@property (nonatomic,strong) NSString *personJID;
@property (nonatomic,strong) NSString *sendPersonJID;
#warning 此处的账户名是否需要需要慎重考虑
//@property (nonatomic,strong) NSString *personName;

//昵称,在第一次登录和我的中设定
@property (nonatomic,strong) NSString *personNickName;
//用户头像的url
@property (nonatomic,strong) NSString *personImageUrl;

#pragma 两个表共有
//时间标签
@property (nonatomic,strong) NSString *timeStamp;
//消息的内容，text为文本信息，其他的如图片或者音频则为url
@property (nonatomic,strong) NSString *messContent;

//聊天分类，区分是私聊还是群聊:0私聊，1群聊
@property (nonatomic,assign) NSInteger chatType;
//消息分类，区分是文本还是url,0（no）为文本，1（yes）为picture,2为音频
@property (nonatomic,assign) NSInteger messType;
//判断是否已读,1(yes),读过，0(no)，没读过
@property (nonatomic,assign) NSInteger ReadOrNot;
//判断是自己发的还是其他人，0(no)，是自己，1(yes)，不是
@property (nonatomic,assign) NSInteger FromMeOrNot;

#pragma 群聊表
#warning 此处的UID是否需要需要慎重考虑
//@property (nonatomic,assign) NSString *chatUID;
@property (nonatomic,strong) NSString *chatJID;
@property (nonatomic,strong) NSString *chatNickName;//群昵称
@property (nonatomic,strong) NSString *chatImageUrl;//群头像的url

//#pragma 易诊旧信息
//@property (nonatomic,strong)NSString *lasttime;
//@property (nonatomic,strong)NSString *mycontect;
//@property (nonatomic,assign)NSInteger chattype;
//@property (nonatomic,assign)NSInteger lastchatype;
//@property (nonatomic,strong)NSString *isnew;
//@property (nonatomic,strong)NSString *nickname;
//@property (nonatomic,strong)NSString *imgname;
//@property (nonatomic,strong)NSString *jid;
//@property (nonatomic,strong)NSString *mystate;


@end
