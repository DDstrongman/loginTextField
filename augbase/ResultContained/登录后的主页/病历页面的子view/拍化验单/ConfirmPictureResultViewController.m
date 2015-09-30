//
//  ConfirmPictureResultViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ConfirmPictureResultViewController.h"

@interface ConfirmPictureResultViewController ()

@end

@implementation ConfirmPictureResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _resultImageView.image = _resultImage;
    _bottomTabBar.backgroundColor = themeColor;
    _bottomTabBar.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

#pragma tabbarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 1:
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
            break;
        case 2:
        {
            [self uploadPic];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"画上马赛克");
        }
            break;
        case 4:
        {
            [self uploadPic];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)uploadPic{
    NSData *data= UIImageJPEGRepresentation(_resultImage , compress);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *yzuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"];
    NSString *yztoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *picinfo=[NSString stringWithFormat:@"%f*%f",_resultImage.size.width,_resultImage.size.height];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *uurl=[NSString stringWithFormat:@"%@ltr/create?uid=%@&token=%@&ltrid=-1&partnum=0&source=2&picinfo=%@",Baseurl,yzuid,yztoken,picinfo];
    NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[yzuid,yztoken,@"-1",@"0",@"2",picinfo] forKeys:@[@"uid",@"token",@"ltrid",@"partnum",@"type",@"picinfo"]];
    [manager POST:uurl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:[self gettime] mimeType:@"png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传成功");
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

@end
