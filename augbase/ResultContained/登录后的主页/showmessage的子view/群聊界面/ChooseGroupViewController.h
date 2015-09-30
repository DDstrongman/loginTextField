//
//  ChooseGroupViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessTableViewCell.h"
#import "GroupRootViewController.h"

@interface ChooseGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,ReceiveMessDelegate>

@property (nonatomic,strong) UITableView *groupTable;
@property (nonatomic,strong) UISearchBar *searchGroup;

@end
