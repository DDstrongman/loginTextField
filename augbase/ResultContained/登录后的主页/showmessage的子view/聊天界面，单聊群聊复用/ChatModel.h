//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ChatSupportItem.h"

#import "WriteFileSupport.h"

@interface ChatModel : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

@property (nonatomic,strong) UIViewController *rootNavC;

-(void)addCellFromDB:(NSString *)userJID MessNumber:(NSInteger)messNumbe;

@end
