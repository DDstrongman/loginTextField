//
//  SimilarFriendViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrangerViewController.h"

@interface SimilarFriendViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>


@property (nonatomic,strong) IBOutlet UITableView *similarFriendTable;

@end
