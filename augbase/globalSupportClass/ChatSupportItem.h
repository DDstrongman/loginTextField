//
//  ChatSupportItem.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/29.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatSupportItem : NSObject
//ChatObj
@property (nonatomic,strong)NSString *sendsuccess;
@property (nonatomic,strong)NSString *chatid;
@property (nonatomic,strong)NSString *displaytime;
@property (nonatomic,strong)NSString *mycontent;//秒数 宽高 大小
@property (nonatomic,strong)NSString *creattime;
@property (nonatomic,assign)NSInteger mytype;//消息类型 0文字 1语音 2图片
@property (nonatomic,assign)BOOL isme;//谁发的
@property (nonatomic,strong)NSData *mydata;//数据文件
@property (nonatomic,strong)NSString *mydataname;//数据文件
@property (nonatomic,strong)NSString *messContent;//消息内容

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)initWithCoder:(NSCoder *)aDecoder;

@end
