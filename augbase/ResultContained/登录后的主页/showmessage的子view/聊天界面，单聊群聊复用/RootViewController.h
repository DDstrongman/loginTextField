//
//  RootViewController.h
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootPrivateInfoViewController.h"
#import "StrangerViewController.h"
#import "GroupDetailViewController.h"

#import "XMPPSupportClass.h"
#import "DBItem.h"

@interface RootViewController : UIViewController<ReceiveMessDelegate>

@property (nonatomic) BOOL privateOrNot;//0,私聊；1，群聊.

@property (nonatomic,strong) NSString *personJID;//选择的对象的jid,好友的jid。


@end
