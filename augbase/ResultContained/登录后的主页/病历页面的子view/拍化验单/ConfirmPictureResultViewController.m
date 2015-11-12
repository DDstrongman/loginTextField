//
//  ConfirmPictureResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ConfirmPictureResultViewController.h"

@interface ConfirmPictureResultViewController ()

{
    BOOL canEarse;//能否画马赛克
    int eraserNumber;
}

@end

@implementation ConfirmPictureResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultImageView.image = _resultImage;
    _bottomTabBar.delegate = self;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    backView.backgroundColor = themeColor;
    [_bottomTabBar insertSubview:backView atIndex:0];
    _bottomTabBar.barTintColor = [UIColor whiteColor];
    _bottomTabBar.tintColor = [UIColor whiteColor];
    UITabBarItem *item0 = [_bottomTabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [_bottomTabBar.items objectAtIndex:1];
//    UITabBarItem *item2 = [_bottomTabBar.items objectAtIndex:2];
    item0.image = [[UIImage imageNamed:@"retake"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"recognition"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    item2.image = [[UIImage imageNamed:@"recognition"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    _bottomTabBar.opaque = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    canEarse = NO;
    eraserNumber = 50;
}

#pragma tabbarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 1:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
            [_openCameraDele openCamera:YES];
        }
            break;
        case 2:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"选择化验单种类", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"普通化验单(非B超)", @""),NSLocalizedString(@"B超", @""), nil];
            sheet.tag = 3;
            [sheet showInView:self.view];
        }
            break;
        default:
            break;
    }
}

-(void)uploadPic:(NSDictionary *)dic{
    NSData *data= UIImageJPEGRepresentation(_resultImage , compress);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *yzuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"];
    NSString *yztoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *picinfo=[NSString stringWithFormat:@"%f*%f",_resultImage.size.width,_resultImage.size.height];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *uurl=[NSString stringWithFormat:@"%@ltr/create?uid=%@&token=%@&ltrid=-1&partnum=0&source=2&picinfo=%@",Baseurl,yzuid,yztoken,picinfo];
    [manager POST:uurl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:[self gettime] mimeType:@"png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传成功");
        [[SetupView ShareInstance]hideHUD];
        NSString *tempString = @"";
        //获取当前时间
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger hour = [dateComponent hour];
        if (hour>22||hour<8) {
            tempString = NSLocalizedString(@"将在12小时内完成识别", @"");
        }else{
            tempString = NSLocalizedString(@"将在两小时内完成识别", @"");
        }
        UIAlertView *showMess = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"上传成功", @"") message:tempString delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [showMess show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败");
    }];
}

-(NSString *)gettime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *strUrl = [currentDateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *newdate=[strUrl substringToIndex:8];
    return newdate;
    
}

#pragma actionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击了===%ld",(long)buttonIndex);
    NSMutableDictionary *dic;//传入的dic
    if (buttonIndex == 0||buttonIndex == 1) {
        if (buttonIndex == 0) {
            [dic setObject:@"0" forKey:@"type"];
        }else{
            [dic setObject:@"1" forKey:@"type"];
        }
        [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"上传中", @"")];
        [self uploadPic:dic];
        if (actionSheet.tag == 2) {
            [_openCameraDele openCamera:YES];
        }
    }else{
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       themeColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
}

@end
