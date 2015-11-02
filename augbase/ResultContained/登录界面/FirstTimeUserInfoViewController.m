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

@interface FirstTimeUserInfoViewController ()<ConnectXMPPDelegate,UIActionSheetDelegate>
{
    BOOL _animatedOrNot;
    
    BOOL titleImageOrNot;
    
    UIView *bottomChooseView;//底部选择view
    UILabel *titleChooseLabel;//底部选择view的标题label
    UIPickerView *choosePicker;//选择框
    NSMutableArray *chooseArray;//选择的数据元数组
    NSInteger chooseIndex;//选择到了第几行
    
    UIView *visualEffectView;//模糊的view
    NSString *tempFirst;
    NSString *tempSecond;
    NSString *tempThird;
}

@end

@implementation FirstTimeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"个人信息", @"");
    [_userImageView setImage:[UIImage imageNamed:@"default_avatar4"]];
    [XMPPSupportClass ShareInstance].connectXMPPDelegate = self;
    
    _nameView = [[ImageViewLabelTextFieldView alloc]initWithFrame:CGRectMake(48, 250, ViewWidth-120+12, 50)];
    _nameView.contentTextField.placeholder = NSLocalizedString(@"昵称", @"");
    [_nameView.contentTextField addTarget:self action:@selector(enSureNameAndSexAndAge) forControlEvents:UIControlEventEditingChanged];
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
    
    [_finishRegistButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.equalTo(_sexAndAgeView.mas_bottom).with.offset(20);
        make.right.equalTo(@-60);
        make.left.equalTo(@60);
    }];
    _finishRegistButton.backgroundColor = grayBackColor;
    _finishRegistButton.userInteractionEnabled = NO;
    [self setupBottomView];
    [self setupdata];
}

-(void)setupBottomView{
    bottomChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 300)];
    bottomChooseView.backgroundColor = grayBackgroundLightColor;
    [self.view addSubview:bottomChooseView];
    
    titleChooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, ViewWidth-80-80, 30)];
    titleChooseLabel.text = NSLocalizedString(@"请选择性别和年龄", @"");
    titleChooseLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *cancelChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 30)];
    [cancelChooseButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelChooseButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelChooseButton addTarget:self action:@selector(cancelChooseView:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmChooseButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-10-60, 10, 60, 30)];
    [confirmChooseButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmChooseButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmChooseButton addTarget:self action:@selector(confirmChooseView:) forControlEvents:UIControlEventTouchUpInside];
    
    choosePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 45, ViewWidth-20, 300-45-10)];
    choosePicker.delegate = self;
    choosePicker.dataSource = self;
    [bottomChooseView addSubview:titleChooseLabel];
    [bottomChooseView addSubview:cancelChooseButton];
    [bottomChooseView addSubview:confirmChooseButton];
    [bottomChooseView addSubview:choosePicker];
}

