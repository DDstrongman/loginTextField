//
//  MessNewsViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/31.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MessNewsViewController.h"

#import "MJRefresh.h"

#import "ShowWebviewViewController.h"
#import "WXApi.h"

@interface MessNewsViewController ()

{
    NSMutableArray *newsDataArray;//咨询信息数组
    UIView *shareView;//底部分享view
    UIView *visualEffectView;//黑色半透明覆盖的view
}

@property (strong, nonatomic) MJRefreshFooterView *foot;
@property (nonatomic) NSInteger messTime;


@end

@implementation MessNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _newsTable.delegate = self;
    _newsTable.dataSource = self;
//    _newsTable.showsVerticalScrollIndicator = NO;
    UIView *tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    tableHeader.backgroundColor = grayBackColor;
    _newsTable.tableHeaderView = tableHeader;
    _newsTable.tableFooterView = [[UIView alloc]init];
    [self addRefreshViews];
    [self setupShareView];
    [self setupData];
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    //load more
    int pageNum = 5;
    _foot = [MJRefreshFooterView footer];
    _foot.scrollView = _newsTable;
    _foot.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//#warning 此处需要加入从数据库获取数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@que/all?uid=%@&token=%@&articleType=%d&page=%d&size=%ld",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],1,0,(5+pageNum*weakSelf.messTime)];
        [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                newsDataArray = [source objectForKey:@"list"];
                weakSelf.messTime++;
                [weakSelf.newsTable reloadData];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.newsTable reloadData];
        });
        [weakSelf.foot endRefreshing];
    };
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
    UIButton *shareQQButton = [[UIButton alloc]init];
    [shareQQButton setBackgroundImage:[UIImage imageNamed:@"qq_friends"] forState:UIControlStateNormal];
    [shareQQButton setTitle:NSLocalizedString(@"QQ好友", @"") forState:UIControlStateNormal];
    [shareQQButton addTarget:self action:@selector(shareQQFriend:) forControlEvents:UIControlEventTouchUpInside];
    shareQQButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareQQButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareQQButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareQQButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareQQButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareQQButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    UIButton *shareQQGroupButton = [[UIButton alloc]init];
    [shareQQGroupButton setBackgroundImage:[UIImage imageNamed:@"qq_zone"] forState:UIControlStateNormal];
    [shareQQGroupButton addTarget:self action:@selector(shareQQZone:) forControlEvents:UIControlEventTouchUpInside];
    [shareQQGroupButton setTitle:NSLocalizedString(@"QQ空间", @"") forState:UIControlStateNormal];
    shareQQGroupButton.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,shareQQGroupButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    shareQQGroupButton.titleLabel.font = [UIFont systemFontOfSize:12];//title字体大小
    shareQQGroupButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [shareQQGroupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [shareQQGroupButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    shareQQGroupButton.titleEdgeInsets = UIEdgeInsetsMake(55, -shareWeChatButton.titleLabel.bounds.size.width, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
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
    [shareScroller addSubview:shareQQButton];
    [shareScroller addSubview:shareQQGroupButton];
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
    [shareQQButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareWeChatGroupButton.mas_right).with.offset(20);
        make.top.equalTo(@10);
        make.width.equalTo(@57);
        make.height.equalTo(@75);
    }];
    [shareQQGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shareQQButton.mas_right).with.offset(20);
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return newsDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 320;
    }else{
        
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"newscell" forIndexPath:indexPath];
        ((UILabel *)[cell.contentView viewWithTag:1]).text = [newsDataArray[indexPath.section] objectForKey:@"q"];
        [((UIButton *)[cell.contentView viewWithTag:2]) setTitle:[newsDataArray[indexPath.section] objectForKey:@"author"] forState:UIControlStateNormal];
        [((UIButton *)[cell.contentView viewWithTag:2]) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [((UIButton *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(showNewsWriteMess:) forControlEvents:UIControlEventTouchUpInside];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/author/%@",[newsDataArray [indexPath.section] objectForKey:@"authorimg"]]]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    // do something with image
                                    [((UIButton *)[cell.contentView viewWithTag:2]) setImage:image forState:UIControlStateNormal];
                                }
                            }];
        [((UIImageView *)[cell.contentView viewWithTag:3]) sd_setImageWithURL:[NSURL URLWithString:[newsDataArray[indexPath.section] objectForKey:@"articleimg"]] placeholderImage:[UIImage imageNamed:@"test"]];
        ((UILabel *)[cell.contentView viewWithTag:4]).text = [newsDataArray[indexPath.section] objectForKey:@"content"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"shareandcollectcell" forIndexPath:indexPath];
        [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        if ([[newsDataArray[indexPath.section] objectForKey:@"iscollect"] intValue] == 0) {
            [((UIButton *)[cell.contentView viewWithTag:2]) setImage:[UIImage imageNamed:@"collect2"] forState:UIControlStateNormal];
        }else{
            [((UIButton *)[cell.contentView viewWithTag:2]) setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        }
        [((UIButton *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(collectArticle:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = [[newsDataArray[indexPath.section] objectForKey:@"id"] integerValue];
    return cell;
}

// 当下载完成后，调用回调方法，使下载的图片显示
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    // Do something with the downloaded image
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackColor;
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    ShowWebviewViewController *swv = [[ShowWebviewViewController alloc]init];
    swv.url = [newsDataArray[indexPath.section] objectForKey:@"shareurl"];
    [self.navigationController pushViewController:swv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showNewsWriteMess:(UIButton *)sender{
    NSLog(@"加入获取作者信息的提示框");
}

-(void)collectArticle:(UIButton *)sender{
    NSLog(@"super===%@,supsuper===%@,tag====%ld",sender.superview,sender.superview.superview,(long)sender.superview.superview.tag);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@unq/collect?uid=%@&token=%@&queid=%ld",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],(long)sender.superview.superview.tag];
    NSLog(@"收藏url===%@",url);
    [[HttpManager ShareInstance] AFNetPOSTNobodySupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"上传成功");
            [self setupData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setupData{
    _messTime = 1;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@que/all?uid=%@&token=%@&articleType=%d&page=%d&size=%d",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],0,0,5];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            newsDataArray = [source objectForKey:@"list"];
            [_newsTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma 分享
- (void)shareAction{
    [self popSpringOut:shareView];
}

-(void)cancelShareAction:(UIButton *)sender{
    [self popSpringAnimationHidden:shareView];
}

-(void)shareWechatFriend:(UIButton *)sender{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"易诊app";
    message.description = @"易诊就是您的发展方向啊";
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
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
    message.title = @"易诊app";
    message.description = @"易诊就是您的发展方向啊";
    [message setThumbImage:[UIImage imageNamed:@"test"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://tech.qq.com/zt2012/tmtdecode/252.htm";
    
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
