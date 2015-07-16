//
//  CaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "CaseViewController.h"

@interface CaseViewController ()

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleTable.delegate = self;
    _titleTable.dataSource = self;
    _thirdTable.frame = CGRectMake(0, 100, ViewWidth/3, 200);
    
    _resultScroller.delegate = self;
    _resultScroller.frame = CGRectMake(ViewWidth/3, 66, ViewWidth/3*2, 200);
    
    _firstTable.delegate = self;
    _firstTable.dataSource = self;
    _secondTable.delegate = self;
    _secondTable.dataSource = self;
    _thirdTable.delegate = self;
    _thirdTable.dataSource = self;
    _forthTable.delegate = self;
    _forthTable.dataSource = self;
    
    _resultScroller.contentSize = CGSizeMake(1200,300);
}

//#pragma 去掉statebar
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [self initNavigationBar];
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 44)];
    navigationBar.backgroundColor = themeColor;
    //左侧头像按钮，点击打开用户相关选项
    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
    userButton.center = CGPointMake(20, 22);
    
    userButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [userButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    
    [userButton addTarget:self action:@selector(openUser) forControlEvents:UIControlEventTouchUpInside];
    
    [navigationBar addSubview:userButton];
    
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    titleLabel.text = NSLocalizedString(@"病历", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
    //去登陆界面
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0,2, 30, 30)];
    cameraButton.center = CGPointMake(ViewWidth-20, 22);
    
    cameraButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [cameraButton setImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    
    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    [navigationBar addSubview:cameraButton];
    
    [self.view addSubview:navigationBar];
}

#pragma 打开用户相关界面，左侧抽屉显示，view暂时未做
-(void)openUser{
    NSLog(@"打开用户界面");
}

#pragma 打开cameraview拍摄化验单等,cameraview已写好
-(void)openCamera{
    NSLog(@"打开拍照界面");
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    //之后通过传入的标识符数组来区分不同cell高度到底选择哪个
    //单个药品用result，两个用doubleresult，更多用moreresult
    
    //    初始化手势识别cell的部件出现问题，需要在cell中加入属性以便识别相关的UILabel,改为给cell加手势即可,问题转化为怎么获取cell中对应的文本
//    if (indexPath.row%3 == 2&& tableView == _nameTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"titlecell" forIndexPath:indexPath];
//        [self initGesture:cell];
//        
//        //        [self initGesture:tempLabelOne];
//        //        [self initGesture:tempLabelTwo];
//        
//        
//        
//        //        DoubleNameTableViewCell *temp_cell = [tableView dequeueReusableCellWithIdentifier:@"doubleresult" forIndexPath:indexPath];
//        //
//        //        temp_cell.firstTitleLabel.userInteractionEnabled = YES;
//        //        temp_cell.secondTitleLabel.userInteractionEnabled = YES;
//        //
//        //        [self initGesture:temp_cell.firstTitleLabel];
//        //        [self initGesture:temp_cell.secondTitleLabel];
//        //        cell = temp_cell;
//        
//    }else if(indexPath.row%3 == 0&& tableView == _nameTable){
//        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"moreresult" forIndexPath:indexPath];
//    }else{
//        cell = [tableView dequeueReusableCellWithIdentifier:@"result" forIndexPath:indexPath];
//    }
//    
//    if (tableView == _nameTable) {
//        cell.backgroundColor = [UIColor whiteColor];
//        
//        cell.layer.borderWidth = 0.25;
//        cell.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//        
//        //添加阴影
//        [cell makeInsetShadowWithRadius:8.0 Color:[UIColor colorWithRed:238.0 green:238.0 blue:238.0 alpha:0.1] Directions:[NSArray arrayWithObjects:@"right", nil]];
//        
//    }else {
//        if (indexPath.row%2 == 0) {
//            cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//            
//            //            cell.layer.borderWidth = 0.25;
//            //            cell.layer.borderColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0].CGColor;
//            
//        }else{
//            cell.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
//            
//            //            cell.layer.borderWidth = 0.25;
//            //            cell.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//        }
//    }
    //     cell.nameButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    [cell.nameButton addTarget:self action:@selector(gotoIntroduce) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.resultButton addTarget:self action:@selector(gotoResult) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.suggestButton addTarget:self action:@selector(gotoSuggest) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.detailButton addTarget:self action:@selector(gotoDetail) forControlEvents:UIControlEventTouchUpInside];
    //    cell.pathNumber = indexPath.row;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ////    添加阴影
    //    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    cell.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
    //    cell.layer.shadowOpacity = 0.2f;
    //    cell.layer.shadowRadius = 3.0f;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"detailview"];
    
//    UITableViewCell *cell = (UITableViewCell*)doubleTap.view;
//    
//    //需要加入判断是否有多个titlelabel，多一个时候viewwithtag：200
//    UILabel *titleLable = (UILabel *)[cell.contentView  viewWithTag:100];
//    
//    vc.titleText = titleLable.text;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _nameTable|scrollView == _firstResultTable|scrollView == _secondResultTable|scrollView == _thirdesultTable) {
//        _nameTable.contentOffset = scrollView.contentOffset;
//        _firstResultTable.contentOffset     = scrollView.contentOffset;
//        _secondResultTable.contentOffset    = scrollView.contentOffset;
//        _thirdesultTable.contentOffset      = scrollView.contentOffset;
//    }
//    else if(scrollView == _titleScroller|scrollView == _resultScroller){
//        //        if(scrollView.contentOffset.x %100 == 0){
//        //            _titleScroller.contentOffset     = scrollView.contentOffset;
//        //            _resultScroller.contentOffset     = scrollView.contentOffset;
//        //        }else{
//        //
//        //        }
//        NSLog(@"ten: %f", scrollView.contentOffset.x );
//        
//        _titleScroller.contentOffset     = scrollView.contentOffset;
//        _resultScroller.contentOffset     = scrollView.contentOffset;
//    }
//}

@end
