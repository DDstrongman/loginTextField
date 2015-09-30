//
//  MyDoctorRootViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDoctorRootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *rightPlusButton;//右侧添加按钮,添加医生
@property (nonatomic,strong) UITableView *showDoctorMessTable;//显示医生的tableview

@end
