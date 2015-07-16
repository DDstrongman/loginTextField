//
//  ViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Shadow.h"

#import "detailViewController.h"

#import "NameTableViewCell.h"
#import "DoubleNameTableViewCell.h"
#import "MoreNameTableViewCell.h"



//@interface NameTableView : UITableView
//
//@end

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong )IBOutlet UITableView *nameTable;
@property (nonatomic,strong )IBOutlet UITableView *firstResultTable;
@property (nonatomic,strong )IBOutlet UITableView *secondResultTable;
@property (nonatomic,strong )IBOutlet UITableView *thirdesultTable;


@property (nonatomic,strong) IBOutlet UIButton *titleButton;

@property (nonatomic,strong )IBOutlet UIScrollView *titleScroller;
@property (nonatomic,strong )IBOutlet UIScrollView *resultScroller;


@end

