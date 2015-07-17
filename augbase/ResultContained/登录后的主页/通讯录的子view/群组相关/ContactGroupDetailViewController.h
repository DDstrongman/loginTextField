//
//  ContactGroupDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactGroupDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) IBOutlet UITableView *contactGroupDetailTable;

@end
