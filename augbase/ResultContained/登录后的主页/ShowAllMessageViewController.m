//
//  ShowAllMessageViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ShowAllMessageViewController.h"

#import "UserItem.h"
#import "DBItem.h"
#import "FriendDBManager.h"

#import "MessNewsViewController.h"

#import "NSDate+Utils.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ShowAllMessageViewController ()

{
    NSMutableArray *tableJidName;//用户jid数组
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *titleImageNameArray;//官方提供的图片名称数组
    NSMutableArray *titleColorArray;//官方提供的图片背景色数组
    NSMutableArray *searchResults;//搜索结果的数组
    NSMutableArray *chatCellJID;//每个显示的chatcell的JID数组，用来传递jid，需要注意的是私聊和群聊的jid拼接方式不一样
    
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
    BOOL NotFirstTimeLogin;//no为初次登录，yes则不是
    UIView *navigationBar;
    
    DBItem *lastMessItem;//最后一次传来的消息类
    
    CLLocationManager *locationManager;//获取坐标
    
//    BOOL headBool;
}

@end

@implementation ShowAllMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
    [self setupConnect];
    
    [self setLocation];//获取地理位置
}

#pragma xmpp收到信息后触法的delegate,receieveMess为发送者的jid
-(void)ReceiveMessArray:(NSString *)receiveMess ChatItem:chatItem{
    NSLog(@"xmpp收到消息");
    lastMessItem = chatItem;
    
    NSLog(@"接收到的信息====%@",lastMessItem.personImageUrl);
    
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName, receiveMess]];
    tableJidName = [[DBManager ShareInstance] getAllTableName];
#warning 此处需要加入通过jid判断用户name的网络需求
    dataArray = [NSMutableArray arrayWithCapacity:0];
    if ([tableJidName count] >0) {
        for (NSString *JID in tableJidName) {
            FMResultSet *friendResult = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:JID];
            while ([friendResult next]) {
                NSString *personNickName = [friendResult stringForColumn:@"friendName"];
                if (![personNickName isEqualToString:@""]) {
                    [dataArray addObject:personNickName];
                }else{
                    [dataArray addObject:defaultUserName];
                }
            }
        }
    }
    [_messageTableview reloadData];
    NSLog(@"数据源为：%@",dataArray);
    searchResults = dataArray;
    [_messageTableview reloadData];
}

#pragma xmpp登录成功与否的delegate
-(void)ConnectXMPPResult:(BOOL)result{
    if (result) {
        NSLog(@"XMPP服务器登陆成功");
        [[XMPPSupportClass ShareInstance] getMyQueryRoster];
        [[DBManager ShareInstance] creatDatabase:DBName];
    }else{
        NSLog(@"XMPP服务器登陆失败");
        UIAlertView *xmppFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"聊天服务器登陆失败", @"") message:NSLocalizedString(@"聊天服务器登陆失败,请联系管理员", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [xmppFailedAlert show];
    }
}
#pragma 获取好友列表结果返回
-(void)GetFriendListDelegate:(BOOL)result{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (result) {
        NSLog(@"更新好友列表成功");
        [_messageTableview reloadData];
        [defaults setObject:@YES forKey:@"FriendList"];
    }else{
        NSLog(@"更新好友列表失败");
        [defaults setObject:@NO forKey:@"FriendList"];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [XMPPSupportClass ShareInstance].receiveMessDelegate = self;
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
    [XMPPSupportClass ShareInstance].getFriendListDelegate = self;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blue"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.title = NSLocalizedString(@"消息", @"");
    
    UIImage* imageNormal = [UIImage imageNamed:@"message_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"message_on"];
    
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.tintColor = themeColor;
    self.view.backgroundColor = grayBackgroundLightColor;
    
    [[DBManager ShareInstance]creatDatabase:DBName];
    [[FriendDBManager ShareInstance]creatDatabase:FriendDBName];
    
    tableJidName = [[DBManager ShareInstance] getAllTableName];
    dataArray = [NSMutableArray array];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FriendList"]) {
        if ([tableJidName count] >0) {
            for (NSString *JID in tableJidName) {
                FMResultSet *friendResult = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:JID];
                while ([friendResult next]) {
                    NSString *personNickName = [friendResult stringForColumn:@"friendName"];
                    if (![personNickName isEqualToString:@""]) {
                        [dataArray addObject:personNickName];
                    }else{
                        [dataArray addObject:defaultUserName];
                    }
                }
            }
        }
        searchResults = dataArray;
        [_messageTableview reloadData];
    }else{
        if ([tableJidName count] >0) {
            for (NSString *JID in tableJidName) {
                NSString *url = [NSString stringWithFormat:@"%@user?jid=%@",Baseurl,JID];
                NSURL *urlWithUrl = [NSURL URLWithString:url];
                //第二步，通过URL创建网络请求
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlWithUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:3];
                //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
                //        其中缓存协议是个枚举类型包含：
                //
                //        NSURLRequestUseProtocolCachePolicy（基础策略）
                //
                //        NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
                //
                //        NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
                //
                //        NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
                //
                //        NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
                //
                //        NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
                //第三步，连接服务器
                NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                if (received != nil) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
                    NSString *str = [source objectForKey:@"nickname"];
                    if (str !=nil) {
                        NSLog(@"str====%@",str);
                        [dataArray addObject:str];
                    }
                }else{
                    NSLog(@"无返回");
                }
            }
        }
        NSLog(@"数据源为：%@",dataArray);
        searchResults = dataArray;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [_messageTableview reloadData];
}

