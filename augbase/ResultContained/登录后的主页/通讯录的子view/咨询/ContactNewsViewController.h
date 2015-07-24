//
//  ContactNewsViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactNewsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) IBOutlet UITableView *newsTable;
@property (nonatomic) BOOL followOrNot;//关注与否，网络获取,yes为已关注，no为没有关注
@property (nonatomic) NSInteger contactNumber;//公众号总数，网络获取


@end
