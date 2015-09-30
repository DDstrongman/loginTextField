//
//  GroupDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GroupMemberViewController.h"

@interface GroupDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *groupTitle;//群名
@property (nonatomic,strong) NSString *groupJID;//群号
@property (nonatomic,strong) NSString *groupNote;//群描述

@property (nonatomic,strong) IBOutlet UITableView *groupTable;

@end