-(void)setLocation{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userSystemVersion"] floatValue]<8.0) {
        
    }else{
        [locationManager requestAlwaysAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1000.f;
    // 开始时时定位
    [locationManager startUpdatingLocation];
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error");
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

// 6.0 以上调用这个函数
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithFloat:oldCoordinate.latitude] forKey:@"latitude"];
    [dic setObject:[NSNumber numberWithFloat:oldCoordinate.longitude] forKey:@"longitude"];
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"res====%d",res);
        if (res == 0) {
            NSLog(@"上传位置成功");
            [locationManager stopUpdatingLocation];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma searcheViewController的delegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //谓词检测
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"self contains [cd] %@", searchController.searchBar.text];
    if ([searchController.searchBar.text isEqualToString:@""]){
        searchResults = dataArray;
        [_messageTableview reloadData];
    }else{
        //将所有和搜索有关的内容存储到arr数组
        searchResults = [NSMutableArray arrayWithArray:
                         [dataArray filteredArrayUsingPredicate:predicate]];
        //重新加载数据
        [_messageTableview reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (searchResults.count == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSLog(@"此处隐藏了我的医生一栏，以后需要加入,即将2变为3");
#warning 此处隐藏了我的医生一栏，以后需要加入,即将2变为3
        return titleDataArray.count-1;//隐藏了我的医生一栏，以后需要加入
    }else{
        return searchResults.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"showMessCell";
    [_messageTableview registerClass:[MessTableViewCell class]forCellReuseIdentifier:cellIndentify];
    MessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentify forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    
    if (indexPath.section == 0) {
        cell.iconImageView.image = [UIImage imageNamed:titleImageNameArray[indexPath.row]];
        cell.iconImageView.backgroundColor = titleColorArray[indexPath.row];
        cell.titleText.text = titleDataArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.descriptionText.text = NSLocalizedString(@"找到属于自己的战友圈子", @"");
        }else{
            cell.descriptionText.text = NSLocalizedString(@"实时同步战友微信订阅号", @"");
        }
    }else{
        FMResultSet *lastMessResult = [[DBManager ShareInstance]SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]] MessNumber:1 SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
        NSString *lastMess;
        NSString *lastTime;
        NSString *lastType;
        while ([lastMessResult next]){
            lastMess = [lastMessResult stringForColumn:@"messContent"];
            lastTime = [lastMessResult stringForColumn:@"timeStamp"];
            lastType = [lastMessResult stringForColumn:@"messType"];
        }
        cell.titleText.text = searchResults[indexPath.row];
        if ([lastType isEqualToString:@"0"]) {
            cell.descriptionText.text = lastMess;
        }else if ([lastType isEqualToString:@"1"]){
            cell.descriptionText.text = NSLocalizedString(@"[图片]", @"");
        }else{
            cell.descriptionText.text = NSLocalizedString(@"[语音]", @"");
        }
        cell.timeText.text = [self changeTheDateString:lastTime];
        
        FMResultSet *messPicPath = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:tableJidName[indexPath.row]];
        while ([messPicPath next]){
            NSString *picPath = [messPicPath stringForColumn:@"friendImageUrl"];
            cell.iconImageView.image = [UIImage imageWithContentsOfFile:picPath];
        }
        
        FMResultSet *messWithNumber = [[DBManager ShareInstance] SearchMessNotReadNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]] ItemName:@"ReadOrNot" ItemValue:0];
        NSInteger messNumer = 0;
        while ([messWithNumber next]) {
            messNumer++;
        }
        if (messNumer == 0) {
            [cell.timeText imageRemoveRedNumber];
        }else{
            [cell.timeText imageWithRedNumber:messNumer];
        }
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0&&indexPath.row == 0) {
        ChooseGroupViewController *cgv = [[ChooseGroupViewController alloc]init];
        [self.navigationController pushViewController:cgv animated:YES];
    }else if(indexPath.section == 0&&indexPath.row == 1){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MessNewsViewController *mnc = [main instantiateViewControllerWithIdentifier:@"messnews"];
        [self.navigationController pushViewController:mnc animated:YES];
    }else if(indexPath.section == 0&&indexPath.row == 2){
        
    }else{
        RootViewController *rtv = [[RootViewController alloc]init];
        rtv.privateOrNot = 0;//私聊
        rtv.personJID = tableJidName[indexPath.row];
        [self.navigationController pushViewController:rtv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---edit delete---
//  指定哪一行可以编辑 哪行不能编辑
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return NO;
    }
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 删除的操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_messageTableview beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
//        [_messageTableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [dataArray removeObjectAtIndex:indexPath.row];
#warning 此处加入删除消息的数据库操作
        [[DBManager ShareInstance] creatDatabase:DBName];
        [[DBManager ShareInstance] deleteTable:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]]];
