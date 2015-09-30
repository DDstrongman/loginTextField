//
//  YizhenClassroomViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/18.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "YizhenClassroomViewController.h"
#import "ShowClassQuestionViewController.h"

#import "MJRefresh.h"

@interface YizhenClassroomViewController ()

{
    NSMutableArray *classDataArray;//小易课堂的数组
}

@property (strong, nonatomic) MJRefreshFooterView *foot;
@property (nonatomic) NSInteger messTime;

@end

@implementation YizhenClassroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRefreshViews];
    [self setupView];
    [self setupData];
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    //load more
    int pageNum = 5;
    _foot = [MJRefreshFooterView footer];
    _foot.scrollView = _messTable;
    _foot.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //#warning 此处需要加入从数据库获取数据
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@que/all?uid=%@&token=%@&articleType=%d&page=%d&size=%ld",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],0,0,(10+pageNum*weakSelf.messTime)];
        [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            if (res == 0) {
                classDataArray = [source objectForKey:@"list"];
                weakSelf.messTime++;
                [weakSelf.messTable reloadData];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.messTable reloadData];
        });
        [weakSelf.foot endRefreshing];
    };
}

-(void)setupView{
    self.title = NSLocalizedString(@"小易课堂", @"");
    _messTable.delegate = self;
    _messTable.dataSource = self;
    _messTable.tableFooterView = [[UIView alloc]init];
}

-(void)setupData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@que/all?uid=%@&token=%@&articleType=%d&page=%d&size=%d",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],0,0,10];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            classDataArray = [source objectForKey:@"list"];
            [_messTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return classDataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yizhenclasscell"];
    ((UILabel *)[cell.contentView viewWithTag:1]).text = [classDataArray[indexPath.row] objectForKey:@"q"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowClassQuestionViewController *sqv = [[ShowClassQuestionViewController alloc]init];
    sqv.url = [classDataArray[indexPath.row] objectForKey:@"shareurl"];
    [self.navigationController pushViewController:sqv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
