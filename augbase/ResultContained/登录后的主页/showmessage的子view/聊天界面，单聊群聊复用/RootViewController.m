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
#import "UUMessageFrame.h"
#import "UUMessage.h"

#import "ImageAndLabelView.h"
#import "ContactPersonDetailViewController.h"

#import "SetShareContentRootViewController.h"//通过复用指定分享内容页面发送大表内容
#import "MineSettingInfoViewController.h"

#import "YizhenWebViewController.h"
#import "WriteFileSupport.h"

@interface RootViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate,SendTableResultDele,ShowWebViewDele>

@property (strong, nonatomic) MJRefreshHeaderView *head;
@property (strong, nonatomic) ChatModel *chatModel;
@property (nonatomic) NSInteger messTime;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation RootViewController{
    UUInputFunctionView *IFView;
    UIScrollView *bottomChooseView;//底部选择照片还是啥的功能集合的view
    NSMutableArray *titleArray;
    NSMutableArray *customizedIdsOrder;
    NSMutableDictionary *allCodeDetails;
    BOOL showBottom;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"通讯好友的jid====%@",_personJID);
    _messTime = 1;
    self.view.backgroundColor = grayBackgroundLightColor;
    _chatTableView.backgroundColor = grayBackgroundLightColor;
    [self initBar];
    [self setupBottomView];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
    [self setNotReadToRead];
}

-(void)setupBottomView{
    bottomChooseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 216)];
    bottomChooseView.pagingEnabled = YES;
    bottomChooseView.contentSize = CGSizeMake(ViewWidth, 100);
    bottomChooseView.delegate = self;
    bottomChooseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomChooseView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCamera)];
    tap.numberOfTapsRequired = 1;
    float spaceWidth = (ViewWidth-59*4)/5;
    ImageAndLabelView *cameraView = [[ImageAndLabelView alloc]initWithFrame:CGRectMake(spaceWidth, 12, 59, 80)];
    cameraView.titleImageView.image = [UIImage imageNamed:@"take3"];
    cameraView.titleLabel.text = NSLocalizedString(@"照片", @"");
    [bottomChooseView addSubview:cameraView];
    [cameraView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapLab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openLab)];
    tapLab.numberOfTapsRequired = 1;
    ImageAndLabelView *labView = [[ImageAndLabelView alloc]initWithFrame:CGRectMake(spaceWidth*2+59, 12, 59, 80)];
    labView.titleImageView.image = [UIImage imageNamed:@"photo"];
    labView.titleLabel.text = NSLocalizedString(@"相册", @"");
    [bottomChooseView addSubview:labView];
    [labView addGestureRecognizer:tapLab];
    
    UITapGestureRecognizer *tapTable = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openDiseaseTable)];
    tapTable.numberOfTapsRequired = 1;
    ImageAndLabelView *diseaseTableView = [[ImageAndLabelView alloc]initWithFrame:CGRectMake(59*2+spaceWidth*3, 12, 59, 80)];
    diseaseTableView.titleImageView.image = [UIImage imageNamed:@"form2"];
    diseaseTableView.titleLabel.text = NSLocalizedString(@"识别结果", @"");
    [bottomChooseView addSubview:diseaseTableView];
    [diseaseTableView addGestureRecognizer:tapTable];
}