-(void)setupdata{
    tempFirst = NSLocalizedString(@"男", @"");
    tempSecond = 0;
    tempThird = @"+";
    titleImageOrNot = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@NO forKey:@"FriendList"];
    
    NSString *url = [NSString stringWithFormat:@"%@v2/user/login",Baseurl];
    NSMutableDictionary *loginDic = [NSMutableDictionary dictionary];
    [loginDic setValue:[defaults objectForKey:@"userName"] forKey:@"username"];
    [loginDic setValue:[defaults objectForKey:@"userPassword"] forKey:@"password"];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager POST:url parameters:loginDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"responseObject=%@",responseObject);
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res==0) {
            //请求完成
            [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
            [UserItem ShareInstance].userName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userNickName = [source objectForKey:@"username"];
            [UserItem ShareInstance].userRealName = [source objectForKey:@"nickname"];
            [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
            [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
            [UserItem ShareInstance].userTele = [source objectForKey:@"tel"];
            [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
            [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
            [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
            [defaults setObject:[UserItem ShareInstance].userRealName forKey:@"userRealName"];
            [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
            [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
            [defaults setObject:[UserItem ShareInstance].userTele forKey:@"userTele"];
        }
    }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    _sexAndAgeView.contentTextField.userInteractionEnabled = NO;
    _animatedOrNot = YES;
}

-(void)enSureNameAndSexAndAge{
    if (titleImageOrNot&&_nameView.contentTextField.text.length>0&&_sexAndAgeView.contentTextField.text.length>0) {
        _finishRegistButton.userInteractionEnabled = YES;
        _finishRegistButton.backgroundColor = themeColor;
    }
}

-(void)selectSexAndAge{
    [self popSpringAnimationOut:bottomChooseView ChooseOrInsert:YES];
}

-(void)selectImageOrCamera{
    UIActionSheet *pickImageSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"选择头像", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"相册", @""),NSLocalizedString(@"相机", @""), nil];
    pickImageSheet.tag = 888;
    [pickImageSheet showInView:self.view];
}

-(void)finishRegist{
    NSString *sexAndAge = _sexAndAgeView.contentTextField.text;
    if (_nameView.contentTextField.text.length == 0) {
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请输入昵称", @"") Title:NSLocalizedString(@"昵称不能为空", @"") ViewController:self];
    }else if (sexAndAge.length == 0){
        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请选择年龄和性别", @"") Title:NSLocalizedString(@"年龄性别不能为空", @"") ViewController:self];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_nameView.contentTextField.text forKey:@"userNickName"];
        NSArray *array = [sexAndAge componentsSeparatedByString:@"／"];
        [defaults setObject:array[0] forKey:@"userGender"];
        [defaults setObject:array[1] forKey:@"userAge"];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        
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
            if (res == 0) {
                //请求完成
                [UserItem ShareInstance].userUID = [source objectForKey:@"uid"];
                [UserItem ShareInstance].userName = [source objectForKey:@"username"];
                [UserItem ShareInstance].userNickName = [source objectForKey:@"username"];
                [UserItem ShareInstance].userRealName = [source objectForKey:@"nickname"];
                [UserItem ShareInstance].userToken = [source objectForKey:@"token"];
                [UserItem ShareInstance].userJID = [source objectForKey:@"ji"];
                [defaults setObject:[UserItem ShareInstance].userUID forKey:@"userUID"];
                [defaults setObject:[UserItem ShareInstance].userName forKey:@"userName"];
//                [defaults setObject:[UserItem ShareInstance].userNickName forKey:@"userNickName"];
                [defaults setObject:_nameView.contentTextField.text forKey:@"userNickName"];
                [defaults setObject:[UserItem ShareInstance].userRealName forKey:@"userRealName"];
                [defaults setObject:[UserItem ShareInstance].userToken forKey:@"userToken"];
                [defaults setObject:[UserItem ShareInstance].userJID forKey:@"userJID"];
                [defaults setObject:_nameView.contentTextField.text forKey:@"userNickName"];
                NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,[defaults objectForKey:@"userJID"],[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
                jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    [defaults setObject:[userInfo objectForKey:@"yizhenId"] forKey:@"userYizhenID"];
                    NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
                    imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                    [defaults setObject:imageurl forKey:@"userHttpImageUrl"];
                }failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                    
                }];
                if (_isBlindWeChat) {
                    [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:_headImageData];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@/%@/%@.png",[[WriteFileSupport ShareInstance] dirDoc],yizhenImageFile,myImageName] forKey:@"userImageUrl"];
                    NSString *blindWeChat = [NSString stringWithFormat:@"%@v2/user/third_party/bind",Baseurl];
                    NSMutableDictionary *dicWechat = [NSMutableDictionary dictionary];
                    [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"] forKey:@"uid"];
                    [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] forKey:@"token"];
                    [dicWechat setObject:@0 forKey:@"third_party_type"];
                    [dicWechat setObject:_unID forKey:@"uuid"];
                    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:blindWeChat Parameters:dicWechat SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                        int res=[[source objectForKey:@"res"] intValue];
                        if (res == 0) {
                            NSLog(@"绑定微信成功");
                            [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"userWeChat"];
                        }
                    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
                }
                if ([[XMPPSupportClass ShareInstance] boolConnect:[NSString stringWithFormat:@"%@@%@",[UserItem ShareInstance].userJID,httpServer]]) {
                    NSString *creatUrl = [NSString stringWithFormat:@"%@unm/create",Baseurl];
                    NSMutableDictionary *createDic = [NSMutableDictionary dictionary];
                    [createDic setObject:@0 forKey:@"clienttype"];
                    if ([defaults objectForKey:@"userDeviceID"]!= nil) {
                        [createDic setObject:[defaults objectForKey:@"userDeviceID"] forKey:@"machineid"];
                    }
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
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *nameUrl = [NSString stringWithFormat:@"%@v2/user/generalInfo",Baseurl];
        nameUrl = [NSString stringWithFormat:@"%@?uid=%@&token=%@&username=%@",nameUrl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],_nameView.contentTextField.text];
        [[HttpManager ShareInstance] AFNetPOSTNobodySupport:nameUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *resource = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res = [[resource objectForKey:@"res"] intValue];
            NSLog(@"changeNameRes===%d",res);
            if (res == 0) {
                
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *showNotice = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"网络错误", @"") message:NSLocalizedString(@"网络错误", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
            [showNotice show];
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:_nameView.contentTextField.text forKey:@"userName"];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 888) {
        //选择头像
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if (buttonIndex == 0) {
            //开启相册
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//一共有3种
            imagePicker.allowsEditing=YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        }else if (buttonIndex == 1){
            //开启相机
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//一共有3种
            imagePicker.allowsEditing=YES;
            [self presentViewController:imagePicker animated:YES completion:NULL];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSLog(@"image===%@",image);
    [self updateTitleimg:image];
    _userImageView.image = image;
    titleImageOrNot = YES;
    [_userImageView imagewithColor:grayBackgroundDarkColor CornerWidth:1.0];
}

-(void)updateTitleimg:(UIImage *)headImg{
    NSData *data = UIImageJPEGRepresentation(headImg, 0.2);
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSString *yzuid = [user objectForKey:@"userUID"];
    NSString *yztoken = [user objectForKey:@"userToken"];
    NSString *url=[NSString stringWithFormat:@"%@user/updateimg?uid=%@&token=%@",Baseurl,yzuid,yztoken];
    titleImageOrNot = YES;
    [[HttpManager ShareInstance]AFNetPOSTSupport:url Parameters:nil ConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"tou" mimeType:@"png"];
    } SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = UIImagePNGRepresentation(headImg);
        [[WriteFileSupport ShareInstance] writeImageAndReturn:yizhenImageFile FileName:myImageName Contents:data];
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    if (titleImageOrNot&&_nameView.contentTextField.text.length>0&&_sexAndAgeView.contentTextField.text.length>0) {
        _finishRegistButton.userInteractionEnabled = YES;
        _finishRegistButton.backgroundColor = themeColor;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}

#pragma pickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 2;
    }else if (component == 1){
        return 20;
    }else{
        return 1;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            return NSLocalizedString(@"男", @"");
        }else{
            return NSLocalizedString(@"女", @"");
        }
    }else if (component == 1){
        return [NSString stringWithFormat:@"%ld",row*5];
    }else{
        return @"+";
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        if (row == 0) {
            tempFirst = NSLocalizedString(@"男", @"");
        }else{
            tempFirst = NSLocalizedString(@"女", @"");
        }
    }else if (component ==1){
        tempSecond = [NSString stringWithFormat:@"%ld",row*5];
    }else{
        tempThird = @"+";
    }
    titleChooseLabel.text = [NSString stringWithFormat:@"%@／%@%@",tempFirst,tempSecond,tempThird];
}

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView ChooseOrInsert:(BOOL)chooseOrInsert{
    visualEffectView = [[UIView alloc] init];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view insertSubview:visualEffectView belowSubview:bottomChooseView];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    if (chooseOrInsert) {
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-22-44-targetView.bounds.size.height,targetView.bounds.size.width,targetView.bounds.size.height)];
    }else{
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,60,targetView.bounds.size.width,targetView.bounds.size.height)];
    }
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
    [self popSpringAnimationHidden:bottomChooseView];
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
    [self.view endEditing:YES];
}


-(void)cancelChooseView:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomChooseView];
}

-(void)confirmChooseView:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomChooseView];
    _sexAndAgeView.contentTextField.text = titleChooseLabel.text;
    if (titleImageOrNot&&_nameView.contentTextField.text.length>0&&_sexAndAgeView.contentTextField.text.length>0) {
        _finishRegistButton.userInteractionEnabled = YES;
        _finishRegistButton.backgroundColor = themeColor;
    }
}

@end
