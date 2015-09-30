//
//  ViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrTextResultViewController.h"
#import "MJRefresh.h"

#import "OrderTextListViewController.h"
#import "DetailImageOcrViewController.h"
#import "DrugHistroyViewController.h"

#import "WXApi.h"

@interface OcrTextResultViewController ()

{
    CGFloat cellHeight;
    
    NSMutableArray *bottomArray;//底部工具条的数据dataArray
    NSMutableArray *tableViewArray;//保存tableview的数组，实现缓存
    UIView *bottomMessView;//底部显示详细信息的view
    UITableView *bottomTable;//底部显示用的tableview
    UIView *visualEffectView;//提供高斯模糊的view
    
    UIView *bottomRightView;//点击显示详情后右方跳出view，本来应该用scrollview的，但是本页面scrollview太多，尽量减少更多的scrollview应用
    
    UIView *shareView;//底部分享view
    
    NSMutableArray *titleArray;//列表表名（时间）数组
    
    NSMutableArray *showNameArray;//结果总表名，用来显示数据结果名称
    NSMutableArray *ocrDetailValueArray;//保存每行显示总结果的数组
    NSArray *customizedIdsOrder;//保存数据每列排序的总数组
    NSMutableArray *showNameTempArray;//10个结果表名，用来显示数据结果名称
    NSMutableArray *ocrDetailTempValueArray;//保留所有
    NSArray *customizedIdsTempOrder;//10个保存数据每列排序的数组
    
    NSDictionary *allCodeDetails;//所有数据键值对应的中文名字典
    
    NSInteger tableTag;//点击tableview的tag；
    NSInteger tableIndexRow;//点击tableview的列号
    
    UILabel *bottomTitleLabel;//底部view的标题label
    UILabel *bottomRightLabel;//底部右方view的标题label
    
    NSMutableArray *bottomMedicArray;//底部显示用药的数组
    NSMutableArray *bottomValueArray;//底部显示指标详情的数组
    UITextView *detailTextView;//底部显示标题具体解释给用户的textview
    
    NSInteger ocrResultIndex;//刷新的页数，从0开始，每页10个数据
    BOOL flushResult;//判断是否在进行刷新，防止多次刷新
    
    NSMutableArray *colorArray;//药物颜色的数组
    NSArray *medicineArray;//药品数组，用来分配药品颜色
    
    
    NSString *changeStatus;//需要改变为isviewed（查看过）状态的id组合字符串
}

@end

