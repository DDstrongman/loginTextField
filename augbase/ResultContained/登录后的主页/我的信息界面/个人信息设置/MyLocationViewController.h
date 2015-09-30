//
//  MyLocationViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/9.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLocationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *locationTable;

@property (nonatomic,weak) UIViewController *popViewController;//提供跳转桥梁的vc

@end
