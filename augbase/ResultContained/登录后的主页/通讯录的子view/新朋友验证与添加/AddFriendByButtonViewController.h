//
//  AddFriendByButtonViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearByFriendViewController.h"
#import "SimilarFriendViewController.h"

@interface AddFriendByButtonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *addWaysTable;

@end