@implementation OcrTextResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    [self setupData];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 3) {
        if (tableTag == 100) {
            if(ocrDetailValueArray.count == 0){
                return 1;
            }else{
                return  ((NSArray *)[(NSDictionary *)ocrDetailValueArray[tableIndexRow] objectForKey:@"medhis"]).count;
            }
        }else{
            return bottomValueArray.count;
        }
        return titleArray.count;
    }else{
        return titleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 3) {
        return 50;
    }else{
        return 45;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (tableView == _nameTable) {
        if (indexPath.row%3 == 2 ) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"doubleresult" forIndexPath:indexPath];
            ((UIButton *)[cell.contentView viewWithTag:2]).imageView.backgroundColor = themeColor;
            [((UIButton *)[cell.contentView viewWithTag:2]).imageView viewWithRadis:10.0];
//            [self initGesture:cell];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
        }
        ((UILabel *)[cell.contentView viewWithTag:1]).text = titleArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.layer.borderWidth = 0.25;
        cell.layer.borderColor = grayBackgroundDarkColor.CGColor;
        
        //添加阴影
        [cell makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
    }else if(tableView.tag == 3){
        NSDictionary *lineDetailDic;
        if (ocrDetailValueArray.count > 0) {
            lineDetailDic = ocrDetailValueArray[tableIndexRow];
        }
        NSString static *bottomCellIndentify = @"BottomCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:bottomCellIndentify];
        }
        if (tableTag == 100) {
            if (titleArray.count>0) {
                bottomTitleLabel.text = titleArray[tableIndexRow];
                NSArray *medicArray = [lineDetailDic objectForKey:@"medhis"];
                if (medicArray.count >indexPath.row) {
                    cell.textLabel.text = [(NSDictionary *)medicArray[indexPath.row] objectForKey:@"medname"];
                    cell.detailTextLabel.text = [[[(NSDictionary *)medicArray[indexPath.row] objectForKey:@"week"] stringValue] stringByAppendingString:@"周"];
                }
            }
        }else{
            NSDictionary *valuesDetailDic;
            if (tableTag > 100) {
                bottomTitleLabel.text = [showNameTempArray[tableTag-100-1] objectForKey:@"showname"];
                detailTextView.text = [showNameTempArray[tableTag-100-1] objectForKey:@"description"];
                NSDictionary *valuestempDic = [lineDetailDic objectForKey:@"values"];
                valuesDetailDic = [valuestempDic objectForKey:customizedIdsTempOrder[tableTag-100-1]];
            }
            cell.textLabel.text = bottomValueArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@~%@)%@",[valuesDetailDic objectForKey:@"lowerlimit"],[valuesDetailDic objectForKey:@"upperlimit"],[valuesDetailDic objectForKey:@"unit"]];
            }else if (indexPath.row == 1){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",[valuesDetailDic objectForKey:@"value"],[valuesDetailDic objectForKey:@"unit"]];
            }else if (indexPath.row == 2){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[valuesDetailDic objectForKey:@"categoryName"]];
            }else{
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[lineDetailDic objectForKey:@"hospitalName"]];
            }
        }
    }
    else {
        NSString static *cellIndentify = @"AllInfoCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        }
        NSDictionary *lineDetailDic;
        if (ocrDetailTempValueArray.count > 0) {
            lineDetailDic = ocrDetailTempValueArray[indexPath.row];
        }
        
        if (showNameTempArray.count>10) {
            for (int i = 0; i<10; i++) {
                NSDictionary *tempDic = showNameTempArray[i];
                UIButton *tempButton = (UIButton *)[_titleScroller viewWithTag:(i+900+1)];
                if (tempDic != nil && tempButton != nil) {
                    [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                }
            }
        }else{
            for (int i = 0; i<showNameTempArray.count; i++) {
                NSDictionary *tempDic = showNameTempArray[i];
                UIButton *tempButton = (UIButton *)[_titleScroller viewWithTag:(i+900+1)];
                if (tempDic != nil && tempButton != nil) {
                    [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                }
            }
        }
        
#warning 此处加入需要的cell
        if (tableView == _firstResultTable) {
            NSNumber *firstWidth;
            NSNumber *secondWidth;
            NSNumber *thirdWidth;
            UIButton *firstWeekButton = [[UIButton alloc]init];
            firstWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [firstWeekButton setTitle:[@"1" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            firstWeekButton.backgroundColor = themeColor;
            [cell addSubview:firstWeekButton];
            [firstWeekButton viewWithRadis:10.0];
            UIButton *secondWeekButton = [[UIButton alloc]init];
            secondWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            secondWeekButton.backgroundColor = themeColor;
            [secondWeekButton setTitle:[@"12" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            [secondWeekButton viewWithRadis:10.0];
            [cell addSubview:secondWeekButton];
            UIButton *thirdWeekButton = [[UIButton alloc]init];
            thirdWeekButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            thirdWeekButton.backgroundColor = themeColor;
            [thirdWeekButton setTitle:[@"31" stringByAppendingString:@"周"] forState:UIControlStateNormal];
            [thirdWeekButton viewWithRadis:10.0];
            [cell addSubview:thirdWeekButton];
            
            firstWeekButton.tag = indexPath.row;
            secondWeekButton.tag = indexPath.row;
            thirdWeekButton.tag = indexPath.row;
            
            [firstWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [secondWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [thirdWeekButton addTarget:self action:@selector(weekButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            NSArray *medHis = [lineDetailDic objectForKey:@"medhis"];
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            if (medHis.count == 0) {
                firstWeekButton.hidden = YES;
                secondWeekButton.hidden = YES;
                thirdWeekButton.hidden = YES;
            }else if(medHis.count == 1){
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = YES;
                thirdWeekButton.hidden = YES;
                NSDictionary *medDic = medHis[0];
                [firstWeekButton setTitle:[[[medDic objectForKey:@"week"] stringValue] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDic objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
            }else if (medHis.count == 2){
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = NO;
                thirdWeekButton.hidden = YES;
                NSDictionary *medDicOne = medHis[0];
                NSDictionary *medDicTwo = medHis[1];
                [firstWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicOne objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [secondWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicTwo objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicOne objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicTwo objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        secondWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
            }else{
                firstWeekButton.hidden = NO;
                secondWeekButton.hidden = NO;
                thirdWeekButton.hidden = NO;
                NSDictionary *medDicOne = medHis[0];
                NSDictionary *medDicTwo = medHis[1];
                NSDictionary *medDicThree = medHis[2];
                [firstWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicOne objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [secondWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicTwo objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                [thirdWeekButton setTitle:[[numberFormatter stringFromNumber:[medDicThree objectForKey:@"week"]] stringByAppendingString:@"周"] forState:UIControlStateNormal];
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicOne objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        firstWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicTwo objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        secondWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                for (int i= 0; i<medicineArray.count; i++) {
                    if ([[medDicThree objectForKey:@"medname"] isEqualToString:medicineArray[i]]) {
                        thirdWeekButton.backgroundColor = colorArray[(i%10)];
                    }
                }
                
            }
            
            firstWidth = [NSNumber numberWithInt:(25+(int)firstWeekButton.titleLabel.text.length*5)];
            secondWidth = [NSNumber numberWithInt:(25+(int)secondWeekButton.titleLabel.text.length*5)];
            thirdWidth = [NSNumber numberWithInt:(25+(int)thirdWeekButton.titleLabel.text.length*5)];
            
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
            UILabel *contentLabel = [[UILabel alloc]init];
            contentLabel.tag = 1;
            NSDictionary *tempValues = [lineDetailDic objectForKey:@"values"];
            NSNumber *key;
            if (customizedIdsTempOrder.count >tableView.tag - 100 -1 ) {
                key = customizedIdsTempOrder[tableView.tag -100-1];
            }
            NSDictionary *finalValues = [tempValues objectForKey:key];
            if ([finalValues objectForKey:@"value"] == nil) {
                contentLabel.text = @"--";
            }else{
#warning 以后要尽量避免在cell里使用stringformat提升效率
                contentLabel.text = [NSString stringWithFormat:@"%@ %@",[finalValues objectForKey:@"value"],[finalValues objectForKey:@"unit"]];
            }
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:14.0];
            contentLabel.textColor = themeColor;
            [cell addSubview:contentLabel];
            [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@5);
                make.right.equalTo(@-5);
                make.height.equalTo(@30);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }
        if (indexPath.row%2 == 0) {
            cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        }else{
            cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几个表===%ld，点击了第几列====%ld",tableView.tag,(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag != 3) {
        [self popSpringAnimationOut:bottomMessView];
        tableTag = tableView.tag;
    }
    tableIndexRow = indexPath.row;
}

-(void)weekButtonClick:(UIButton *)sender{
    tableTag = 100;
    tableIndexRow = sender.tag;
    [self popSpringAnimationOut:bottomMessView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]&&scrollView.tag != 3) {
        _nameTable.contentOffset = scrollView.contentOffset;
#warning 改成动态加载tableview之后需要改变同步运动方式,主要的卡吨集中在这里
        for (int i = 100; i<111; i++) {
            if ([_resultScroller viewWithTag:i] != nil) {
                ((UITableView *)[_resultScroller viewWithTag:i]).contentOffset = scrollView.contentOffset;
            }
        }
    }
    else if(scrollView == _titleScroller|scrollView == _resultScroller){
        if (scrollView.contentOffset.x == 0 &&flushResult&&ocrResultIndex>0) {
            NSLog(@"刷新");
            flushResult = NO;
            if (ocrResultIndex>0) {
                ocrResultIndex -= 1;
                NSRange range = NSMakeRange(ocrResultIndex*10, 10);
                NSRange rangeName = NSMakeRange(ocrResultIndex*10, showNameArray.count-10*ocrResultIndex);
                NSRange rangeIds = NSMakeRange(ocrResultIndex*10, customizedIdsOrder.count-10*ocrResultIndex);
                if (showNameArray.count>10+ocrResultIndex*10) {
                    showNameTempArray = [NSMutableArray arrayWithArray:[showNameArray subarrayWithRange:range]];
                }else{
                    showNameTempArray = [NSMutableArray arrayWithArray:[showNameArray subarrayWithRange:rangeName]];
                }
                if (customizedIdsOrder.count>10+ocrResultIndex*10) {
                    customizedIdsTempOrder = [NSMutableArray arrayWithArray:[customizedIdsOrder subarrayWithRange:range]];
                }else{
                    customizedIdsTempOrder = [NSMutableArray arrayWithArray:[customizedIdsOrder subarrayWithRange:rangeIds]];
                }
            }
            
            //请求完成
            [_firstResultTable reloadData];
            [_secondResultTable reloadData];
            [_thirdsultTable reloadData];
            [_forthsultTable reloadData];
            [_fifthsultTable reloadData];
            [_sixthsultTable reloadData];
            [_sevensultTable reloadData];
            [_eightsultTable reloadData];
            [_ninesultTable reloadData];
            [_tensultTable reloadData];
            [_elevensultTable reloadData];
            
            [_resultScroller setContentOffset:CGPointMake(1430, scrollView.contentOffset.y) animated:NO];
        }
        
        if (scrollView.contentOffset.x == 1500 &&flushResult) {
            NSLog(@"刷新");
            flushResult = NO;
            ocrResultIndex += 1;
            if (ocrResultIndex*10<showNameArray.count&&ocrResultIndex*10<customizedIdsOrder.count) {
                NSRange range = NSMakeRange(ocrResultIndex*10, 10);
                NSRange rangeName = NSMakeRange(ocrResultIndex*10, showNameArray.count-10*ocrResultIndex);
                NSRange rangeIds = NSMakeRange(ocrResultIndex*10, customizedIdsOrder.count-10*ocrResultIndex);
                if (showNameArray.count>10+ocrResultIndex*10) {
                    showNameTempArray = [NSMutableArray arrayWithArray:[showNameArray subarrayWithRange:range]];
                }else{
                    showNameTempArray = [NSMutableArray arrayWithArray:[showNameArray subarrayWithRange:rangeName]];
                }
                if (customizedIdsOrder.count>10+ocrResultIndex*10) {
                    customizedIdsTempOrder = [NSMutableArray arrayWithArray:[customizedIdsOrder subarrayWithRange:range]];
                }else{
                    customizedIdsTempOrder = [NSMutableArray arrayWithArray:[customizedIdsOrder subarrayWithRange:rangeIds]];
                }
            }
            
            //请求完成
            [_firstResultTable reloadData];
            [_secondResultTable reloadData];
            [_thirdsultTable reloadData];
            [_forthsultTable reloadData];
            [_fifthsultTable reloadData];
            [_sixthsultTable reloadData];
            [_sevensultTable reloadData];
            [_eightsultTable reloadData];
            [_ninesultTable reloadData];
            [_tensultTable reloadData];
            [_elevensultTable reloadData];
            
            [_resultScroller setContentOffset:CGPointMake(150, scrollView.contentOffset.y) animated:NO];
        }
        
#warning 将10个获取一次数据加在这里
        _titleScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _titleScroller.contentOffset.y);// scrollView.contentOffset;
        _resultScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _resultScroller.contentOffset.y);
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
-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if(scrollView == _titleScroller|scrollView == _resultScroller){
        if ((int)(scrollView.contentOffset.x) % 150 !=0) {
            int tempNumber = (int)(scrollView.contentOffset.x)/150 + 1;
            //设置了_titlescroller和resultscroller一样的offset，所以此处只能设置一次animate，否则出错
            [_titleScroller setContentOffset:scrollView.contentOffset animated:YES];
            
            [_resultScroller setContentOffset:CGPointMake(tempNumber*150, scrollView.contentOffset.y) animated:YES];
        }
    }
    flushResult = YES;
}

#pragma 返回函数
-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}

-(void)setupView{
    //初始化各个tableview和tableview顶上的uiimagview
    
    _nameTable.delegate = self;
    _nameTable.dataSource = self;
    
    //初始化两个scrollerview
    _titleScroller.delegate = self;
    _resultScroller.delegate = self;
    
    UITableView *firstTable = [[UITableView alloc]init];
    firstTable.delegate = self;
    firstTable.dataSource = self;
    firstTable.tag = 100;
    firstTable.showsVerticalScrollIndicator = NO;
    firstTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [_resultScroller addSubview:firstTable];
    [firstTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@150);
        make.left.equalTo(@0);
    }];
    
    for (int i = 101; i<111; i++) {
        UITableView *tempTable = [[UITableView alloc]init];
        tempTable.delegate = self;
        tempTable.dataSource = self;
        tempTable.tag = i;
        tempTable.showsVerticalScrollIndicator = NO;
        tempTable.separatorStyle = UITableViewCellSelectionStyleNone;
        NSNumber *decideNumber = [NSNumber numberWithInt:(150*(i - 100))];
        [_resultScroller addSubview:tempTable];
        [tempTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.bottom.equalTo(@0);
            make.width.equalTo(@150);
            make.left.equalTo(decideNumber);
        }];
    }
    
    _firstResultTable = (UITableView *)[_resultScroller viewWithTag:100];
    _secondResultTable = (UITableView *)[_resultScroller viewWithTag:101];
    _thirdsultTable = (UITableView *)[_resultScroller viewWithTag:102];
    _forthsultTable = (UITableView *)[_resultScroller viewWithTag:103];
    _fifthsultTable = (UITableView *)[_resultScroller viewWithTag:104];
    _sixthsultTable = (UITableView *)[_resultScroller viewWithTag:105];
    _sevensultTable = (UITableView *)[_resultScroller viewWithTag:106];
    _eightsultTable = (UITableView *)[_resultScroller viewWithTag:107];
    _ninesultTable = (UITableView *)[_resultScroller viewWithTag:108];
    _tensultTable = (UITableView *)[_resultScroller viewWithTag:109];
    _elevensultTable = (UITableView *)[_resultScroller viewWithTag:110];
    tableViewArray = [NSMutableArray array];
    
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
    
    [firstButton addTarget:self action:@selector(shareResults:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton addTarget:self action:@selector(orderResults:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpBottomTable];
    [self setUpBottomRightView];
    [self setupShareView];
}

-(void)setUpBottomTable{
    bottomMessView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 350)];
    bottomMessView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomMessView];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    cancelButton.center = CGPointMake(30, 23);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"closed"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessView addSubview:cancelButton];
    bottomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    bottomTitleLabel.center = CGPointMake(bottomMessView.center.x,23);
    bottomTitleLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    bottomTitleLabel.text = @"";
    [bottomMessView addSubview:bottomTitleLabel];
    UIButton *detailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    detailButton.center = CGPointMake(ViewWidth-30, 23);
    [detailButton setBackgroundImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
    [detailButton addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bottomMessView addSubview:detailButton];
    
    bottomTable = [[UITableView alloc]init];
    bottomTable.delegate = self;
    bottomTable.dataSource = self;
    bottomTable.separatorColor = lightGrayBackColor;
    bottomTable.tag = 3;
    bottomTable.showsVerticalScrollIndicator = NO;
    bottomTable.layer.borderColor = lightGrayBackColor.CGColor;
    bottomTable.layer.borderWidth = 1;
    bottomTable.tableFooterView = [[UIView alloc]init];
    [bottomMessView addSubview:bottomTable];
    
    UIButton *bottomButton = [[UIButton alloc]init];
    [bottomButton setTitle:NSLocalizedString(@"去看看", @"") forState:UIControlStateNormal];
    [bottomButton setTitleColor:themeColor forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(gotoOtherView:) forControlEvents:UIControlEventTouchUpInside];
    bottomButton.layer.borderColor = themeColor.CGColor;
    bottomButton.layer.borderWidth = 1.0;
    [bottomButton viewWithRadis:10.0];
    
    [bottomMessView addSubview:bottomButton];
    [bottomMessView addSubview:cancelButton];
    
    [bottomTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0);
        make.top.equalTo(@45);
        make.bottom.equalTo(@-80);
    }];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.height.equalTo(@45);
        make.bottom.equalTo(@-17);
    }];
}

-(void)setUpBottomRightView{
    bottomRightView = [[UIView alloc]initWithFrame:CGRectMake(ViewWidth, ViewHeight-350, ViewWidth, 350)];
    bottomRightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomRightView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    backButton.center = CGPointMake(30, 23);
    [backButton setBackgroundImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBottomRightView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomRightView addSubview:backButton];
    bottomRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    bottomRightLabel.center = CGPointMake(bottomMessView.center.x,23);
    bottomRightLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    bottomRightLabel.text = @"永超卖屁股";
    [bottomRightView addSubview:bottomRightLabel];
    
    detailTextView = [[UITextView alloc]init];
    detailTextView.text = @"";
    detailTextView.userInteractionEnabled = NO;
    [bottomRightView addSubview:detailTextView];
    [detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@45);
        make.right.left.bottom.equalTo(@0);
    }];
}

-(void)cancelShareAction:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)setupShareView{
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 175)];
    shareView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *shareScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, shareView.bounds.size.width, 95)];
    shareScroller.contentSize = CGSizeMake(shareView.bounds.size.width+50, 95);
    [shareView addSubview:shareScroller];
    
    
    UIButton *shareWeChatButton = [[UIButton alloc]init];
    [shareWeChatButton setBackgroundImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
    [shareWeChatButton setTitle:NSLocalizedString(@"微信好友", @"") forState:UIControlStateNormal];
    [shareWeChatButton addTarget:self action:@selector(shareWechatFriend:) forControlEvents:UIControlEventTouchUpInside];
    shareWeChatButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareWeChatButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareWeChatButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareWeChatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareWeChatButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareWeChatButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    UIButton *shareWeChatGroupButton = [[UIButton alloc]init];
    [shareWeChatGroupButton setBackgroundImage:[UIImage imageNamed:@"friend_quan"] forState:UIControlStateNormal];
    [shareWeChatGroupButton addTarget:self action:@selector(shareWechatGroup:) forControlEvents:UIControlEventTouchUpInside];
    [shareWeChatGroupButton setTitle:NSLocalizedString(@"朋友圈", @"") forState:UIControlStateNormal];
    shareWeChatGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareWeChatGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareWeChatGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareWeChatGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareWeChatGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareWeChatGroupButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    UIButton *shareQQButton = [[UIButton alloc]init];
    [shareQQButton setBackgroundImage:[UIImage imageNamed:@"qq_friends"] forState:UIControlStateNormal];
    [shareQQButton setTitle:NSLocalizedString(@"QQ好友", @"") forState:UIControlStateNormal];
    [shareQQButton addTarget:self action:@selector(shareQQFriend:) forControlEvents:UIControlEventTouchUpInside];
    shareQQButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareQQButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareQQButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareQQButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareQQButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareQQButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    UIButton *shareQQGroupButton = [[UIButton alloc]init];
    [shareQQGroupButton setBackgroundImage:[UIImage imageNamed:@"qq_zone"] forState:UIControlStateNormal];
    [shareQQGroupButton addTarget:self action:@selector(shareQQZone:) forControlEvents:UIControlEventTouchUpInside];
    [shareQQGroupButton setTitle:NSLocalizedString(@"QQ空间", @"") forState:UIControlStateNormal];
    shareQQGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareQQGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareQQGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareQQGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareQQGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareQQGroupButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    UIButton *cancelButton = [[UIButton alloc]init];
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    cancelButton.layer.borderWidth = 0.5;
    cancelButton.layer.borderColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0].CGColor;
    [cancelButton viewWithRadis:10.0];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancelButton];
    [shareScroller addSubview:shareWeChatButton];
    [shareScroller addSubview:shareWeChatGroupButton];
    [shareScroller addSubview:shareQQButton];
    [shareScroller addSubview:shareQQGroupButton];
    [self.view addSubview:shareView];
    [shareWeChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@10);
        make.width.equalTo(@57);
        make.height.equalTo(@75);
    }];
    [shareWeChatGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareWeChatButton.mas_right).with.offset(20);
        make.top.equalTo(@10);
        make.width.equalTo(@57);
        make.height.equalTo(@75);
    }];
    [shareQQButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareWeChatGroupButton.mas_right).with.offset(20);
        make.top.equalTo(@10);
        make.width.equalTo(@57);
        make.height.equalTo(@75);
    }];
    [shareQQGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareQQButton.mas_right).with.offset(20);
        make.top.equalTo(@10);
        make.width.equalTo(@57);
        make.height.equalTo(@75);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(shareScroller.mas_bottom).with.offset(10);
        make.right.equalTo(@-20);
        make.height.equalTo(@50);
    }];
}

