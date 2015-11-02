//
//  SetShareContentRootViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/10.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "SetShareContentRootViewController.h"

#import "ChooseTimeViewController.h"
#import "ChooseTitleViewController.h"

#import "OcrTextResultViewController.h"

#import "WXApi.h"

@interface SetShareContentRootViewController ()<ChooseTimeArrayDele,ChooseTitleArrayDele>

{
    NSMutableArray *tableTitleArray;//标题的数组
    NSMutableArray *setChoosedTitleArray;//设置初始化数组
    NSMutableArray *setChoosedENGTitleArray;//设置初始化英文数组
    NSMutableArray *setChoosedTimeArray;//设置初始化数组
    NSMutableArray *tempTitleArray;//重新整理中文名的数组
    
    UIView *shareView;//底部分享view
    UIView *visualEffectView;//阴影view
    
    NSString *shareUrl;//分享内容的url
}

@end

@implementation SetShareContentRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)cancelShare:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)share:(UIButton *)sender{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *tempTitle;
    NSString *tempTime;
    for (int i = 0; i<setChoosedENGTitleArray.count; i++) {
        if (i==0) {
            tempTitle = setChoosedENGTitleArray[0];
        }else{
            tempTitle = [NSString stringWithFormat:@"%@,%@",tempTitle,setChoosedENGTitleArray[i]];
        }
    }
    for (int i = 0; i<setChoosedTimeArray.count; i++) {
        if (i==0) {
            tempTime = setChoosedTimeArray[0];
        }else{
            tempTime = [NSString stringWithFormat:@"%@,%@",tempTime,setChoosedTimeArray[i]];
        }
    }
    NSString *tempurl = [NSString stringWithFormat:@"%@v2/user/share/indicator/url?uid=%@&token=%@&th=%@&tr=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],tempTitle,tempTime];
    [[HttpManager ShareInstance]AFNetGETSupport:tempurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            shareUrl = [source objectForKey:@"url"];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [self popOutShareView:shareView];
}

-(void)setupView{
    self.title = NSLocalizedString(@"指定分享内容", @"");
    _setShareTable = [[UITableView alloc]init];
    _setShareTable.delegate = self;
    _setShareTable.dataSource = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = lightGrayBackColor.CGColor;
    _setShareTable.tableHeaderView = headerView;
    _setShareTable.tableFooterView = [[UIView alloc]init];
    _setShareTable.backgroundColor = grayBackgroundLightColor;
    _setShareTable.sectionFooterHeight = 22;
    [self.view addSubview:_setShareTable];
    [_setShareTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self setupShareView];
}

-(void)setupShareView{
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 175)];
    shareView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *shareScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, shareView.bounds.size.width, 95)];
    shareScroller.contentSize = CGSizeMake(shareView.bounds.size.width+50, 95);
    [shareView addSubview:shareScroller];
    
    if ([WXApi isWXAppInstalled]&& [WXApi isWXAppSupportApi]) {
        UIButton *shareWeChatButton = [[UIButton alloc]init];
        [shareWeChatButton setBackgroundImage:[UIImage imageNamed:@"wechat_friend"] forState:UIControlStateNormal];
        [shareWeChatButton setTitle:NSLocalizedString(@"微信好友", @"") forState:UIControlStateNormal];
        [shareWeChatButton addTarget:self action:@selector(shareWechatFriend:) forControlEvents:UIControlEventTouchUpInside];
        shareWeChatButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        shareWeChatButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        shareWeChatButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [shareWeChatButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        [shareWeChatButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        shareWeChatButton.titleEdgeInsets = UIEdgeInsetsMake(65, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        UIButton *shareWeChatGroupButton = [[UIButton alloc]init];
        [shareWeChatGroupButton setBackgroundImage:[UIImage imageNamed:@"friend_quan"] forState:UIControlStateNormal];
        [shareWeChatGroupButton addTarget:self action:@selector(shareWechatGroup:) forControlEvents:UIControlEventTouchUpInside];
        [shareWeChatGroupButton setTitle:NSLocalizedString(@"朋友圈", @"") forState:UIControlStateNormal];
        shareWeChatGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareWeChatGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        shareWeChatGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        shareWeChatGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [shareWeChatGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        [shareWeChatGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        shareWeChatGroupButton.titleEdgeInsets = UIEdgeInsetsMake(65, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        //    UIButton *shareQQButton = [[UIButton alloc]init];
        //    [shareQQButton setBackgroundImage:[UIImage imageNamed:@"qq_friends"] forState:UIControlStateNormal];
        //    [shareQQButton setTitle:NSLocalizedString(@"QQ好友", @"") forState:UIControlStateNormal];
        //    [shareQQButton addTarget:self action:@selector(shareQQFriend:) forControlEvents:UIControlEventTouchUpInside];
        //    shareQQButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        //    shareQQButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        //    shareQQButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        //    [shareQQButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        //    [shareQQButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        //    shareQQButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        //    UIButton *shareQQGroupButton = [[UIButton alloc]init];
        //    [shareQQGroupButton setBackgroundImage:[UIImage imageNamed:@"qq_zone"] forState:UIControlStateNormal];
        //    [shareQQGroupButton addTarget:self action:@selector(shareQQZone:) forControlEvents:UIControlEventTouchUpInside];
        //    [shareQQGroupButton setTitle:NSLocalizedString(@"QQ空间", @"") forState:UIControlStateNormal];
        //    shareQQGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        //    shareQQGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
        //    shareQQGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        //    [shareQQGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        //    [shareQQGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        //    shareQQGroupButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        UIButton *cancelButton = [[UIButton alloc]init];
        [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = [UIColor colorWithRed:180.0/255 green:180.0/255 blue:180.0/255 alpha:1.0].CGColor;
        [cancelButton viewWithRadis:10.0];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelShare:) forControlEvents:UIControlEventTouchUpInside];
        [shareView addSubview:cancelButton];
        [shareScroller addSubview:shareWeChatButton];
        [shareScroller addSubview:shareWeChatGroupButton];
        //    [shareScroller addSubview:shareQQButton];
        //    [shareScroller addSubview:shareQQGroupButton];
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
        //    [shareQQButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(shareWeChatGroupButton.mas_right).with.offset(20);
        //        make.top.equalTo(@10);
        //        make.width.equalTo(@57);
        //        make.height.equalTo(@75);
        //    }];
        //    [shareQQGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(shareQQButton.mas_right).with.offset(20);
        //        make.top.equalTo(@10);
        //        make.width.equalTo(@57);
        //        make.height.equalTo(@75);
        //    }];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.mas_equalTo(shareScroller.mas_bottom).with.offset(10);
            make.right.equalTo(@-20);
            make.height.equalTo(@50);
        }];
    }
}

-(void)setupData{
    tempTitleArray = [NSMutableArray array];
    tableTitleArray = [@[NSLocalizedString(@"指定指标", @""),NSLocalizedString(@"指定时间", @""),NSLocalizedString(@"预览表格", @"")]mutableCopy];
    for (int i=0; i<_titleArray.count; i++) {
        [tempTitleArray addObject:[[_titleDic objectForKey:_titleArray[i]] objectForKey:@"showname"]];
    }
}

#pragma delegate在最下方
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1&&indexPath.row == 1) {
        return 90;
    }else{
        return 50;
    }
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"setShareCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    if (indexPath.section == 1&&indexPath.row == 1) {
        UIButton *shareButton = [[UIButton alloc]init];
        [shareButton setTitle:NSLocalizedString(@"分享", @"") forState:UIControlStateNormal];
        [shareButton addTarget: self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [shareButton viewWithRadis:10.0];
        [cell addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.equalTo(@22.5);
            make.right.equalTo(@-20);
            make.bottom.equalTo(@-22.5);
        }];
        cell.backgroundColor = grayBackgroundLightColor;
        if (setChoosedTimeArray.count>0&&setChoosedTitleArray.count>0) {
            shareButton.backgroundColor = themeColor;
            shareButton.userInteractionEnabled = YES;
        }else{
            shareButton.userInteractionEnabled = NO;
            shareButton.backgroundColor = grayBackColor;
        }
    }else if(indexPath.section == 0){
        cell.textLabel.text = tableTitleArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        UIImageView *tailIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
        cell.accessoryView = tailIamgeView;
        if (indexPath.row == 0) {
            if (setChoosedTitleArray.count>2) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@...",setChoosedTitleArray[0],setChoosedTitleArray[1]];
            }else if (setChoosedTitleArray.count == 2){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%@",setChoosedTitleArray[0],setChoosedTitleArray[1]];
            }else if (setChoosedTitleArray.count == 1){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",setChoosedTitleArray[0]];
            }
        }else{
            if (setChoosedTimeArray.count>1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@...",setChoosedTimeArray[0]];
            }else if (setChoosedTimeArray.count == 1){
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",setChoosedTimeArray[0]];
            }
        }
    }else{
        cell.textLabel.text = tableTitleArray[indexPath.row+2];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        UIImageView *tailIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
        cell.accessoryView = tailIamgeView;
        cell.backgroundColor = [UIColor whiteColor];
        if (setChoosedTimeArray.count>0&&setChoosedTitleArray.count>0) {
            cell.textLabel.textColor = [UIColor blackColor];
        }else{
            cell.textLabel.textColor = [UIColor colorWithWhite:0 alpha:0.3];
        }
        if (indexPath.row == 0) {
            cell.layer.borderColor = lightGrayBackColor.CGColor;
            cell.layer.borderWidth = 0.5;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ChooseTitleViewController *ctv = [[ChooseTitleViewController alloc]init];
            ctv.titleArray = tempTitleArray;
            ctv.titleENGArray = _titleArray;
            ctv.setChoosedTitleArray = setChoosedTitleArray;
            ctv.chooseTitleArrayDele = self;
            [self.navigationController pushViewController:ctv animated:YES];
        }else{
            ChooseTimeViewController *ctv = [[ChooseTimeViewController alloc]init];
            ctv.timeArray = _timeArray;
            ctv.chooseTimeArrayDele = self;
            ctv.setChoosedTimeArray = setChoosedTimeArray;
            [self.navigationController pushViewController:ctv animated:YES];
        }
    }else{
        if (indexPath.row == 0) {
            if (setChoosedTimeArray.count>0&&setChoosedTitleArray.count>0) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                OcrTextResultViewController *otrv = [story instantiateViewControllerWithIdentifier:@"ocrtextresult"];
                otrv.isMine = YES;
                otrv.isReView = YES;
                otrv.viewedTitleArray = setChoosedENGTitleArray;
                otrv.viewedTimeArray = setChoosedTimeArray;
                [self.navigationController pushViewController:otrv animated:YES];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        FooterView.layer.borderWidth = 0.5;
        FooterView.layer.borderColor = lightGrayBackColor.CGColor;
        FooterView.backgroundColor = grayBackgroundLightColor;
        return FooterView;
    }else{
        UIView *FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        FooterView.backgroundColor = [UIColor clearColor];
        return FooterView;
    }
}