-(void)setNotReadToRead{
    [[DBManager ShareInstance] creatDatabase:DBName];
    if([[DBManager ShareInstance] isChatTableExist:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]]){
        [[DBManager ShareInstance] SetNotReadToRead:[NSString stringWithFormat:@"%@%@",YizhenTableName,_personJID]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [XMPPSupportClass ShareInstance].receiveMessDelegate = self;
    self.navigationController.navigationBarHidden = NO;
    _chatModel.isGroupChat = _privateOrNot;
    _chatModel.rootNavC = self;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

-(void)ReceiveMessArray:(NSString *)receiveJID ChatItem:chatItem{
    [self.chatModel.dataSource removeAllObjects];
    [self.chatModel addCellFromDB:_personJID MessNumber:10];
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

- (void)initBar{
    self.title = _personName;
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    //load more
    int pageNum = 5;
    _head = [MJRefreshHeaderView header];
    _head.scrollView = self.chatTableView;
    _head.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [weakSelf.chatModel addCellFromDB:weakSelf.personJID MessNumber:10+pageNum*weakSelf.messTime];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.chatTableView reloadData];
            if (weakSelf.chatModel.dataSource.count>0) {
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            weakSelf.messTime++;
        });
        [weakSelf.head endRefreshing];
    };
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel addCellFromDB:_personJID MessNumber:10];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    [IFView.btnSendMessage addTarget:self action:@selector(showBottomView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)showBottomView{
    showBottom = YES;
    [self.view endEditing:YES];
    [self popSpringOut:bottomChooseView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:7];
    
    //adjust ChatTableView's height
    self.bottomConstraint.constant = 216+45;
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = ViewHeight-216 - newFrame.size.height - 66+3;
    IFView.frame = newFrame;
    [UIView commitAnimations];
    [self tableViewScrollToBottom];
}

-(void)hideBottomView{
    showBottom = NO;
    [self popSpringAnimationHidden:bottomChooseView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:7];
    
    //adjust ChatTableView's height
    self.bottomConstraint.constant = 45;
    [self.view layoutIfNeeded];
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = ViewHeight - newFrame.size.height - 66+3;
    IFView.frame = newFrame;
    [UIView commitAnimations];
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
        self.bottomConstraint.constant = keyboardEndFrame.size.height+45;
        [self popSpringAnimationHidden:bottomChooseView];
    }else{
        self.bottomConstraint.constant = 45;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - 66+3;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = IFView;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"") message:NSLocalizedString(@"您的设备没有照相机", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openLab{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = IFView;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
}

-(void)openDiseaseTable{
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"打开大表中...", @"")];
    if ([[WriteFileSupport ShareInstance]isFileExist:yizhenMineTable]) {
        titleArray = [[WriteFileSupport ShareInstance]readArray:yizhenMineTable FileName:yizhenkeysOrder];
        customizedIdsOrder = [[WriteFileSupport ShareInstance]readArray:yizhenMineTable FileName:yizhencustomizedIdsOrder];
        allCodeDetails = [[WriteFileSupport ShareInstance]readDictionary:yizhenMineTable FileName:yizhenallCodeDetails];
        
        SetShareContentRootViewController *ssv = [[SetShareContentRootViewController alloc]init];
        ssv.titleDic = allCodeDetails;
        ssv.titleArray = customizedIdsOrder;
        ssv.timeArray = titleArray;
        ssv.shareOrSend = YES;
        ssv.sendTableResultDele = self;
        [[SetupView ShareInstance]hideHUD];
        [self.navigationController pushViewController:ssv animated:YES];
    }else{
        titleArray = [NSMutableArray array];
        customizedIdsOrder = [NSMutableArray array];
        allCodeDetails = [NSMutableDictionary dictionary];
        NSString *url;
        url = [NSString stringWithFormat:@"%@v2/indicator/listall?uid=%@&token=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"]];
        [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                titleArray = [source objectForKey:@"keysOrder"];
                customizedIdsOrder = [source objectForKey:@"customizedIdsOrder"];
                allCodeDetails = [source objectForKey:@"allCodeDetails"];
                SetShareContentRootViewController *ssv = [[SetShareContentRootViewController alloc]init];
                ssv.titleDic = allCodeDetails;
                ssv.titleArray = customizedIdsOrder;
                ssv.timeArray = titleArray;
                ssv.shareOrSend = YES;
                ssv.sendTableResultDele = self;
                [[SetupView ShareInstance]hideHUD];
                [self.navigationController pushViewController:ssv animated:YES];
            }else{
                [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
            }
        }  FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"WEB端登录失败：%@",error);
        }];
    }

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
#pragma 此处加上上传大表的功能
-(void)SendTableResult:(BOOL)Result ShareUrl:(NSString *)shareUrl{
    if (Result) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [dic setObject:[NSString stringWithFormat:@"%@的识别结果",[user objectForKey:@"userNickName"]] forKey:@"urlTitle"];
        [dic setObject:shareUrl forKey:@"urlContent"];
        [dic setObject:@(UUMessageTypeTable) forKey:@"type"];
        [self dealTheFunctionData:dic];
    }
}