-(void)setupData{
    ocrResultIndex = 0;
    flushResult = YES;
    titleArray = [NSMutableArray array];
    showNameArray = [NSMutableArray array];
    ocrDetailValueArray = [NSMutableArray array];
    customizedIdsOrder = [NSMutableArray array];
    bottomMedicArray = [NSMutableArray array];
    colorArray = [NSMutableArray array];
    bottomValueArray = [@[NSLocalizedString(@"参考范围", @""),NSLocalizedString(@"指标数值", @""),NSLocalizedString(@"指标类别", @""),NSLocalizedString(@"检测医院", @"")]mutableCopy];
    tableIndexRow = 0;
    tableTag = 100;
//    [UIColor colorWithCGColor:]
    [colorArray addObject:[UIColor colorWithRed:255.0/255 green:210.0/255 blue:72.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:246.0/255 green:147.0/255 blue:111.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:242.0/255 green:111.0/255 blue:122.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:236.0/255 green:148.0/255 blue:191.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:161.0/255 green:138.0/255 blue:192.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:119.0/255 green:205.0/255 blue:214.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:64.0/255 green:188.0/255 blue:157.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:174.0/255 green:212.0/255 blue:117.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:127.0/255 green:197.0/255 blue:110.0/255 alpha:1.0]];
    [colorArray addObject:[UIColor colorWithRed:189.0/255 green:186.0/255 blue:50.0/255 alpha:1.0]];
    NSString *url;
    if (_isMine) {
        url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    }else{
        url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@&userJId=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],_personJID];
    }
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            //请求完成
            NSDictionary *picList = [source objectForKey:@"indicator"];
            medicineArray = [source objectForKey:@"medcine"];
            NSArray *keysOrder = [source objectForKey:@"keysOrder"];
            allCodeDetails = [source objectForKey:@"allCodeDetails"];
            customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
            
            titleArray = [NSMutableArray arrayWithArray:keysOrder];
            for (int i = 0; i<customizedIdsOrder.count; i++) {
                NSString *resultIndex = customizedIdsOrder[i];
                if ([allCodeDetails objectForKey:resultIndex] != nil) {
                    [showNameArray addObject:[allCodeDetails objectForKey:resultIndex]];
                }
            }
            for (int i = 0; i<keysOrder.count; i++) {
                NSString *temp = keysOrder[i];
                if ([picList objectForKey:temp] != nil) {
                    NSDictionary *tempValueDic = [picList objectForKey:temp];
                    if ([[[tempValueDic objectForKey:@"isViewedByMe"] stringValue] isEqualToString:@"false"]) {
                        if (changeStatus == nil) {
                            changeStatus = [[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue];
                        }else{
                            changeStatus = [NSString stringWithFormat:@"%@,%@",changeStatus,[[[tempValueDic objectForKey:@"ltrList"][0] objectForKey:@"id"] stringValue]];
                        }
                    }
                    [ocrDetailValueArray addObject:tempValueDic];
                }
            }
            if (showNameArray.count>10) {
                for (int i = 1; i<11; i++) {
                    NSDictionary *tempDic = showNameArray[i-1];
                    UIButton *tempButton = (UIButton *)[_titleScroller viewWithTag:(i+900)];
                    if (tempDic != nil && tempButton != nil) {
                        [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                    }
                }
            }else{
                for (int i = 1; i<showNameArray.count; i++) {
                    NSDictionary *tempDic = showNameArray[i-1];
                    UIButton *tempButton = (UIButton *)[_titleScroller viewWithTag:(i+900)];
                    if (tempDic != nil && tempButton != nil) {
                        [tempButton setTitle:[tempDic objectForKey:@"showname"] forState:UIControlStateNormal];
                    }
                }
            }
            
            NSRange range = NSMakeRange(0, 10);
            if (showNameArray.count>10) {
                showNameTempArray = [NSMutableArray arrayWithArray:[showNameArray subarrayWithRange:range]];
            }else{
                showNameTempArray = showNameArray;
            }
            ocrDetailTempValueArray = ocrDetailValueArray;
            if (customizedIdsOrder.count>10) {
                customizedIdsTempOrder = [NSMutableArray arrayWithArray:[customizedIdsOrder subarrayWithRange:range]];
            }else{
                customizedIdsTempOrder = customizedIdsOrder;
            }
            
            [_nameTable reloadData];
            [_firstResultTable reloadData];
            [_secondResultTable reloadData];
            [_thirdsultTable reloadData];
            [_forthsultTable reloadData];
            [_fifthsultTable reloadData];
            [_sixthsultTable reloadData];
            [_sevensultTable reloadData];
            [_eightsultTable reloadData];
            [_ninesultTable reloadData];
            [_tensultTable reloadData];
            [_elevensultTable reloadData];
        }else{
            NSLog(@"web获取数据失败＝＝＝%d",res);
        }
    }  FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败：%@",error);
    }];
}

