//
//  RootViewController.h
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "GroupDetailViewController.h"

#import "ChatModel.h"
#import "DBItem.h"
#import "WriteFileSupport.h"
@interface RootViewController : UIViewController<ReceiveMessDelegate>

@property (nonatomic) BOOL privateOrNot;//0,私聊；1，群聊.

@property (nonatomic,strong) NSString *personJID;//选择的对象的jid,好友的jid。
@property (nonatomic,strong) NSString *personName;//选择对象的名字.


@end
