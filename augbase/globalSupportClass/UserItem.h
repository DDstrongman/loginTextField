//
//  UserItem.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject
#pragma userDefault中将要留存的信息

@property (nonatomic,strong) NSString *ShowGuide;//是否显示引导页
@property (nonatomic,strong) NSString *NotFirstTime;//是否是第一次登陆
@property (nonatomic,strong) NSString *userUID;//user Web端的uid
@property (nonatomic,strong) NSString *userJID;//user xmpp端的JID,类似uid的东西，唯一区分用户
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *userPassword;
@property (nonatomic,strong) NSString *userToken;//token,之后快捷登录用
@property (nonatomic,strong) NSString *userNickName;//昵称,在第一次登录和我的中设定
@property (nonatomic,strong) NSString *userImageUrl;//用户头像的url
@property (nonatomic,strong) NSString *userAge;//用户年龄
@property (nonatomic,strong) NSString *userGender;//用户性别
@property (nonatomic,strong) NSString *userAddress;//用户个性签名
@property (nonatomic,strong) NSString *userNote;//用户个性签名

@property (nonatomic,strong) NSString *userTele;//用户手机号
@property (nonatomic,strong) NSString *userEmail;//用户邮箱号
@property (nonatomic,strong) NSString *userSystemVersion;//用户手机系统版本号
@property (nonatomic,strong) NSString *userPhone;//用户手机型号
@property (nonatomic,strong) NSString *userDeviceID;//用户手机ID

+(UserItem *) ShareInstance;

@end
