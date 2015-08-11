//
//  RootViewController.m
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import "RootViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

@interface RootViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) MJRefreshHeaderView *head;
@property (strong, nonatomic) ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation RootViewController{
    UUInputFunctionView *IFView;
    UISegmentedControl *titleSegment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBar];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
    [self setNotReadToRead];
}

-(void)setNotReadToRead{
#warning 此处应该加入选择的对象jid
    [[DBManager ShareInstance] creatDatabase:DBName];
    if([[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]]){
        [[DBManager ShareInstance] SetNotReadToRead:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [XMPPSupportClass ShareInstance].receiveMessDelegate = self;
    self.navigationController.navigationBarHidden = NO;
    _chatModel.isGroupChat = _privateOrNot;
    titleSegment.selectedSegmentIndex = _privateOrNot;
    if (_privateOrNot == 1) {
        UIButton *groupDetailButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
        [groupDetailButton setBackgroundImage:[UIImage imageNamed:@"friends_set"] forState:UIControlStateNormal];
        [groupDetailButton addTarget:self action:@selector(groupDetail) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:groupDetailButton]];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNewMess) name:ReceiveNewMess object:nil];
}

-(void)ReceiveMessArray:(NSString *)receiveJID{
    NSLog(@"接收到通知");
#warning 此处需要加入从数据库获取数据
    [self.chatModel.dataSource removeAllObjects];
    [self.chatModel addCellFromDB:receiveJID];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
    [[DBManager ShareInstance] creatDatabase:DBName];
    [[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]];
    [[DBManager ShareInstance] SetNotReadToRead:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma 群聊查看群信息
-(void)groupDetail{
    NSLog(@"加入查看群信息函数");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GroupDetailViewController *gdv = [main instantiateViewControllerWithIdentifier:@"groupdetail"];
    [self.navigationController pushViewController:gdv animated:YES];
}

- (void)initBar
{
    titleSegment = [[UISegmentedControl alloc]initWithItems:@[@" private ",@" group "]];
    [titleSegment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    titleSegment.selectedSegmentIndex = 0;
    self.navigationItem.titleView = titleSegment;
    
//    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:nil action:nil];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:nil];
}
- (void)segmentChanged:(UISegmentedControl *)segment
{
#warning 此处需要加入从数据库获取数据
    self.chatModel.isGroupChat = segment.selectedSegmentIndex;
    [self.chatModel.dataSource removeAllObjects];
    
    [self.chatTableView reloadData];
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;
    
    _head = [MJRefreshHeaderView header];
    _head.scrollView = self.chatTableView;
    _head.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
#warning 此处需要加入从数据库获取数据
//        [weakSelf.chatModel addRandomItemsToDataSource:_MessTableArray];
        
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chatTableView reloadData];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [weakSelf.head endRefreshing];
    };
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    //    [self.chatModel populateRandomDataSource:_MessTableArray];
#warning 此处需要加入从数据库获取数据
    [self.chatModel addCellFromDB:testMineJID];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
//    IFView.center = CGPointMake(ViewWidth/2, ViewHeight/2);
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 66;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom{
    if (self.chatModel.dataSource.count == 0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

#pragma 此处加入上传图片的功能
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

#pragma 此处加入上传音频的功能
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

#pragma 此处加入发送事件
- (void)dealTheFunctionData:(NSDictionary *)dic
{
#warning 需要加入正常发送情况下的代码,text已经可以了，差音频和图片
    id messType = [dic objectForKey:@"type"];
    id messContent;
    int MessNumber;
    if ([messType isEqualToNumber:[NSNumber numberWithInt:0]]) {
        messContent = [dic objectForKey:@"strContent"];
        MessNumber = 0;
    }else if ([messType isEqualToNumber:[NSNumber numberWithInt:1]]){
        MessNumber = 1;
    }else if ([messType isEqualToNumber:[NSNumber numberWithInt:2]]){        MessNumber = 2;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];//EEE为周几，EEEE为星期几
    NSString *currenttime  = [dateFormatter stringFromDate:[NSDate date]];
    
    
    DBItem *chatDBItem = [[DBItem alloc]init];
    chatDBItem.messContent = messContent;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userJID = [userDefault objectForKey:@"userJID"];
#warning 正式版本中testMineJID应该用上方的userJID
    chatDBItem.personJID = testMineJID;
    chatDBItem.sendPersonJID = _personJID;
    chatDBItem.personNickName = @"永超爱打飞机";
    chatDBItem.personImageUrl = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    chatDBItem.messType = MessNumber;
    chatDBItem.chatType = 0;//私聊
    chatDBItem.timeStamp = currenttime;
    
    chatDBItem.FromMeOrNot = 0;
    chatDBItem.ReadOrNot = 1;
    
    
    if ([[XMPPSupportClass ShareInstance] sendMess:chatDBItem toUserJID:_personJID FromUserJID:testMineJID]) {
#warning 正式版本中testMineJID应该用上方的userJID
        [self.chatModel addCellFromDB:testMineJID];
        [self.chatTableView reloadData];
        [self tableViewScrollToBottom];
    }
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate,此处添加点击头像的响应函数,并加入区分群聊和单聊
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    NSLog(@"此处添加点击头像的响应函数,并加入区分群聊和单聊");
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
//    [alert show];
    if (!_privateOrNot) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        RootPrivateInfoViewController *rpiv = [story instantiateViewControllerWithIdentifier:@"rootprivate"];
        rpiv.personJID = _personJID;
        rpiv.personImage = [cell.btnHeadImage backgroundImageForState:UIControlStateNormal];
        [self.navigationController pushViewController:rpiv animated:YES];
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StrangerViewController *rpiv = [story instantiateViewControllerWithIdentifier:@"stranger"];
        rpiv.strangerImage = [cell.btnHeadImage backgroundImageForState:UIControlStateNormal];
        [self.navigationController pushViewController:rpiv animated:YES];
    }
}

#pragma CELL点击事件
-(void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage{
    
}
@end
