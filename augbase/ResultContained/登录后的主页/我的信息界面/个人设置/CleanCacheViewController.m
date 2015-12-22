//
//  CleanCacheViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/24.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "CleanCacheViewController.h"

#import "WriteFileSupport.h"

@interface CleanCacheViewController ()

{
    NSMutableArray *firstTitleArray;
    NSMutableArray *firstDetailArray;
    NSMutableArray *secondTitleArray;
    NSMutableArray *secondDetailArray;
}

@end

@implementation CleanCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return firstTitleArray.count;
    }else{
        return secondTitleArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"collectionCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = firstTitleArray[indexPath.row];
        cell.detailTextLabel.text = firstDetailArray[indexPath.row];
    }else{
        cell.textLabel.text = secondTitleArray[indexPath.row];
        cell.detailTextLabel.text = secondDetailArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if(indexPath.section == 0){
        if (indexPath.row == 0) {
            UIAlertView *showRemind = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您选择删除私聊记录", @"") message:NSLocalizedString(@"删除私聊记录将会删除所有私人聊天文本信息和所有图片，语音", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
            showRemind.tag = indexPath.row;
            [showRemind show];
        }else if (indexPath.row == 1){
            UIAlertView *showRemind = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您选择删除群聊记录", @"") message:NSLocalizedString(@"删除群聊记录将会删除所有群聊天文本信息和所有图片，语音", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
            showRemind.tag = indexPath.row;
            [showRemind show];
        }else if (indexPath.row == 2){
            UIAlertView *showRemind = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"您选择删除仅聊天图片，语音", @"") message:NSLocalizedString(@"删除聊天图片，语音将会仅去除聊天图片，语音", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
            showRemind.tag = indexPath.row;
            [showRemind show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 1, ViewWidth-24, 20)];
    titleLabel.textColor = grayLabelColor;
    titleLabel.font = [UIFont systemFontOfSize:12.0];
    [headerView addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text = NSLocalizedString(@"可删除", @"");
    }else{
        titleLabel.text = NSLocalizedString(@"不可删除", @"");
    }
    return headerView;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        if (alertView.tag == 0) {
            [[WriteFileSupport ShareInstance]removeCache:[NSString stringWithFormat:@"%@.sqlite",DBName]];
            [self setupData];
            [_cleanCacheTable reloadData];
        }else if (alertView.tag == 1){
            [[WriteFileSupport ShareInstance]removeCache:[NSString stringWithFormat:@"%@.sqlite",GroupChatDBName]];
            [self setupData];
            [_cleanCacheTable reloadData];
        }else if (alertView.tag == 2){
            [[WriteFileSupport ShareInstance]removeCache:yizhenChatFile];
            [self setupData];
            [_cleanCacheTable reloadData];
        }
    }
}

-(void)setupView{
    self.title = NSLocalizedString(@"清除缓存", @"");
    _cleanCacheTable = [[UITableView alloc]init];
    _cleanCacheTable.delegate = self;
    _cleanCacheTable.dataSource = self;
    _cleanCacheTable.tableFooterView = [[UIView alloc]init];
    _cleanCacheTable.sectionHeaderHeight = 22;
    _cleanCacheTable.backgroundColor = grayBackgroundLightColor;
    [self.view addSubview:_cleanCacheTable];
    [_cleanCacheTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
}

-(void)setupData{
    firstTitleArray = [@[NSLocalizedString(@"私聊文字记录", @""),NSLocalizedString(@"群聊文字记录", @""),NSLocalizedString(@"聊天图片，语音", @"")]mutableCopy];
    secondTitleArray = [@[NSLocalizedString(@"好友信息", @""),NSLocalizedString(@"好友头像", @""),NSLocalizedString(@"识别结果缓存", @""),NSLocalizedString(@"原始报告缓存", @"")]mutableCopy];
    firstDetailArray = [NSMutableArray array];
    secondDetailArray = [NSMutableArray array];
    float privateChat = [[WriteFileSupport ShareInstance]countSingleDirFile:[NSString stringWithFormat:@"%@.sqlite",DBName]];
    float groupChat = [[WriteFileSupport ShareInstance]countSingleDirFile:[NSString stringWithFormat:@"%@.sqlite",GroupChatDBName]];
    float chatTemp = [[WriteFileSupport ShareInstance]countSingleDirDocuments:yizhenChatFile];
    if (privateChat < 1) {
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",privateChat*1024]];
    }else if (privateChat < 1024){
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",privateChat]];
    }else{
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",privateChat/1024]];
    }
    if (groupChat < 1) {
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",groupChat*1024]];
    }else if (groupChat < 1024){
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",groupChat]];
    }else{
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",groupChat/1024]];
    }
    if (chatTemp < 1) {
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",chatTemp*1024]];
    }else if (chatTemp < 1024){
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",chatTemp]];
    }else{
        [firstDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",chatTemp/1024]];
    }
    
    float friendInfo = [[WriteFileSupport ShareInstance]countSingleDirFile:[NSString stringWithFormat:@"%@.sqlite",FriendDBName]];
    float friendIcon = [[WriteFileSupport ShareInstance]countSingleDirDocuments:yizhenImageFile];
    float mineTable = [[WriteFileSupport ShareInstance]countSingleDirDocuments:yizhenMineTable];
    float mineReport = [[WriteFileSupport ShareInstance]countSingleDirDocuments:yizhenMineReportImage];
    if (friendInfo < 1) {
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",friendInfo*1024]];
    }else if (friendInfo < 1024){
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",friendInfo]];
    }else{
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",friendInfo/1024]];
    }
    if (friendIcon < 1) {
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",friendIcon*1024]];
    }else if (friendIcon < 1024){
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",friendIcon]];
    }else{
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",friendIcon/1024]];
    }
    if (mineTable < 1) {
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",mineTable*1024]];
    }else if (mineTable < 1024){
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",mineTable]];
    }else{
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",mineTable/1024]];
    }
    if (mineReport < 1) {
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f KB",mineReport*1024]];
    }else if (mineReport < 1024){
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f MB",mineReport]];
    }else{
        [secondDetailArray addObject:[NSString stringWithFormat:@"%.2f GB",mineReport/1024]];
    }
}


@end
