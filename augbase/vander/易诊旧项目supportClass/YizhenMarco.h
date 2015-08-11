//
//  YizhenMarco.h
//  Yizhen2
//
//  Created by Jpxin on 14-6-9.
//  Copyright (c) 2014年 Augbase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDTOKEN.h"
#import "SplitLineView.h"
#import "MBProgressHUD.h"
#import "Toast+UIView.h"
#import "UIButton+EnlargeArea.h"

@interface YizhenMarco : NSObject
//#define Baseurl
//http://192.168.1.100:8080/YizhenServer_V2/
//url
//@"http://192.168.1.104:8080/YizhenServer_V2/"
//    liu
//@"http://192.168.1.103:8080/YizhenServer_V2/"
//@"http://api.augbase.com/yiserver/"
//@"http://192.168.1.104:8080/YizhenServer_V2/"
//@"http://192.168.1.105:8080/YizhenServer2/"
//@"" //提交版本
//@"http://192.168.0.118:8080/YizhenServer2/"

//192.168.1.109http://api.augbase.com/yiserver/
//@"http:/192.168.1.104:8080/YizhenServer2/"
//http://115.29.143.102:8080/YizhenServer4/测试xpp
//http://192.168.1.104:8080/YizhenServer4/


//@""  yuan
//http://115.28.0.79:8080/yiserver/
#define Baseurl @"http://api.augbase.com/yiserver/"
//@"http://115.29.143.102:8080/YizhenServer4/" ceshi
//#define Baseurl @"http://api.augbase.com/yiserver/"  12.29

//#define Baseurl @"http://api.augbase.com/yiserver/"
//http://115.29.143.102:8080/YizhenServer4/
//115.29.143.102:8080    @"http://api.augbase.com/yiserver/"
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define UserD  [NSUserDefaults standardUserDefaults]
#define Jframe(x, y, w, h) initWithFrame:CGRectMake(x, y, w, h)
#define JNormal UIControlStateNormal
#define JAction UIControlEventTouchUpInside
#define JaddAction(key,method)[key addTarget:self action:@selector(method) forControlEvents:JAction];
#define OldTime 60*60*24*30
#define NavigationBar_HEIGHT 64
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//定义UIImage对象  默认未png的时候
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:@"png"]]
#define JWindow [UIApplication sharedApplication].keyWindow

#define colorText [UIColor colorWithRed:58.0/255 green:180.0/255 blue:167.0/255 alpha:1]

#define colorRGBA1 [UIColor colorWithRed:58.0/255 green:180.0/255 blue:167.0/255 alpha:1]

#define colorRGBB9 [UIColor colorWithRed:0.0/255 green:120.0/255 blue:255.0/255 alpha:1]
#define colorRGBA4 [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]

#define colorRGBB5 [UIColor colorWithRed:247.0/255 green:128.0/255 blue:96.0/255 alpha:1]

//BUtton  米黄
#define colorRGBA8 [UIColor colorWithRed:244.0/255 green:242.0/255 blue:229.0/255 alpha:1]
//colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1
#define colorRGBA3 [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1]
#define colorRGBA5 [UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1]
//colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1
#define colorRGBA9 [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]
#define colorRGBA10 [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1]
#define colorRGBA11 [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]
//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


#define compress 0.5



//黄
#define Roundcolor1 [UIColor colorWithRed:243/255.0 green:220/255.0 blue:63/255.0 alpha:1]
//红色
#define Roundcolor2 [UIColor colorWithRed:247/255.0 green:101/255.0 blue:78/255.0 alpha:1]
//橘色
#define Roundcolor3 [UIColor colorWithRed:248/255.0 green:169/255.0 blue:91/255.0 alpha:1]
//蓝色
#define Roundcolor4 [UIColor colorWithRed:0/255.0 green:185/255.0 blue:235/255.0 alpha:1]
//绿色
#define Roundcolor5 [UIColor colorWithRed:58/255.0 green:180/255.0 blue:167/255.0 alpha:1]

//一些通知
#define KCalendarheightchange @"Calendar height change"
#define KgetH frame.size.width
#define JVersion [[UIDevice currentDevice].systemVersion floatValue]


#define KVersion @"kversion"
#define KCrema @"StartKCrema"




//更换block
#define KCHangeblock  @"KCHangeblock"
#define KForegroundlogin @"KForegroundlogin"
//进入后台
#define Kbackgroundupdate @"Kbackgroundupdate"

//获取好友
#define Kffffffffff @"Kfffff"

//更新inter
#define KinterUpdat @"KinterUpdat"

#define KTabbarheightchange1  @"KTabbarheightchange1"
#define KTabbarheightchange2  @"KTabbarheightchange2"
#define KTabbarheightchange3  @"KTabbarheightchange3"
#define KTabbarheightchange4  @"KTabbarheightchange4"
#define KTabbarheightchange100  @"KTabbarheightchange100"


#define KLOGINSUCCESS  @"Kloginsuccess"
#define KLOGINFAILURE  @"Kloginfailure"


#define KLOGINXMPP @"Kloginxmpp"

@end
