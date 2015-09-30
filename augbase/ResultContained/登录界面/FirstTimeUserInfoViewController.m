//
//  FirstTimeUserInfoViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "FirstTimeUserInfoViewController.h"

#import "UserItem.h"
#import "AppDelegate.h"

#import "WriteFileSupport.h"

@interface FirstTimeUserInfoViewController ()<ConnectXMPPDelegate>
{
    BOOL _animatedOrNot;
}

@end

@implementation FirstTimeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"个人信息", @"");
    [_userImageView setImage:[UIImage imageNamed:@"default_avatar"]];
    [_userImageView imagewithColor:grayBackgroundDarkColor CornerWidth:1.0];
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
    
    _nameView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 250, ViewWidth-120+12, 50)];
    _nameView.contentTextField.placeholder = NSLocalizedString(@"昵称", @"");
    _sexAndAgeView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 300+5, ViewWidth-120+12, 50)];
    _sexAndAgeView.contentTextField.placeholder = NSLocalizedString(@"性别／年龄", @"");
//    [_sexAndAgeView.contentTextField addTarget:self action:@selector(selectSexAndAge) forControlEvents:UIControlEventEditingDidBegin];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSexAndAge)];
     [singleTap setNumberOfTapsRequired:1];
    [_sexAndAgeView addGestureRecognizer:singleTap];
    
    _userImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageOrCamera)];
    [_userImageView addGestureRecognizer:singleTapImage];
    
    [self.view addSubview:_nameView];
    [self.view addSubview:_sexAndAgeView];
    
    _finishRegistButton = [[UIButton alloc]init];
    [_finishRegistButton setTitle:NSLocalizedString(@"完成", @"") forState:UIControlStateNormal];
    [_finishRegistButton addTarget:self action:@selector(finishRegist) forControlEvents:UIControlEventTouchUpInside];
    [_finishRegistButton.layer setMasksToBounds:YES];
    [_finishRegistButton.layer setCornerRadius:10.0];
    [self.view addSubview:_finishRegistButton];
    
    _cameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _cameraImageView.center = CGPointMake(_userImageView.bounds.size.width-_cameraImageView.bounds.size.width/2,_userImageView.bounds.size.height-_cameraImageView.bounds.size.height/2);
    _cameraImageView.image = [UIImage imageNamed:@"take"];
    [_cameraImageView imageWithRound];
    [_userImageView addSubview:_cameraImageView];
    
    [_finishRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {        make.height.equalTo(@50);
        make.top.equalTo(_sexAndAgeView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    _finishRegistButton.backgroundColor = grayBackColor;
    _sexAndAgeView.contentTextField.userInteractionEnabled = NO;
    _animatedOrNot = YES;
    
    //可能需要加入每次加载界面的判断，是否满足激活按钮的条件，需要详细考虑
    _finishRegistButton.userInteractionEnabled = NO;
//    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)selectSexAndAge{
    [_pickview remove];
    _sexAndAgeView.titleLabel.hidden = NO;
    _sexAndAgeView.titleLabel.text = _sexAndAgeView.contentTextField.placeholder;
    _sexAndAgeView.titleLabel.textColor = grayLabelColor;
    
    [self.view endEditing:YES];
    _pickview = [[ZHPickView alloc] initPickviewWithPlistName:@"sexAndAge" isHaveNavControler:NO];
    _pickview.delegate = self;
    [_pickview show];
}

-(void)selectImageOrCamera{
    NSLog(@"加入打开相册和照相机的代码，即跳转原项目中已有的view");
}

-(void)finishRegist{
    NSLog(@"注册完成，添加响应函数");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_nameView.contentTextField.text forKey:@"userNickName"];
    NSString *sexAndAge = _sexAndAgeView.contentTextField.text;
    NSArray *array = [sexAndAge componentsSeparatedByString:@"／"];
    NSLog(@"分割后的字符为：%@",array);
    [defaults setObject:array[0] forKey:@"userGender"];
    [defaults setObject:array[1] forKey:@"userAge"];
#warning 正式版本中使用上方的代码
    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
    [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        NSLog(@"device activitation res=%d",res);
        if (res==0) {
            //请求完成
            [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
            [UserItem ShareInstance].userName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userNickName = [source objectForKey:@"nickname"];
            [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
            [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
            NSLog(@"返回的登录系数：%@",source);
            //            [defaults synchronize];
            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
            [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
            if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[UserItem ShareInstance].userJID,httpServer]]) {
                NSString *creatUrl = [NSString stringWithFormat:@"%@unm/create",Baseurl];
                NSMutableDictionary *createDic = [NSMutableDictionary dictionary];
                [createDic setObject:@0 forKey:@"clienttype"];
                [createDic setObject:[defaults objectForKey:@"userDeviceID"] forKey:@"machineid"];
                [createDic setObject:[defaults objectForKey:@"userUID"] forKey:@"uid"];
                [createDic setObject:[defaults objectForKey:@"userToken"] forKey:@"token"];
                [[HttpManager ShareInstance]AFNetPOSTNobodySupport:creatUrl Parameters:createDic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *createRes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    if ([[createRes objectForKey:@"res"] intValue] == 0) {
                        NSLog(@"更新设备号成功");
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            };
            UIImage *userImage = _userImageView.image;
            [self updateimg:userImage];
        }
        else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"WEB端登录失败");
    }];
}

-(void)updateimg:(UIImage *)headImg{
    NSData *data = UIImageJPEGRepresentation(headImg, 0.2);
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid = [user objectForKey:@"userUID"];
    NSString *yztoken = [user objectForKey:@"userToken"];
    NSString *url=[NSString stringWithFormat:@"%@user/updateimg?uid=%@&token=%@",Baseurl,yzuid,yztoken];
    [[HttpManager ShareInstance]AFNetPOSTSupport:url Parameters:nil ConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"tou" mimeType:@"png"];
    } SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = UIImagePNGRepresentation(headImg);
        [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:data];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName] forKey:@"userImageUrl"];
        if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userJID"],httpServer]]) {
            
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma xmpp登录结果的delegate
-(void)ConnectXMPPResult:(BOOL)result{
    NSLog(@"xmpp登录结果");
    if (result) {
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"NotFirstTime"];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *tabbarController = [story instantiateViewControllerWithIdentifier:@"tabbarmainview"];
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.window.rootViewController = [[RZTransitionsNavigationController alloc] initWithRootViewController:tabbarController];
    }else{
        NSLog(@"XMPP服务器登陆失败");
        UIAlertView *xmppFailedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"聊天服务器登陆失败", @"") message:NSLocalizedString(@"聊天服务器登陆失败,请联系管理员", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [xmppFailedAlert show];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    _sexAndAgeView.contentTextField.text = resultString;
    _finishRegistButton.userInteractionEnabled = YES;
    _finishRegistButton.backgroundColor = themeColor;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
