//
//  NewFriendNoticeViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFriendConfirmViewController.h"

@interface NewFriendNoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) IBOutlet UITableView *addFriendNotictTable;
//@property (nonatomic) BOOL confirmAddMessOrNot;//确定添加后的返回属性,NO则不管，yes则刷新table默认设为no；

@end
