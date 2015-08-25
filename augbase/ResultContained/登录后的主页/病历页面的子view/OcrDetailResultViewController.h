//
//  OcrDetailResultViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SListView.h"
#import "SListViewCell.h"

@interface OcrDetailResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SListViewDelegate, SListViewDataSource>

@property (nonatomic,strong )UITableView *nameTable;

@property (nonatomic,strong )UITableView *firstResultTable;
@property (nonatomic,strong )UITableView *secondResultTable;
@property (nonatomic,strong )UITableView *thirdesultTable;

@property (nonatomic,strong )UIButton *firstButton;
@property (nonatomic,strong )UIButton *secondButton;
@property (nonatomic,strong )UIButton *thirdButton;

@property (nonatomic,strong)UIButton *titleButton;

@property (nonatomic,strong )SListView *titleTable;
@property (nonatomic,strong )SListView *resultTable;

@end
