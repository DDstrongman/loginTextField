//
//  MessNewsViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/31.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessNewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *newsTable;

@end
