//
//  ContactGroupViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactGroupDetailViewController.h"

@interface ContactGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) IBOutlet UITableView *contactGroupTable;

@end