#pragma 改变观察状体
-(void)changeViewedStatus{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *changeUrl = [NSString stringWithFormat:@"%@v2/indicator/viewedStatus/?uid=%@&token=%@&isDoctor=%@&ltrIds=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],@"false",@""];
}

#pragma 分享
- (void)shareAction{
    [self popOutShareView:shareView];
}

#pragma 底部view出现和隐藏
-(void)popOutShareView:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomMessView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    [bottomTable reloadData];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)popSpringAnimationOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomMessView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    [bottomTable reloadData];
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:bottomMessView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
    tableTag = 100;
    tableIndexRow = 0;
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
    
}

-(void)showRightSpringAnimationOut:(UIView *)targetView{
    bottomRightLabel.text = bottomTitleLabel.text;
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)hideRightSpringAnimationHidden:(UIView *)targetView{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(ViewWidth,ViewHeight-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)cancelBottomView:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomMessView];
}

-(void)backBottomRightView:(UIButton *)sender{
    [self hideRightSpringAnimationHidden:bottomRightView];
}

-(void)showDetail:(UIButton *)sender{
    [self showRightSpringAnimationOut:bottomRightView];
}

-(void)gotoOtherView:(UIButton *)sender{
    if (tableTag != 100) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DetailImageOcrViewController *div = [main instantiateViewControllerWithIdentifier:@"detailocrimage"];
        
        NSString *urlString = [[[ocrDetailValueArray[tableIndexRow] objectForKey:@"ltrList"][0] objectForKey:@"picsInfo"][0] objectForKey:@"pic"];;
        NSMutableDictionary *dic = [ocrDetailValueArray[tableIndexRow] objectForKey:@"ltrList"][0];
        div.showImageUrl = [NSString stringWithFormat:@"http://yizhenimg.augbase.com/origin/%@",urlString];
        div.detailDic = dic;
        div.ResultOrING = YES;
        [self.navigationController pushViewController:div animated:YES];
    }else{
        DrugHistroyViewController *dhv = [[DrugHistroyViewController alloc]init];
        [self.navigationController pushViewController:dhv animated:YES];
    }
}

-(void)shareResults:(UIButton *)sender{
    [self shareAction];
}

-(void)orderResults:(UIButton *)sender{
    OrderTextListViewController *otlv = [[OrderTextListViewController alloc]init];
    otlv.listArray = customizedIdsOrder;
    otlv.listName = allCodeDetails;
    [self.navigationController pushViewController:otlv animated:YES];
}

-(void)shareWechatFriend:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"易诊app";
    message.description = @"易诊就是您的发展方向啊";
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;//WXSceneTimeline
    
    [WXApi sendReq:req];
    [self popSpringAnimationHidden:shareView];
}

-(void)shareWechatGroup:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"易诊app";
    message.description = @"易诊就是您的发展方向啊";
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;//
    
    [WXApi sendReq:req];
    [self popSpringAnimationHidden:shareView];
}

-(void)shareQQFriend:(UIButton *)sender{
    
}

-(void)shareQQZone:(UIButton *)sender{
    
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
