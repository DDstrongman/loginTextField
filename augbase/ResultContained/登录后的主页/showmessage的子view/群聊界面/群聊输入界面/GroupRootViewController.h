//
//  RootViewController.h
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactPersonDetailViewController.h"
#import "GroupDetailViewController.h"

#import "GroupChatModel.h"
#import "DBItem.h"
#import "WriteFileSupport.h"

@interface GroupRootViewController : UIViewController<ReceiveMessDelegate,FlushTableDelegate>

@property (nonatomic,strong) NSString *groupTitle;//群名
@property (nonatomic,strong) NSString *groupJID;//群号
@property (nonatomic,strong) NSString *groupNote;//群描述

@end
