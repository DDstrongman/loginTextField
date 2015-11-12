//
//  AddFriendByButtonViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddFriendByButtonViewController.h"

#import "ContactPersonDetailViewController.h"
#import "SetupView.h"
#import "WXApi.h"

@interface AddFriendByButtonViewController ()

{
    NSMutableArray *titleArray;//添加好友方式的数组
    NSMutableArray *imageArray;//存对应的方式的icon的数组
    
    NSString *shareUrl;//分享app的url
    
    UIView *shareView;//分享界面
    UIView *visualEffectView;//背景黑色view
}

@end

@implementation AddFriendByButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"添加好友", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([WXApi isWXAppInstalled]&& [WXApi isWXAppSupportApi]) {
        return 5;
    }else{
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchcell" forIndexPath:indexPath];
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:imageArray[indexPath.row]];
        ((UITextField *)[cell viewWithTag:2]).placeholder = titleArray[indexPath.row];
        ((UITextField *)[cell viewWithTag:2]).returnKeyType = UIReturnKeySearch;
        ((UITextField *)[cell viewWithTag:2]).delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorInset = UIEdgeInsetsMake(0, ViewWidth, 0, 0);//上左下右,顺序
    }else if (indexPath.row == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"myinfocell" forIndexPath:indexPath];
        ((UILabel *)[cell viewWithTag:1]).text = [NSString stringWithFormat:@"%@%@",titleArray[indexPath.row],[[NSUserDefaults standardUserDefaults] objectForKey:@"userYizhenID"]];
        ((UILabel *)[cell viewWithTag:1]).textColor = grayLabelColor;
        ((UILabel *)[cell viewWithTag:1]).font = [UIFont systemFontOfSize:14.0];
        cell.backgroundColor = grayBackgroundLightColor;
        cell.layer.borderColor = lightGrayBackColor.CGColor;
        cell.layer.borderWidth = 0.5;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = lightGrayBackColor;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageandlabelcell" forIndexPath:indexPath];
        UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
        cell.accessoryView = tailImageView;
        if (indexPath.row == 2) {
            [cell.contentView viewWithTag:1].backgroundColor = [UIColor colorWithRed:41.0/255.0 green:181.0/255.0 blue:207.0/255.0 alpha:1.0];
        }else if (indexPath.row == 3){
            [cell.contentView viewWithTag:1].backgroundColor = [UIColor colorWithRed:58.0/255.0 green:180.0/255.0 blue:167.0/255.0 alpha:1.0];
        }else{
            [cell.contentView viewWithTag:1].backgroundColor = [UIColor colorWithRed:73.0/255.0 green:200.0/255.0 blue:115.0/255.0 alpha:1.0];
        }
        ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:imageArray[indexPath.row]];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = titleArray[indexPath.row];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = lightGrayBackColor;
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.row == 2) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SimilarFriendViewController *sfv = [main instantiateViewControllerWithIdentifier:@"similarfriend"];
        [self.navigationController pushViewController:sfv animated:YES];
    }else if(indexPath.row == 3){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NearByFriendViewController *nfv = [main instantiateViewControllerWithIdentifier:@"nearbyfriend"];
        [self.navigationController pushViewController:nfv animated:YES];
    }else if (indexPath.row == 4){
        [self shareWeChatAction];
    }else{
        
    }
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
}

#pragma viewdidload等中初始化的方法写在这里
-(void)setupView{
    self.view.backgroundColor = grayBackgroundLightColor;
    _addWaysTable.backgroundColor = grayBackgroundLightColor;
    _addWaysTable.dataSource = self;
    _addWaysTable.delegate = self;
    _addWaysTable.tableFooterView = [[UIView alloc]init];
    [self setupShareView];
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
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.mas_equalTo(shareScroller.mas_bottom).with.offset(10);
        make.right.equalTo(@-20);
        make.height.equalTo(@50);
    }];
}

-(void)setupData{
    titleArray = [@[NSLocalizedString(@"战友号／手机号", @""),NSLocalizedString(@"我的战友号: ", @""),NSLocalizedString(@"相似战友", @""),NSLocalizedString(@"附近战友", @""),NSLocalizedString(@"邀请微信好友", @"")]mutableCopy];
    imageArray = [@[@"search3",@"",@"similar",@"neighborhood",@"wechat2"]mutableCopy];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if ([textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"]]||[textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userYizhenID"]]||[textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userTele"]]) {
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"不能搜索自己", @"") Title:NSLocalizedString(@"您搜索了自己", @"") ViewController:self];
    }else{
        NSString *jidurl;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        jidurl = [NSString stringWithFormat:@"%@v2/user/yizhen_id/%@?uid=%@&token=%@",Baseurl,textField.text,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
        jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([[userInfo objectForKey:@"res"] intValue] == 0) {
                UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
                cpdv.friendJID = textField.text;
                [self.navigationController pushViewController:cpdv animated:YES];
            }else{
                [[SetupView ShareInstance]showAlertView:[[userInfo objectForKey:@"res"] intValue] Hud:nil ViewController:self];
            }
        }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            
        }];
    }
    return YES;
}


#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma 分享
- (void)shareWeChatAction{
    [self popSpringOut:shareView];
}

-(void)cancelShareAction:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)shareWechatFriend:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"快加入战友！找到和你相似的病友";
    message.description = @"哪些战友和我用一样的药、有着同样的指标特征和家族史？来战友，扫一扫化验单，轻松加战友！";
    [message setThumbImage:[UIImage imageNamed:@"weixinIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.yizhenapp.com/about.html";
    
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
    message.title = @"快加入战友！找到和你相似的病友";
    message.description = @"哪些战友和我用一样的药、有着同样的指标特征和家族史？来战友，扫一扫化验单，轻松加战友！";
    [message setThumbImage:[UIImage imageNamed:@"weixinIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.yizhenapp.com/about.html";
    
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

-(void)popSpringOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:shareView];
    
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

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)popSpringAnimationHidden:(UIView *)targetView{
    if (visualEffectView != nil) {
        [visualEffectView removeFromSuperview];
    }
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
