//
//  NearByFriendViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/16.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "NearByFriendViewController.h"

#import "ContactPersonDetailViewController.h"
#import "SendAddMessViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NearByFriendViewController ()<CLLocationManagerDelegate>

{
    NSMutableArray *dataArray;//搜索的数据元数组
    CLLocationManager *locationManager;
}

@end

@implementation NearByFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nearbyFriendTable.delegate = self;
    _nearbyFriendTable.dataSource = self;
    _nearbyFriendTable.backgroundColor = grayBackgroundLightColor;
    _nearbyFriendTable.tableFooterView = [[UIView alloc]init];
    dataArray = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"附近战友", @"");
    [self setupData];
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"加载中", @"")];
}

-(void)setupData{
    
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
            NSLog(@"上传成功");
            NSString *nearUrl = [NSString stringWithFormat:@"%@v2/user/nearbyUser?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
            NSLog(@"nearurl====%@",nearUrl);
            [[HttpManager ShareInstance]AFNetGETSupport:nearUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *nearSource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                int res=[[nearSource objectForKey:@"res"] intValue];
                if (res == 0) {
                    dataArray = [nearSource objectForKey:@"users"];
                    [_nearbyFriendTable reloadData];
                    [[SetupView ShareInstance]hideHUD];
                }else{
                    [[SetupView ShareInstance]hideHUD];
                    [[SetupView ShareInstance]showAlertView:res Hud:nil ViewController:self];
                }
            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma 此处需要加入showDetal为YES的cell，即显示病种和用药的cell，暂未加入
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"nearbyfriendcell" forIndexPath:indexPath];
    if (dataArray.count > 0) {
        NSString *sex;
        [((UIImageView *)[cell.contentView viewWithTag:1]) sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PersonImageUrl,[dataArray[indexPath.row] objectForKey:@"avatar"]]] placeholderImage:[UIImage imageNamed:@"icon.jpg"]];
        [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
        [[cell.contentView viewWithTag:7] viewWithRadis:1.0];
        ((UILabel *)[cell.contentView viewWithTag:2]).text = [dataArray[indexPath.row] objectForKey:@"name"];
        if ([[dataArray[indexPath.row] objectForKey:@"gerder"] intValue] == 1) {
            sex = NSLocalizedString(@"女", @"");
        }else{
            sex = NSLocalizedString(@"男", @"");
        }
        ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%@ / %@",sex,[[dataArray[indexPath.row] objectForKey:@"age"] stringValue]];
        if ([[dataArray[indexPath.row] objectForKey:@"distance"] floatValue]<0.1) {
            [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:NSLocalizedString(@"100米以内", @"") forState:UIControlStateNormal];
        }else{
            [((UIButton *)[cell.contentView viewWithTag:4]) setTitle:[NSString stringWithFormat:@"%.1f km",[[dataArray[indexPath.row] objectForKey:@"distance"] floatValue]] forState:UIControlStateNormal];
        }
        if ([[dataArray[indexPath.row] objectForKey:@"introduction"] isEqualToString:@""]) {
            
            ((UILabel *)[cell.contentView viewWithTag:5]).text = NSLocalizedString(@"TA还在休息呢，暂无签名", @"");
        }else{
            ((UILabel *)[cell.contentView viewWithTag:5]).text = [dataArray[indexPath.row] objectForKey:@"introduction"];
        }
        ((UILabel *)[cell.contentView viewWithTag:6]).text = [[[dataArray[indexPath.row] objectForKey:@"similarity"] stringValue] stringByAppendingString:@"%"];
        [((UIButton *)[cell.contentView viewWithTag:7]) addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
        cell.tag = indexPath.row;
    }
    return cell;
}

#pragma 添加加为好友的函数,获取对应的cell可以通过sender.superview来获取
-(void)addFriend:(UIButton *)sender{
    NSLog(@"加上加为好友的响应函数，网络通讯");
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smc = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    smc.addFriendJID = [dataArray[sender.superview.superview.tag] objectForKey:@"jid"];
    [self.navigationController pushViewController:smc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactPersonDetailViewController *cpdv = [main instantiateViewControllerWithIdentifier:@"contactpersondetail"];
    cpdv.isJIDOrYizhenID = YES;
    cpdv.friendJID = [dataArray[indexPath.row] objectForKey:@"jid"];
    [self.navigationController pushViewController:cpdv animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [locationManager stopUpdatingLocation];
}

@end
