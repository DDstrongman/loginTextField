//
//  ContactGroupMemberDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/21.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactGroupMemberDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property (nonatomic,strong) IBOutlet UITableView *contactGroupMemberDetailTable;

@end
