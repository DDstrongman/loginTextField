//
//  CollectionListViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "CollectionListViewController.h"

#import "ShowWebviewViewController.h"

@interface CollectionListViewController ()

{
    NSMutableArray *collectionArray;//收集的信息的数组
}

@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return collectionArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"collectioncell" forIndexPath:indexPath];
//    [[cell.contentView viewWithTag:1] imageWithRound:NO];
    NSDictionary *dic = collectionArray[indexPath.row];
    [((UIImageView *)[cell.contentView viewWithTag:1]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://yizhenimg.augbase.com/author/%@",[dic objectForKey:@"authorimg"]]] placeholderImage:[UIImage imageNamed:@"yulantu_3"]];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = [dic objectForKey:@"q"];
    ((UILabel *)[cell.contentView viewWithTag:3]).text = [dic objectForKey:@"a"];
    ((UILabel *)[cell.contentView viewWithTag:4]).text = [dic objectForKey:@"author"];
    ((UILabel *)[cell.contentView viewWithTag:5]).text = [dic objectForKey:@"publishdate"];
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    ShowWebviewViewController *swv = [[ShowWebviewViewController alloc]init];
    swv.url = [collectionArray[indexPath.row] objectForKey:@"shareurl"];
    [self.navigationController pushViewController:swv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackgroundLightColor;
//    headerView.layer.borderColor = lightGrayBackColor.CGColor;
//    headerView.layer.borderWidth = 0.5;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 0.5)];
    topView.backgroundColor = lightGrayBackColor;
    [headerView addSubview:topView];
    return headerView;
}


-(void)setupView{
    self.title = NSLocalizedString(@"我收藏的咨讯", @"");
    _collectionTable.dataSource = self;
    _collectionTable.delegate = self;
    _collectionTable.tableFooterView = [[UIView alloc]init];
    _collectionTable.backgroundColor = grayBackgroundLightColor;
}

-(void)setupData{
    NSString *url = [NSString stringWithFormat:@"%@unq/collectlist",Baseurl];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uurl=[NSString stringWithFormat:@"%@?uid=%@&token=%@&page=%@&size=%@",url,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],@"0",@"10"];
    NSLog(@"收藏url＝＝＝＝%@",uurl);
    [[HttpManager ShareInstance]AFNetGETSupport:uurl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res==0) {
            collectionArray = [source objectForKey:@"list"];
            [_collectionTable reloadData];
        }
        else{
            
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