//        [_messageTableview  endUpdates];
        [_messageTableview reloadData];
    }
    
    // 添加的操作
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSArray *indexPaths = @[indexPath];
        [_messageTableview insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];
        
    }
}

#pragma mark 只有实现这个方法，编辑模式中才允许移动Cell
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (searchResults.count == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        footerView.backgroundColor = grayBackgroundLightColor;
        [footerView makeInsetShadowWithRadius:0.5 Color:lightGrayBackColor Directions:[NSArray arrayWithObjects:@"top", nil]];
        return footerView;
    }else{
        if (section == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
            footerView.backgroundColor = grayBackgroundLightColor;
            footerView.layer.borderColor = lightGrayBackColor.CGColor;
            footerView.layer.borderWidth = 0.5;
            return footerView;
        }else{
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
            footerView.backgroundColor = grayBackgroundLightColor;
            [footerView makeInsetShadowWithRadius:0.5 Color:lightGrayBackColor Directions:[NSArray arrayWithObjects:@"top", nil]];
            return footerView;
        }
    }
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [searchViewController setActive:NO];
    [self.view endEditing:YES];
}

#pragma searchviewcontroller的delegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    NSLog(@"将要  开始  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
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

// 搜索界面将要消失
-(void)willDismissSearchController:(UISearchController *)searchController{
    NSLog(@"将要  取消  搜索时触发的方法");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)didDismissSearchController:(UISearchController *)searchController{
    
}

#pragma viewdidload等中初始化的方法写在这里
-(void)setupView{
    _messageTableview.delegate = self;
    _messageTableview.dataSource = self;
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = YES;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    searchViewController.delegate = self;
    //将搜索控制器的搜索条设置为页眉视图
    _messageTableview.tableHeaderView = searchViewController.searchBar;
    _messageTableview.backgroundColor = grayBackgroundLightColor;
    _messageTableview.tableFooterView = [[UIView alloc]init];
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索联系人姓名", @"");
    [[SetupView ShareInstance]setupSearchbar:searchViewController];
}

-(void)setupData{
#warning 此处加入收到信息的dataarra
    titleDataArray = [@[NSLocalizedString(@"群聊", @""),NSLocalizedString(@"咨讯", @""),NSLocalizedString(@"我的医生", @"")]mutableCopy];
    titleImageNameArray = [@[@"groups",@"news"]mutableCopy];
    titleColorArray = [@[themeColor,yellowTitleColor,themeColor]mutableCopy];
    chatCellJID = [NSMutableArray array];
}

-(void)setupConnect{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NotFirstTimeLogin = (BOOL)[defaults stringForKey:@"NotFirstTime"];//no为初次登录，yes则不是
    if (NotFirstTimeLogin) {
        NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
        NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
        [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
        [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                //请求完成
                if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[defaults objectForKey:@"userJID"],httpServer]]) {
                    
                }
            }
            else{
//                [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"WEB端登录失败：%@",error);
        }];
    }

}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
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
