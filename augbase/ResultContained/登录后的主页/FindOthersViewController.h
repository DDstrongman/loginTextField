//
//  FindOthersViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContactPersonDetailViewController.h"

@interface FindOthersViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic,strong) IBOutlet UITableView *contactsTableview;

//@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;

@end
