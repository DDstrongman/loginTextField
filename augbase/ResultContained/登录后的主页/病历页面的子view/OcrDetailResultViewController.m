//
//  OcrDetailResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/12.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrDetailResultViewController.h"

#import "OcrDetailResultLabelButtonTableViewCell.h"
#import "OcrDetailResultLabelTableViewCell.h"

@interface OcrDetailResultViewController ()
    
{
    CGFloat cellHeight;
    UIImageView *tableTopImageView; //tableview之上显示的图片（向下拉动时）
    UIVisualEffectView *visualEffectView;
    
    BOOL offsetGoto; //判断拉到之后跳转
    NSMutableArray *bottomArray;//底部工具条的数据dataArray
    NSMutableArray *tableViewArray;//保存tableview的数组，实现缓存
    UIView *bottomMessView;//底部显示详细信息的view
    BOOL showMessView;//显示底部view与否的bool
    UITableView *bottomTable;//底部显示用的tableview
}

@end

@implementation OcrDetailResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化各个tableview和tableview顶上的uiimagview
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    _nameTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 66, 100, ViewHeight-66-49)];
    _nameTable.delegate = self;
    _nameTable.dataSource = self;
    _nameTable.showsVerticalScrollIndicator = NO;
    
    _firstResultTable.delegate = self;
    _firstResultTable.dataSource = self;
    _secondResultTable.delegate = self;
    _secondResultTable.dataSource = self;
    _thirdesultTable.delegate = self;
    _thirdesultTable.dataSource = self;
    
    //初始化两个scrollerview
    _titleTable = [[SListView alloc]initWithFrame:CGRectMake(100,0,ViewWidth-100,66)];
    _titleTable.backgroundColor = [UIColor blackColor];
    _titleTable.delegate = self;
    _titleTable.dataSource = self;
    [self.view addSubview:_titleTable];
    _resultTable = [[SListView alloc]initWithFrame:CGRectMake(100,66,ViewWidth-100,ViewHeight-66-49)];
    _resultTable.dataSource = self;
    _resultTable.delegate = self;
    _resultTable.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_resultTable];
    
    _titleTable.titleView = _titleTable.scrollView;
    _titleTable.resultView = _resultTable.scrollView;
    _resultTable.titleView = _titleTable.scrollView;
    _resultTable.resultView = _resultTable.scrollView;
    
    _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 66)];
    _titleButton.userInteractionEnabled = YES;
    _titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _titleButton.backgroundColor = [UIColor blackColor];
    [_titleButton setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
//    [_titleButton setTitle:@"test" forState:UIControlStateNormal];
//    [_titleButton makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
    [_titleButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nameTable];
    [self.view addSubview:_titleButton];

    [self setupBottomView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"nameLabelButtonCell";
    static NSString *resultIndentify = @"resultcell";
    if (tableView == _nameTable) {
        [_nameTable registerClass:[OcrDetailResultLabelButtonTableViewCell class]forCellReuseIdentifier:cellIndentify];
        OcrDetailResultLabelButtonTableViewCell *labelButtonCell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
        if (labelButtonCell == nil) {
            labelButtonCell = [[OcrDetailResultLabelButtonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        }
        labelButtonCell.timeLabel.text = @"14.08.11";
        labelButtonCell.medicalButton.backgroundColor = themeColor;
        [labelButtonCell makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
        return labelButtonCell;
    }else{
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resultIndentify];
        }
        if (tableView.tag == 100) {
            NSNumber *firstWidth;
            NSNumber *secondWidth;
            NSNumber *thirdWidth;
            UIButton *firstWeekButton = [[UIButton alloc]init];
            firstWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            firstWeekButton.backgroundColor = themeColor;
            [firstWeekButton setTitle:[@"1" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            //            [firstWeekButton sizeToFit];
            if(firstWeekButton.titleLabel.text.length == 2){
                firstWidth = [NSNumber numberWithInt:35];
            }else{
                firstWidth = [NSNumber numberWithInt:40];;
            }
            [cell addSubview:firstWeekButton];
            [firstWeekButton viewWithRadis:10.0];
            UIButton *secondWeekButton = [[UIButton alloc]init];
            secondWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            secondWeekButton.backgroundColor = themeColor;
            [secondWeekButton setTitle:[@"12" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            //            [secondWeekButton sizeToFit];
            if(secondWeekButton.titleLabel.text.length == 2){
                secondWidth = [NSNumber numberWithInt:35];
            }else{
                secondWidth = [NSNumber numberWithInt:40];;
            }
            
            [secondWeekButton viewWithRadis:10.0];
            [cell addSubview:secondWeekButton];
            UIButton *thirdWeekButton = [[UIButton alloc]init];
            thirdWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            thirdWeekButton.backgroundColor = themeColor;
            [thirdWeekButton setTitle:[@"31" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            //            [thirdWeekButton sizeToFit];
            if(thirdWeekButton.titleLabel.text.length == 2){
                thirdWidth = [NSNumber numberWithInt:35];
            }else{
                thirdWidth = [NSNumber numberWithInt:40];;
            }
            [thirdWeekButton viewWithRadis:10.0];
            [cell addSubview:thirdWeekButton];
            [firstWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@7.5);
                make.width.equalTo(firstWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [secondWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(firstWeekButton.mas_right).with.offset(5);
                make.width.equalTo(secondWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
            [thirdWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(secondWeekButton.mas_right).with.offset(5);
                make.width.equalTo(thirdWidth);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }else{
            UILabel *detailLabel = [[UILabel alloc]init];
            detailLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            detailLabel.font = [UIFont systemFontOfSize:14.0];
            detailLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(@3);
                make.right.bottom.equalTo(@-3);
            }];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initGesture:(UIView *)gesTureView
{
    UITapGestureRecognizer* doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
    doubleClick.numberOfTapsRequired = 2; // 双击
    [gesTureView addGestureRecognizer:doubleClick];
}

-(void)handleDoubleTapFrom:(UITapGestureRecognizer *)doubleTap
{
    NSLog(@"双击");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (UIView *tav in [self.view subviews]) {
        if ([tav isKindOfClass:[UITableView class]]) {
            NSLog(@"执行");
            ((UITableView *)tav).contentOffset = scrollView.contentOffset;
        }
    }
}

#pragma 仅仅移动的时候触发该delegate
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if(scrollView == _titleScroller|scrollView == _resultScroller){
//        if ((int)(scrollView.contentOffset.x) % 100 !=0) {
//            int tempNumber = (int)(scrollView.contentOffset.x)/100 + 1;
//            _titleScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//            _resultScroller.contentOffset = CGPointMake(tempNumber*100, scrollView.contentOffset.y);
//        }
//    }
//}

#pragma 有滚动的时候滚动完毕之后触发delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView{
   
}

#pragma 返回函数
-(void)popView:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 引入第三方横向复用cell的scrollerview
/**
 * @brief 共有多少列
 * @param listView 当前所在的ListView
 */
- (NSInteger) numberOfColumnsInListView:(SListView *) listView {
    return 10;
}

/**
 * @brief 这一列有多宽，根据有多宽，算出需要加载多少个
 * @param index  当前所在列
 */
- (CGFloat) widthForColumnAtIndex:(NSInteger) index {
    if (index == 0) {
        return 150;
    }else{
        return 100;
    }
}

/**
 * @brief 每列 显示什么
 * @param listView 当前所在的ListView
 * @param index  当前所在列
 * @return  当前所要展示的页
 */
- (SListViewCell *) listView:(SListView *)listView viewForColumnAtIndex:(NSInteger) index {
    static NSString * titleCELL = @"titleCELL";
    static NSString * resultCELL = @"resultCELL";
    SListViewCell * cell;
    if (listView == _titleTable) {
        cell = [listView dequeueReusableCellWithIdentifier:titleCELL];
        if (!cell) {
            cell = [[SListViewCell alloc] initWithReuseIdentifier:titleCELL];
            
        }
        UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 70, 30)];
        titleButton.backgroundColor = [UIColor blackColor];
        titleButton.tag = index;
        titleButton.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [titleButton setTitle:[NSString stringWithFormat:@"%ld",(long)index] forState:UIControlStateNormal];
        [cell addSubview:titleButton];
    }else{
        cell = [listView dequeueReusableCellWithIdentifier:resultCELL];
        if (!cell) {
            cell = [[SListViewCell alloc] initWithReuseIdentifier:resultCELL];
        }
        UITableView *tempTable = [[UITableView alloc]init];
        tempTable.delegate = self;
        tempTable.dataSource = self;
        tempTable.tag = index+100;
        tempTable.showsVerticalScrollIndicator = NO;
        tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:tempTable];
        [tempTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(@0);
        }];
        cell.backgroundColor = themeColor;
    }
    return  cell;
}

- (void) listView:(SListView *)listView didSelectColumnAtIndex:(NSInteger)index {
    
}

#pragma 初始化界面
-(void)setupBottomView{
    bottomArray = [@[NSLocalizedString(@"分享", @""),NSLocalizedString(@"排序", @"")]mutableCopy];
    //底部工具条
    UIView *bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight-49, ViewWidth, 49)];
    bottomToolBar.backgroundColor = themeColor;
    UIButton *firstButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/2, 49)];
    UIButton *secondButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewWidth/2, 49)];
    firstButton.center = CGPointMake(ViewWidth/(2*[bottomArray count])*1, 24.5);
    firstButton.backgroundColor = themeColor;
    secondButton.center = CGPointMake(ViewWidth/(2*[bottomArray count])*3, 24.5);
    secondButton.backgroundColor = themeColor;
    
    [firstButton setTitle:bottomArray[0] forState:UIControlStateNormal];
    [secondButton setTitle:bottomArray[1] forState:UIControlStateNormal];
    
    [bottomToolBar addSubview:firstButton];
    [bottomToolBar addSubview:secondButton];
    [self.view addSubview:bottomToolBar];
    
    
    bottomMessView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, ViewHeight/2)];
    bottomMessView.backgroundColor = themeColor;
    [self.view addSubview:bottomMessView];
    showMessView = NO;
    [self setUpBottomTable];
}

-(void)setUpBottomTable{
    bottomTable = [[UITableView alloc]init];
    bottomTable.delegate = self;
    bottomTable.dataSource = self;
    bottomTable.tag = 3;
    bottomTable.showsVerticalScrollIndicator = NO;
    [bottomMessView addSubview:bottomTable];
    //    bottomTable.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [bottomTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
}
@end
