//
//  FindOthersViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactPersonDetailViewController.h"
#import "NewFriendNoticeViewController.h"
#import "ContactNewsViewController.h"
#import "AddFriendByButtonViewController.h"
#import "ContactGroupViewController.h"

@interface FindOthersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) IBOutlet UITableView *contactsTableview;
@property (nonatomic,strong) UIView *navigationBar;

//@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end
