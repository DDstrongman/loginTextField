//
//  ViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Shadow.h"

@interface OcrTextResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong )IBOutlet UITableView *nameTable;

@property (nonatomic,strong) UIButton *firstTitleButton;
@property (nonatomic,strong) UIButton *secondTitleButton;
@property (nonatomic,strong) UIButton *thirdTitleButton;
@property (nonatomic,strong) UIButton *forthTitleButton;
@property (nonatomic,strong) UIButton *fifthTitleButton;
@property (nonatomic,strong) UIButton *sixthTitleButton;
@property (nonatomic,strong) UIButton *sevenTitleButton;
@property (nonatomic,strong) UIButton *eightTitleButton;
@property (nonatomic,strong) UIButton *nineTitleButton;
@property (nonatomic,strong) UIButton *tenthTitleButton;
@property (nonatomic,strong) UIButton *elevenTitleButton;
@property (nonatomic,strong) UIButton *twelveTitleButton;

@property (nonatomic,strong) UITableView *firstResultTable;
@property (nonatomic,strong) UITableView *secondResultTable;
@property (nonatomic,strong) UITableView *thirdsultTable;
@property (nonatomic,strong) UITableView *forthsultTable;
@property (nonatomic,strong) UITableView *fifthsultTable;
@property (nonatomic,strong) UITableView *sixthsultTable;
@property (nonatomic,strong) UITableView *sevensultTable;
@property (nonatomic,strong) UITableView *eightsultTable;
@property (nonatomic,strong) UITableView *ninesultTable;
@property (nonatomic,strong) UITableView *tensultTable;
@property (nonatomic,strong) UITableView *elevensultTable;


@property (nonatomic,strong) IBOutlet UIButton *titleButton;

@property (nonatomic,strong )UIScrollView *titleScroller;
@property (nonatomic,strong )UIScrollView *resultScroller;


@property (nonatomic) BOOL isMine;//是否是自己的大表结果
@property (nonatomic,strong) NSString *personJID;//查询其他患者的jid

@property (nonatomic) BOOL isReView;//是否是预览图
@property (nonatomic,strong) NSArray *viewedTitleArray;//预览的title
@property (nonatomic,strong) NSArray *viewedTimeArray;//预览的时间点


@property (nonatomic,assign) NSInteger newResNumber;//新的数据读入数目

@end

