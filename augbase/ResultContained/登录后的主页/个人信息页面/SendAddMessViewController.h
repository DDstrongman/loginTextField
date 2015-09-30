//
//  SendAddMessViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SendAddMessViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *sendMessTable;

@property (nonatomic,strong) NSString *addFriendJID;//添加好友的jid

@end
