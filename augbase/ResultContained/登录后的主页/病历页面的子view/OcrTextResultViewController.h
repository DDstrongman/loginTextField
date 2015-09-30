//
//  ViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Shadow.h"

@interface OcrTextResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong )IBOutlet UITableView *nameTable;

@property (nonatomic,strong) IBOutlet UIButton *firstTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *secondTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *thirdTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *forthTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *fifthTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *sixthTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *sevenTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *eightTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *nineTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *tenthTitleButton;
@property (nonatomic,strong) IBOutlet UIButton *elevenTitleButton;

@property (nonatomic,strong )UITableView *firstResultTable;
@property (nonatomic,strong )UITableView *secondResultTable;
@property (nonatomic,strong )UITableView *thirdsultTable;
@property (nonatomic,strong )UITableView *forthsultTable;
@property (nonatomic,strong )UITableView *fifthsultTable;
@property (nonatomic,strong )UITableView *sixthsultTable;
@property (nonatomic,strong )UITableView *sevensultTable;
@property (nonatomic,strong )UITableView *eightsultTable;
@property (nonatomic,strong )UITableView *ninesultTable;
@property (nonatomic,strong )UITableView *tensultTable;
@property (nonatomic,strong )UITableView *elevensultTable;


@property (nonatomic,strong) IBOutlet UIButton *titleButton;

@property (nonatomic,strong )IBOutlet UIScrollView *titleScroller;
@property (nonatomic,strong )IBOutlet UIScrollView *resultScroller;


@property (nonatomic) BOOL isMine;//是否是自己的大表结果
@property (nonatomic,strong) NSString *personJID;//查询其他患者的jid


@end

