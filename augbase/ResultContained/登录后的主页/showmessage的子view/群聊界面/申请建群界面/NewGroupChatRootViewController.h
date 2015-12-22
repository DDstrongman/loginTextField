//
//  AskForNewGroupChatViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/12/1.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGroupChatRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *applyNewGroupTable;

@end
