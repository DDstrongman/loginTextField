//
//  HttpSupportClass.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/30.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpSupportClass : NSObject

//单实例化
+(HttpSupportClass *)ShareInstance;

//http,post,get方法的快捷支持
#pragma afnetworking第三方类库支持
-(void)httpAFPostSupport:(NSString *)url Contents:(NSDictionary *)content;
-(void)httpAFGetSupport:(NSString *)url;
#pragma 原生nsurl,nsrequest,nsconnection支持,id的content可以改为自己想要的数据类型,只使用异步操作，同步有卵用，需要自己写到主线程；
-(void)httpNSPostSupport:(NSString *)url Contents:(id *)content TimeOut:(NSInteger)timeOut;
-(void)httpNSGetSupport:(NSString *)url TimeOut:(NSInteger)timeOut;

@end

