//
//  ShowAllMessageViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "MessTableViewCell.h"

#import "RootViewController.h"
#import "ChooseGroupViewController.h"

#import "WriteFileSupport.h"

@interface ShowAllMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,ReceiveMessDelegate,ConnectXMPPDelegate,GetFriendListDelegate>

@property (nonatomic,strong) IBOutlet UITableView *messageTableview;

@end