#pragma 此处加入发送事件
- (void)dealTheFunctionData:(NSDictionary *)dic
{
    id messType = [dic objectForKey:@"type"];
    id messContent;
    int MessNumber;
    if ([messType isEqualToNumber:[NSNumber numberWithInt:0]]) {
        messContent = [dic objectForKey:@"strContent"];
        MessNumber = 0;
    }else if ([messType isEqualToNumber:[NSNumber numberWithInt:1]]){
        MessNumber = 1;
    }else if ([messType isEqualToNumber:[NSNumber numberWithInt:2]]){
        MessNumber = 2;
    }else if ([messType isEqualToNumber:[NSNumber numberWithInt:3]]){
        MessNumber = 3;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss EEE"];//EEE为周几，EEEE为星期几
    NSString *currenttime  = [dateFormatter stringFromDate:[NSDate date]];
    
    DBItem *chatDBItem = [[DBItem alloc]init];
    chatDBItem.messContent = messContent;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userJID = [userDefault objectForKey:@"userJID"];
    chatDBItem.personJID = userJID;
    chatDBItem.toPersonJID = _personJID;
    if ([[userDefault objectForKey:@"userNickName"] isEqualToString:@""]) {
        chatDBItem.personNickName = defaultUserName;
    }else{
        chatDBItem.personNickName = [userDefault objectForKey:@"userNickName"];
    }

    chatDBItem.personImageUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"userHttpImageUrl"];;
    chatDBItem.messType = MessNumber;
    if (MessNumber == 1) {
        chatDBItem.messPic = [dic objectForKey:@"picture"];
    }else if(MessNumber == 2){
        chatDBItem.messVoice = [dic objectForKey:@"voice"];
        chatDBItem.messVoiceTime = [dic objectForKey:@"strVoiceTime"];
    }else if (MessNumber == 3){
        chatDBItem.messTableUrl = [dic objectForKey:@"urlContent"];
        chatDBItem.messTableTitle = [dic objectForKey:@"urlTitle"];
    }
    
    chatDBItem.chatType = 0;//私聊
    chatDBItem.timeStamp = currenttime;
    chatDBItem.FromMeOrNot = 0;
    chatDBItem.ReadOrNot = 1;
    
    if ([[XMPPSupportClass ShareInstance] sendMess:chatDBItem toUserJID:_personJID FromUserJID:userJID]) {
        [self.chatModel addCellFromDB:_personJID MessNumber:10];
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
        cell.showWebDele = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self hideBottomView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    if (showBottom) {
        [self hideBottomView];
    }
}

#pragma mark - cellDelegate,此处添加点击头像的响应函数,并加入区分群聊和单聊
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSInteger)userId{
    if (userId) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ContactPersonDetailViewController *cpdv = [story instantiateViewControllerWithIdentifier:@"contactpersondetail"];
        cpdv.isJIDOrYizhenID = NO;
        cpdv.friendJID = _personJID;
        [self.navigationController pushViewController:cpdv animated:YES];
    }else{
        MineSettingInfoViewController *msiv = [[MineSettingInfoViewController alloc]init];
        [self.navigationController pushViewController:msiv animated:YES];
    }
}

#pragma CELL点击事件
-(void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage{
    
}

#pragma 接收完图片或者语音后刷新界面
-(void)FlushTable:(BOOL)result{
    if (result) {
        [_chatTableView reloadData];
    }
}

-(void)ShowWebView:(NSString *)Url MineOrOther:(NSInteger)from{
    YizhenWebViewController *ywv = [[YizhenWebViewController alloc]init];
    ywv.url = Url;
    if (from == 0) {
        ywv.personName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userNickName"];
    }else{
        ywv.personName = _personName;
    }
    [self.navigationController pushViewController:ywv animated:YES];
}

-(void)popSpringOut:(UIView *)targetView{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height-22-44,targetView.bounds.size.width,targetView.bounds.size.height)];
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


@end