-(void)chooseTimeArray:(NSArray *)choosedArray{
    setChoosedTimeArray = [NSMutableArray arrayWithArray:choosedArray];
    [_setShareTable reloadData];
}

-(void)chooseTitleArray:(NSArray *)choosedArray ChoosedENGArray:(NSArray *)choosedENGArray{
    setChoosedTitleArray = [NSMutableArray arrayWithArray:choosedArray];
    setChoosedENGTitleArray = [NSMutableArray arrayWithArray:choosedENGArray];
    [_setShareTable reloadData];
}

-(void)shareWechatFriend:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"一键分享战友肝病随访表格";
    NSLog(@"setchoosetime===%@,day====%@",setChoosedTimeArray,[self intervalFromLastDate:setChoosedTimeArray[0] toTheDate:setChoosedTimeArray[setChoosedTimeArray.count-1]]);
    message.description = [NSString stringWithFormat:@"这是一份长达%@天的病情汇总，麻烦您帮忙分析一下？",[self intervalFromLastDate:setChoosedTimeArray[0] toTheDate:setChoosedTimeArray[setChoosedTimeArray.count-1]]];
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl;
    
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
    message.title = @"一键分享战友肝病随访表格";
    NSLog(@"setchoosetime===%@,day====%@",setChoosedTimeArray,[self intervalFromLastDate:setChoosedTimeArray[0] toTheDate:setChoosedTimeArray[setChoosedTimeArray.count-1]]);
    message.description = [NSString stringWithFormat:@"这是一份长达%@天的病情汇总，麻烦您帮忙分析一下？",[self intervalFromLastDate:setChoosedTimeArray[0] toTheDate:setChoosedTimeArray[setChoosedTimeArray.count-1]]];
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl;
    
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

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma 底部view出现和隐藏
-(void)popOutShareView:(UIView *)targetView{
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

- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSLog(@"date1====%@,date2====%@",dateString1,dateString2);
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
     [inputFormatter setDateFormat:@"yyyy-MM-dd"];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSDate* date2 = [inputFormatter dateFromString:dateString1];//为保证是正数需要大减小
    NSDate* date1 = [inputFormatter dateFromString:dateString2];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:date1 toDate:date2 options:0];
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day = [d day];
    return [NSString stringWithFormat:@"%ld",(long)day+month*30+year*365];
}


@end
