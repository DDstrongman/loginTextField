//
//  ChatModel.h
//  UUChatTableView
//
//  Created by shake on 15/1/6.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMPPSupportClass.h"
#import "ChatSupportItem.h"

#import "WriteFileSupport.h"

@protocol FlushTableDelegate <NSObject>

@required//必须实现的代理方法

-(void)FlushTable:(BOOL)result;//接收到图片或者语音之后通知聊天窗口刷新页面
@optional//不必须实现的代理方法

@end

@interface ChatModel : NSObject

@property (nonatomic,weak) id<FlushTableDelegate> flushTableDelegate;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) BOOL isGroupChat;

- (void)populateRandomDataSource:(NSMutableArray *)messMutableArray;

- (void)addRandomItemsToDataSource:(NSMutableArray *)messMutableArray;

- (void)addSpecifiedItem:(NSDictionary *)dic;
-(void)addCellFromDB:(NSString *)userJID;
//- (NSArray *)additems:(NSMutableArray *)messArray;

@end
