//
//  ReportTableViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/14.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)IBOutlet UITableView *reportTable;

@end
