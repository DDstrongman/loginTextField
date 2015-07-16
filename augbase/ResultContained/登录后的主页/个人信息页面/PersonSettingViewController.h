//
//  PersonSettingViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *settingTable;

@end
