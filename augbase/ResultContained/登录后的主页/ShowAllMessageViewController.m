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

@interface ShowAllMessageViewController ()

{
    NSMutableArray *tableJidName;//用户jid数组
    NSMutableArray *dataArray;//搜索的数据元数组
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *titleImageNameArray;//官方提供的图片名称数组
    NSMutableArray *searchResults;//搜索结果的数组
    UISearchBar *mySearchBar;//ui，仅仅是个ui
    UISearchController *searchViewController;//显示搜索结果的tableview，系统自带，但是需要实现
    BOOL NotFirstTimeLogin;//no为初次登录，yes则不是
}

@end

@implementation ShowAllMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _messageTableview.delegate = self;
    _messageTableview.dataSource = self;
    
    
    searchViewController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchViewController.active = NO;
    searchViewController.dimsBackgroundDuringPresentation = NO;
    searchViewController.hidesNavigationBarDuringPresentation = NO;
    [searchViewController.searchBar sizeToFit];
    //设置显示搜索结果的控制器
    searchViewController.searchResultsUpdater = self; //协议(UISearchResultsUpdating)
    //将搜索控制器的搜索条设置为页眉视图
    _messageTableview.tableHeaderView = searchViewController.searchBar;
    _messageTableview.backgroundColor = grayBackgroundLightColor;
    _messageTableview.tableFooterView = [[UIView alloc]init];
    
    searchViewController.searchBar.placeholder = NSLocalizedString(@"搜索列表", @"");
    titleDataArray = [@[NSLocalizedString(@"群助手", @""),NSLocalizedString(@"咨讯", @""),NSLocalizedString(@"我的医生", @"")]mutableCopy];
    titleImageNameArray = [@[@"groups",@"news"]mutableCopy];
#warning 此处加入收到信息的dataarray
    [[FriendDBManager ShareInstance] creatDatabase:FriendDBName];
    [[FriendDBManager ShareInstance] isFriendTableExist:YizhenFriendName];
    FriendDBItem *testItem = [[FriendDBItem alloc]init];
    testItem.friendJID = testToJID;
    testItem.friendName = @"小月卖屁股";
    testItem.friendDescribe = @"永超卖屁股";
    testItem.friendImageUrl = @"永超卖屁股";//头像url
    testItem.friendAge = @"永超卖屁股";//
    testItem.friendGender = @"永超卖屁股";//
    testItem.friendOnlineOrNot = @"0";//
    for (int i=0; i<5; i++) {
        [[FriendDBManager ShareInstance] addFriendObjTablename:YizhenFriendName andchatobj:testItem];
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NotFirstTimeLogin = [defaults stringForKey:@"NotFirstTime"];//no为初次登录，yes则不是
    if (NotFirstTimeLogin) {
//        NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,[defaults objectForKey:@"UserName"],[defaults objectForKey:@"Password"]];
#warning 此处用于测试，正式版本应该是上面这段
        NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",Baseurl,@"闪电侠",@"039877"];
        NSLog(@"url===%@",url);
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            NSLog(@"device activitation res=%d",res);
            if (res == 0) {
                //请求完成
                NSLog(@"userJid === %@,web登录完成，开始xmpp登录",[defaults valueForKey:@"UserJID"]);
#warning 此处为db测试用代码
//                [[DBManager ShareInstance] creatDatabase:DBName];
//                [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID]];
                
//                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                //设定时间格式,这里可以设置成自己需要的格式
//                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];//EEE为周几，EEEE为星期几
//                NSString *currenttime  = [dateFormatter stringFromDate:[NSDate date]];
                
//                DBItem *testItem = [[DBItem alloc]init];
//                testItem.messContent = @"33333";
//                testItem.timeStamp = currenttime;
//                testItem.personJID = testMineJID;
//                testItem.sendPersonJID = testToJID;
//                testItem.personNickName = @"永超喜欢打飞机";
//                testItem.personImageUrl = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
//                testItem.ReadOrNot = 1;
//                testItem.FromMeOrNot = 0;
//                testItem.messType = 0;
//                testItem.chatType = 0;
//                testItem.personJID = @"11111";
                
//                [[DBManager ShareInstance] SetNotReadToRead:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID]];
//                for (int i=0; i<3; i++) {
//                    [[DBManager ShareInstance] addChatobjTablename:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID] andchatobj:testItem];
//                }
                
//                [[DBManager ShareInstance] deleteTable:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID]];
//                FMResultSet *messNumber = [[DBManager ShareInstance] SearchMessNotReadNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID] ItemName:@"ReadOrNot" ItemValue:0];
//                while ([messNumber next]) {
//                    testItem.personNickName = [messNumber stringForColumn:@"ReadOrNot"];
//                }
                
//                FMResultSet *messWithNumber = [[DBManager ShareInstance] SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,testToJID] MessNumber:10 SearchKey:@"chatid" SearchMethodDescOrAsc:@"desc"];
//                while ([messWithNumber next]) {
//                    testItem.personNickName = [messWithNumber stringForColumn:@"messContent"];
//                    NSLog(@"testItem.nickName === %@",testItem.personNickName);
//                }
#warning 正式版中xmpp连接应该用注释中的代码
                if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",testMineJID/*[UserItem ShareInstance].userJID*/,httpServer]]) {
//                    [[XMPPSupportClass ShareInstance] getMyQueryRoster];
                }
            }
            else{
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"WEB端登录失败：%@",error);
        }];
    }
