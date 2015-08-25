//
//  ViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/6/26.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "OcrTextResultViewController.h"

#import "HttpManager.h"

@interface OcrTextResultViewController ()

{
    CGFloat cellHeight;
    
    NSMutableArray *bottomArray;//底部工具条的数据dataArray
    NSMutableArray *tableViewArray;//保存tableview的数组，实现缓存
    UIView *bottomMessView;//底部显示详细信息的view
    BOOL showMessView;//显示底部view与否的bool
    UITableView *bottomTable;//底部显示用的tableview
    
    NSMutableArray *titleArray;//列表表名（时间）数组
    NSMutableArray *showNameArray;//结果表名，用来显示数据结果名称
    NSMutableArray *ocrDetailValueArray;//保存每行显示结果的数组
    NSArray *customizedIdsOrder;//保存数据每列排序的数组
}

@end

@implementation OcrTextResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}



- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == _nameTable) {
        if (indexPath.row%3 == 2 ) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"doubleresult" forIndexPath:indexPath];
            ((UIButton *)[cell.contentView viewWithTag:2]).imageView.backgroundColor = themeColor;
            [((UIButton *)[cell.contentView viewWithTag:2]).imageView viewWithRadis:10.0];
            [self initGesture:cell];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
        }
        ((UILabel *)[cell.contentView viewWithTag:1]).text = titleArray[indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.layer.borderWidth = 0.25;
        cell.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
        
        //添加阴影
        [cell makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
    }else {
        NSString static *cellIndentify = @"AllInfoCell";
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
        }
#warning 此处加入需要的cell
        if (tableView == _firstResultTable) {
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
            UILabel *contentLabel = [[UILabel alloc]init];
            contentLabel.tag = 1;
            NSDictionary *tempValues = [(NSDictionary *)ocrDetailValueArray[indexPath.row] objectForKey:@"values"];
            NSNumber *key = customizedIdsOrder[tableView.tag -100-1];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *resultIndex = [numberFormatter stringFromNumber:key];
            NSDictionary *finalValues = [tempValues objectForKey:resultIndex];
            if ([finalValues objectForKey:@"value"] == nil||[finalValues objectForKey:@"unit"] == nil) {
                contentLabel.text = @"--";
            }else{
                contentLabel.text = [NSString stringWithFormat:@"%@%@",[finalValues objectForKey:@"value"],[finalValues objectForKey:@"unit"]];
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
    NSLog(@"点击了===%ld",indexPath.row);
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
    if (showMessView) {
        [self popSpringAnimationHidden:bottomMessView];
        showMessView = NO;
    }else{
        [self popSpringAnimationOut:bottomMessView];
        showMessView = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        _nameTable.contentOffset = scrollView.contentOffset;
#warning 改成动态加载tableview之后需要改变同步运动方式
        for (int i = 100; i<111; i++) {
            if ([_resultScroller viewWithTag:i] != nil) {
                ((UITableView *)[_resultScroller viewWithTag:i]).contentOffset = scrollView.contentOffset;
            }
        }
    }
    else if(scrollView == _titleScroller|scrollView == _resultScroller){
//        NSLog(@"ten: %f", scrollView.contentOffset.x );
#warning 将10个获取一次数据加在这里
        _titleScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _titleScroller.contentOffset.y);// scrollView.contentOffset;
        _resultScroller.contentOffset = CGPointMake(scrollView.contentOffset.x, _resultScroller.contentOffset.y); //scrollView.contentOffset;
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
}

#pragma 返回函数
-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

-(void)popSpringAnimationOut:(UIView *)targetView{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight/2,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    
    [targetView pop_addAnimation:anim forKey:@"slider"];

}

-(void)popSpringAnimationHidden:(UIView *)targetView{
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

-(void)setupView{
    //初始化各个tableview和tableview顶上的uiimagview
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
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
    
    [self setUpBottomTable];
}

-(void)setUpBottomTable{
    bottomMessView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, ViewHeight/2)];
    bottomMessView.backgroundColor = themeColor;
    [self.view addSubview:bottomMessView];
    showMessView = NO;
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

-(void)setupData{
    titleArray = [NSMutableArray array];
    showNameArray = [NSMutableArray array];
    ocrDetailValueArray = [NSMutableArray array];
    customizedIdsOrder = [NSMutableArray array];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
    NSLog(@"获取数据的url ====%@",url);
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSDictionary *picList = [source objectForKey:@"indicator"];
        NSArray *medcine = [source objectForKey:@"medcine"];
        NSArray *keysOrder = [source objectForKey:@"keysOrder"];
        NSDictionary *allIndicatorIds = [source objectForKey:@"allIndicatorIds"];
        customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
        
        titleArray = keysOrder;
        for (int i = 0; i<customizedIdsOrder.count; i++) {
            NSNumber *temp = customizedIdsOrder[i];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *resultIndex = [numberFormatter stringFromNumber:temp];
            if ([allIndicatorIds objectForKey:resultIndex] != nil) {
                [showNameArray addObject:[allIndicatorIds objectForKey:resultIndex]];
            }
        }
        for (int i = 0; i<keysOrder.count; i++) {
            NSString *temp = keysOrder[i];
            if ([picList objectForKey:temp] != nil) {
                NSDictionary *tempValueDic = [picList objectForKey:temp];
                [ocrDetailValueArray addObject:tempValueDic];
            }
        }
        if (res == 0) {
            //请求完成
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

@end
