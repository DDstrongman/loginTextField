//
//  ContactPersonDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemOne.h"
#import "ReportTableViewController.h"

@interface ContactPersonDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) ItemOne *allInfo;//传输过来的用户信息
@property (nonatomic,strong) IBOutlet UITableView *contactPersonTable;//查看和设置的tableview

@property (nonatomic,strong) NSString *personJID;//好友的jid

@end