//    NSString *urlu = [NSString stringWithFormat:@"http://api.augbase.com/yiserver/user/login"];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    NSDictionary *dict = @{ @"username":@"闪电侠", @"password":@"039877",@"clienttype":@"1",@"role":@"0"};
//    [manager POST:urlu parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"获取的最终结果：%@",source);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"WEB端登录失败：%@",error);
//    }];
    
    if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",testMineJID/*[UserItem ShareInstance].userJID*/,httpServer]]) {
        
    }
}

#pragma xmpp收到信息后触法的delegate,receieveMess为发送者的jid
-(void)ReceiveMessArray:(NSString *)receiveMess{
    NSLog(@"xmpp收到消息");
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName, receiveMess]];
    tableJidName = [[DBManager ShareInstance] getAllTableName];
#warning 此处需要加入通过jid判断用户name的网络需求
    dataArray = [NSMutableArray arrayWithCapacity:0];
#warning 此处改用同步请求获取好友昵称，为测试用，以后删除，改为登录或者注册后第一次登录的时候录入数据库
    if ([tableJidName count] >0) {
        for (NSString *JID in tableJidName) {
            NSString *url = [NSString stringWithFormat:@"%@user?jid=%@",Baseurl,JID];
            NSLog(@"url===%@",url);
            NSURL *urlWithUrl = [NSURL URLWithString:url];
            //第二步，通过URL创建网络请求
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlWithUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
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
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
            NSString *str = [source objectForKey:@"nickname"];
            NSLog(@"str====%@",str);
            [dataArray addObject:str];
        }
    }
    NSLog(@"数据源为：%@",dataArray);
    searchResults = dataArray;
#warning 此处应该加入收到的讯息存入数据库的功能
    FMResultSet *messWithNumber = [[DBManager ShareInstance] SearchMessNotReadNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,receiveMess] ItemName:@"ReadOrNot" ItemValue:0];
    NSInteger messNumer = 0;
    while ([messWithNumber next]) {
        messNumer++;
    }
    NSLog(@"messNumber===%ld",(long)messNumer);
    if (receiveMess != nil) {
        [((MessTableViewCell *)[_messageTableview viewWithTag:[receiveMess integerValue]]).timeText imageWithRedNumber:messNumer];
    }
    [_messageTableview reloadData];
    
    [[XMPPSupportClass ShareInstance] getMyQueryRoster];
    
    [[XMPPSupportClass ShareInstance] setUpChatRoom:[NSString stringWithFormat: @"%@@%@.%@",@"998899",@"conference",httpServer]];
    
    DBItem *groupChat = [[DBItem alloc]init];
    groupChat.messContent = receiveMess;
