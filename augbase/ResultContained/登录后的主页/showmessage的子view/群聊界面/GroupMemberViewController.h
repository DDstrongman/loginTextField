//
//  GroupMemberViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SendAddMessViewController.h"

@interface GroupMemberViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) IBOutlet UITableView *memberTable;



@end
