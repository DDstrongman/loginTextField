//
//  AddFriendConfirmViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewFriendNoticeViewController.h"

@interface AddFriendConfirmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *confirmInfoTable;


@property (nonatomic,strong) NSString *personJid;


@end
