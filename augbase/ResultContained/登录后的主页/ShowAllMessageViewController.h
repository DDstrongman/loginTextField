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
#import "ShowWebviewViewController.h"


#import "HATransitionController.h"
#import "HACollectionViewSmallLayout.h"
#import "HASmallCollectionViewController.h"

#import "XMPPSupportClass.h"
#import "HttpSupportClass.h"

@interface ShowAllMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,HATransitionControllerDelegate,UINavigationControllerDelegate,ReceiveMessDelegate>

@property (nonatomic,strong) IBOutlet UITableView *messageTableview;

@property (nonatomic) HATransitionController *transitionController;

@end
