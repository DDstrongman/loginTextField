//
//  ChooseGroupViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/13.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ChooseGroupViewController.h"

#import "DBGroupManager.h"

#import "NSDate+Utils.h"

@interface ChooseGroupViewController ()

{
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *groupJidArray;//官方群的jid
    NSMutableArray *groupNoteArray;//官方群的简介
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
}

@end

@implementation ChooseGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.title = NSLocalizedString(@"群聊", @"");
    [XMPPSupportClass ShareInstance].receiveMessDelegate = self;
    [_groupTable reloadData];
}

-(void)ReceiveMessArray:(NSString *)receiveJID ChatItem:(DBItem *)chatItem{
    NSLog(@"收到群消息");
    [_groupTable reloadData];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_groupTable reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_groupTable reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResults.count;//此处的数字应为网络获取的群数目
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"showGroupCell";//此处注册cell需要自己变动
    int tempI;//搜索的时候的标序
    for (int i=0;i<dataArray.count;i++) {
        if ([dataArray[i] isEqualToString:searchResults[indexPath.row]]) {
            tempI = i;
            break;
        }
    }
    [_groupTable registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%ld",@"grouptitle",(long)(tempI+1)]];
    cell.titleText.text = dataArray[tempI];
    [[DBGroupManager ShareInstance] creatDatabase:GroupChatDBName];
    FMResultSet *lastMessResult = [[DBGroupManager ShareInstance]SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,groupJidArray[tempI]] MessNumber:1 SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
    NSString *lastMess;
    NSString *lastTime;
    NSString *lastType;
    int number = 0;
    while ([lastMessResult next]){
        lastMess = [lastMessResult stringForColumn:@"messContent"];
        lastTime = [lastMessResult stringForColumn:@"timeStamp"];
        lastType = [lastMessResult stringForColumn:@"messType"];
        number++;
    }
    cell.titleText.text = searchResults[indexPath.row];
    if ([lastType isEqualToString:@"0"]) {
        cell.descriptionText.text = lastMess;
    }else if ([lastType isEqualToString:@"1"]){
        cell.descriptionText.text = NSLocalizedString(@"[图片]", @"");
    }else if ([lastType isEqualToString:@"2"]){
        cell.descriptionText.text = NSLocalizedString(@"[语音]", @"");
    }else if ([lastType isEqualToString:@"3"]){
        cell.descriptionText.text = NSLocalizedString(@"[识别结果]", @"");
    }else{
        cell.descriptionText.text = @"";
    }
    if (number == 0) {
        cell.timeText.text = @"";
    }else{
        cell.timeText.text = [self changeTheDateString:lastTime];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    int tempI;//搜索的时候的标序
    for (int i=0;i<dataArray.count;i++) {
        if ([dataArray[i] isEqualToString:searchResults[indexPath.row]]) {
            tempI = i;
            break;
        }
    }
    GroupRootViewController *grtv = [[GroupRootViewController alloc]init];
    grtv.groupJID = groupJidArray[tempI];
    grtv.groupTitle = dataArray[tempI];
    grtv.groupNote = groupNoteArray[tempI];
    [[XMPPSupportClass ShareInstance] setUpChatRoom:[NSString stringWithFormat: @"%@@%@.%@",groupJidArray[tempI],@"conference",httpServer] NickName:[[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"]];
    [self.navigationController pushViewController:grtv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
////    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
////    headerView.backgroundColor = [UIColor lightGrayColor];
////    return headerView;
//}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma searchbar delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self doSearch:searchBar];
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    for (UIButton *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UIButton class]]) {
            [sb setTitleColor:themeColor forState:UIControlStateNormal];
            [sb setTitleColor:themeColor forState:UIControlStateHighlighted];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar];
}

- (void)doSearch:(UISearchBar *)searchBar{
    NSLog(@"搜索开始");
}

#pragma searchviewcontroller的delegate
-(void)viewWillDisappear:(BOOL)animated{
    [searchViewController setActive:NO];
    [self.view endEditing:YES];
}

-(void)setupView{
    _groupTable = [[UITableView alloc]init];
    _groupTable.delegate = self;
    _groupTable.dataSource = self;
    [self.view addSubview:_groupTable];
    self.view.backgroundColor = grayBackColor;
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    searchViewController.delegate = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _groupTable.tableHeaderView = searchViewController.searchBar;
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索群名", @"");
    searchViewController.searchBar.backgroundColor = [UIColor whiteColor];
    searchViewController.searchBar.backgroundImage = [UIImage imageNamed:@"white"];
    searchViewController.searchBar.layer.borderWidth = 0.5;
    searchViewController.searchBar.layer.borderColor = lightGrayBackColor.CGColor;
    for (UIView *sb in [[searchViewController.searchBar subviews][0] subviews]) {
        if ([sb isKindOfClass:[UITextField class]]) {
            sb.layer.borderColor = themeColor.CGColor;
            sb.layer.borderWidth = 0.5;
            [sb viewWithRadis:10.0];
        }
    }
    _groupTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_groupTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
}

-(void)setupData{
    dataArray = [@[NSLocalizedString(@"单身汪 亿友佳缘", @""),NSLocalizedString(@"妈妈帮", @""),NSLocalizedString(@"学生党", @""),NSLocalizedString(@"药价 报销", @"")/*,NSLocalizedString(@"药物副作用交流群", @""),NSLocalizedString(@"乙肝战友看这里", @""),NSLocalizedString(@"丙肝战友看这里", @""),NSLocalizedString(@"脂肪肝胖纸看这里", @""),NSLocalizedString(@"用户反馈群", @"")*/]mutableCopy];
    groupJidArray = [@[@"g999999",@"g999998",@"g999997",@"g999996"/*,@"g999995",@"g999994",@"g999993",@"g999992",@"g999991"*/]mutableCopy];
    groupNoteArray = [@[@"在单身的世界里，你并不是一个人在独舞。要相信缘分！",@"妈妈们和准妈妈们有那么多话题要交流，都是为了娃，一起唠唠",@"学习任务这么繁重，世界上还有这么多要吐槽的事情，学生党速来",@"怎么用药报销划算呢，一起探讨当地行情"/*,@"用药中发生药物副作用了，应该怎么办呢！换药？停药？减药？一起来分享",@"周围很多人都不懂乙肝，战友自己能懂的，到这来尽情诉说吧",@"国内丙肝真不多，找到战友好亲切",@"与脂肪肝战斗，事情可大可小，减肥？饮食？锻炼？快加入群内与大家一起消灭脂肪肝吧",@"用着这个app，爽不爽都来吐槽吧，小易会更好地为大家服务"*/]mutableCopy];
    if (!searchResults) {
        searchResults = dataArray;
    }
    
    [[DBGroupManager ShareInstance] creatDatabase:GroupChatDBName];
    for (NSString *groupJID in groupJidArray) {
        [[DBGroupManager ShareInstance] isChatTableExist:[YizhenTableName stringByAppendingString:groupJID]];
    }
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString;
    if (Str.length>18) {
        subString = [Str substringWithRange:NSMakeRange(0, 19)];
    }
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:lastDate];
    lastDate = [lastDate dateByAddingTimeInterval:interval];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"下午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"晚上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else{
        period = @"凌晨";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@:%02d",dateStr,hour,(int)[lastDate minute]];
}

@end
