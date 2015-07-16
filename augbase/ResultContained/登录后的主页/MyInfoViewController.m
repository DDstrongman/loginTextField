//
//  ShootCaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myInfoTable.delegate = self;
    _myInfoTable.dataSource = self;
    
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
    titleLabel.text = NSLocalizedString(@"我", @"");
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 45;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactcell" forIndexPath:indexPath];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //
    //    return cell;
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myinfo" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        static NSString *myCellIdentifier = @"myCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier];
        }if(indexPath.section == 1){
            cell.textLabel.text = @"2";
            cell.imageView.image = [UIImage imageNamed:@"test"];
            cell.detailTextLabel.text = NSLocalizedString(@"这只是个测试", @"");
        }else if(indexPath.section == 2){
            cell.textLabel.text = @"3";
            cell.imageView.image = [UIImage imageNamed:@"test"];
            cell.detailTextLabel.text = NSLocalizedString(@"这只是个测试", @"");
        }else{
            cell.textLabel.text = @"4";
            cell.imageView.image = [UIImage imageNamed:@"test"];
            cell.detailTextLabel.text = NSLocalizedString(@"这只是个测试", @"");
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *infoSetting = [story instantiateViewControllerWithIdentifier:@"infosetting"];
    [self.navigationController pushViewController:infoSetting animated:YES];
}

#pragma mark ---deit delete---
//// 让 UITableView 和 UIViewController 变成可编辑状态
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
////    [super setEditing:editing animated:animated];
//
//    [self setEditing:editing animated:animated];
//}

//  指定哪一行可以编辑 哪行不能编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//自定义cell的编辑模式，可以是删除也可以是增加 改变左侧的按钮的样式 删除是'-' 增加是'+'
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row == 1) {
    //        return UITableViewCellEditingStyleInsert;
    //    } else {
    return UITableViewCellEditingStyleDelete;
    //    }
}


// 判断点击按钮的样式 来去做添加 或删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_myInfoTable beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
        //        [testArrayDatasource removeObjectAtIndex:indexPath.row];
        [_myInfoTable deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [_myInfoTable  endUpdates];
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        NSArray *indexPaths = @[indexPath];
        [_myInfoTable insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
        
    }
    
}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 更换数据的顺序
    //    [testArrayDatasource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}



@end