//    [[XMPPSupportClass ShareInstance] xmppRoomSendMess:[NSString stringWithFormat: @"%@@%@.%@",@"998899",@"conference",httpServer] ChatMess:groupChat FromUser:testMineJID];
}


-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"blue"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBarHidden = YES;
    
    UIImage* imageNormal = [UIImage imageNamed:@"message_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"message_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarController.tabBar.tintColor = themeColor;
    
    self.view.backgroundColor = grayBackgroundLightColor;
    [self initNavigationBar];
    [[DBManager ShareInstance] creatDatabase:DBName];
    tableJidName = [[DBManager ShareInstance] getAllTableName];
    dataArray = [NSMutableArray arrayWithCapacity:0];
#warning 此处改用同步请求获取好友昵称，为测试用，以后删除，改为登录或者注册后第一次登录的时候录入数据库,此处改为从数据库获取
    if ([tableJidName count] >0) {
        for (NSString *JID in tableJidName) {
            NSString *url = [NSString stringWithFormat:@"%@user?jid=%@",Baseurl,JID];
            NSLog(@"url===%@",url);
            NSURL *urlWithUrl = [NSURL URLWithString:url];
            //第二步，通过URL创建网络请求
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlWithUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
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
                NSLog(@"str====%@",str);
                [dataArray addObject:str];
            }else{
                NSLog(@"无返回");
            }
        }
    }
    NSLog(@"数据源为：%@",dataArray);
    searchResults = dataArray;

    [_messageTableview reloadData];
    [XMPPSupportClass ShareInstance].receiveMessDelegate = self;
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 66)];
//    navigationBar.layer.borderWidth = 0.5;
//    navigationBar.layer.borderColor = themeColor.CGColor;
    navigationBar.backgroundColor = themeColor;
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22+22);
    titleLabel.text = NSLocalizedString(@"消息", @"");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationBar addSubview:titleLabel];
    [self.view addSubview:navigationBar];
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
    return 2;
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
        cell.iconImageView.backgroundColor = themeColor;
        cell.titleText.text = titleDataArray[indexPath.row];
        cell.descriptionText.text = NSLocalizedString(@"小月你又打飞机", @"");//测试用，以后改为传来的讯息,以下同
        cell.timeText.text = @"18:00";
    }else{
        FMResultSet *lastMessResult = [[DBManager ShareInstance]SearchMessWithNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]] MessNumber:1 SearchKey:@"chatid" SearchMethodDescOrAsc:@"Desc"];
        NSString *lastMess;
        NSString *lastTime;
        while ([lastMessResult next]) {
            lastMess = [lastMessResult stringForColumn:@"messContent"];
            lastTime = [lastMessResult stringForColumn:@"timeStamp"];
        }
        cell.iconImageView.image = [UIImage imageNamed:@"test"];
        cell.titleText.text = searchResults[indexPath.row];
        cell.descriptionText.text = lastMess;
        
        cell.timeText.text = lastTime;
        cell.tag = [tableJidName[indexPath.row] integerValue];
        NSLog(@"cell.tag === %ld",(long)[tableJidName[indexPath.row] integerValue]);
        FMResultSet *messWithNumber = [[DBManager ShareInstance] SearchMessNotReadNumber:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]] ItemName:@"ReadOrNot" ItemValue:0];
        NSInteger messNumer = 0;
        while ([messWithNumber next]) {
            messNumer++;
        }
        [cell.timeText imageWithRedNumber:messNumer];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0&&indexPath.row == 0) {
        ChooseGroupViewController *cgv = [[ChooseGroupViewController alloc]init];
        [self.navigationController pushViewController:cgv animated:YES];
#warning 测试用
    }else if(indexPath.section == 0&&indexPath.row == 1){
        HACollectionViewSmallLayout *smallLayout = [[HACollectionViewSmallLayout alloc] init];
        HASmallCollectionViewController *collectionViewController = [[HASmallCollectionViewController alloc] initWithCollectionViewLayout:smallLayout];
        
        self.transitionController = [[HATransitionController alloc] initWithCollectionView:collectionViewController.collectionView];
        self.transitionController.delegate = self;
        [self.navigationController pushViewController:collectionViewController animated:YES];
    }else if(indexPath.section == 0&&indexPath.row == 2){
        
    }else{
        RootViewController *rtv = [[RootViewController alloc]init];
        rtv.privateOrNot = 0;//私聊
        rtv.personJID = [NSString stringWithFormat:@"%ld",[_messageTableview cellForRowAtIndexPath:indexPath].tag];
        [self.navigationController pushViewController:rtv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---edit delete---
//// 让 UITableView 和 UIViewController 变成可编辑状态
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
////    [super setEditing:editing animated:animated];
//
//    [self setEditing:editing animated:animated];
//}

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
        [_messageTableview beginUpdates];
        NSArray *indexPaths = @[indexPath]; // 构建 索引处的行数 的数组
        // 删除 索引的方法 后面是动画样式
        [_messageTableview deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
        [dataArray removeObjectAtIndex:indexPath.row];
#warning 此处加入删除消息的数据库操作
        [[DBManager ShareInstance] creatDatabase:DBName];
        [[DBManager ShareInstance] deleteTable:[NSString stringWithFormat:@"%@%@",YizhenTableName,tableJidName[indexPath.row]]];
         
        tableJidName = [[DBManager ShareInstance] getAllTableName];
        NSLog(@"talbeName == %@",tableJidName);
#warning 此处需要加入通过jid判断用户name的网络需求
        dataArray = [NSMutableArray arrayWithCapacity:0];
#warning 此处改用同步请求获取好友昵称，为测试用，以后删除，改为登录或者注册后第一次登录的时候录入数据库
        if ([tableJidName count] >0) {
            for (NSString *JID in tableJidName) {
                NSString *url = [NSString stringWithFormat:@"%@user?jid=%@",Baseurl,JID];
                NSLog(@"url===%@",url);
                NSURL *urlWithUrl = [NSURL URLWithString:url];
                //第二步，通过URL创建网络请求
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlWithUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
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
                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:nil];
                NSString *str = [source objectForKey:@"nickname"];
                NSLog(@"str====%@",str);
                [dataArray addObject:str];
            }
        }
        NSLog(@"数据源为：%@",dataArray);
#warning 此处需要加入通过jid判断用户name的网络需求
        //    dataArray = [[NSMutableArray alloc]initWithArray:tableJidName];
        searchResults = dataArray;
        
        [_messageTableview  endUpdates];
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
//        headerView.backgroundColor = themeColor;
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        return headerView;
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}

#pragma 加cell进入动画
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (cell.frame.origin.y>ViewHeight/2) {
//        cell.frame = CGRectMake(-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//        [UIView animateWithDuration:0.7 animations:^{
//            cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
//        } completion:^(BOOL finished) {
//            ;
//        }];
//    }
}

- (void)interactionBeganAtPoint:(CGPoint)point
{
    // Very basic communication between the transition controller and the top view controller
    // It would be easy to add more control, support pop, push or no-op
    HASmallCollectionViewController *presentingVC = (HASmallCollectionViewController *)[self.navigationController topViewController];
    HASmallCollectionViewController *presentedVC = (HASmallCollectionViewController *)[presentingVC nextViewControllerAtPoint:point];
    if (presentedVC!=nil)
    {
        [self.navigationController pushViewController:presentedVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if (animationController==self.transitionController) {
        return self.transitionController;
    }
    return nil;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
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
    [[DBManager ShareInstance] closeDB];
    [[FriendDBManager ShareInstance] closeDB];
}
@end
