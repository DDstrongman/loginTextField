//
//  FriendsSetViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/4.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsSetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)UITableView *setFriendTable;//查看和设置的tableview

@property (nonatomic,strong)NSString *friendJID;

@end
