//
//  DetailImageOcrViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "DetailImageOcrViewController.h"

@interface DetailImageOcrViewController ()

{
    UIView *bottomEditTimeView;//底部弹出的view
    UIView *bottomEditHospitalView;//底部弹出的view
    
    UILabel *titleLabel;//底部弹出view的title（time）
    UILabel *titleHLabel;//底部弹出view的title（hospital）
    
    NSArray *hospitalArray;//网络获取医院的数组
    
    UIView *visualEffectView;
    UIPickerView *pickHospital;//选择医院的pickerview
}

@end

@implementation DetailImageOcrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_ResultOrING) {
        _bottomView.hidden = NO;
        if (_detailDic != nil) {
            if ([[_detailDic objectForKey:@"testtime"] isKindOfClass:[NSNull class]]) {
                _timeLabel.text = @"";
            }else{
                _timeLabel.text = [_detailDic objectForKey:@"testtime"];
            }
            if ([[_detailDic objectForKey:@"hosname"] isKindOfClass:[NSNull class]]) {
                _hospitalLabel.text = @"";
            }else{
                _hospitalLabel.text = [_detailDic objectForKey:@"hosname"];
            }
        }
    }else{
        _rightButton.hidden = YES;
        _timeLabel.hidden = YES;
        _hospitalLabel.hidden = YES;
        _editTimeButton.userInteractionEnabled = NO;
        _editHospitalButton.userInteractionEnabled = NO;
        _bottomView.hidden = YES;
    }
    [_rightButton addTarget:self action:@selector(deleteResult) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_editTimeButton addTarget:self action:@selector(editTime:) forControlEvents:UIControlEventTouchUpInside];
    [_editHospitalButton addTarget:self action:@selector(editHospital:) forControlEvents:UIControlEventTouchUpInside];
    
    _contentImageScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, ViewHeight-44-100)];
    _contentImageScroll.contentSize = CGSizeMake(600, ViewHeight);
    _contentImageScroll.delegate = self;
    _contentImageScroll.clipsToBounds = NO;
    _contentImageScroll.showsHorizontalScrollIndicator = NO;
    _contentImageScroll.showsVerticalScrollIndicator = NO;
    _contentImageScroll.maximumZoomScale = 3.0;
    _contentImageScroll.minimumZoomScale = 1.0;
    
    _showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, ViewHeight-44-100)];
    _showImageUrl = [_showImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:_showImageUrl] placeholderImage:[UIImage imageNamed:@"test"]];
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view insertSubview:_contentImageScroll atIndex:0];
    [_contentImageScroll addSubview:_showImageView];
    
    [self setupBottomView];
    [self setupData];
}

#pragma 不同响应函数
-(void)deleteResult{
    UIActionSheet *deleteAction;
    if (_ResultOrING) {
        deleteAction = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"删除会被扣除积分", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"删除", @""), NSLocalizedString(@"举报出错", @""),nil];
    }else{
        deleteAction = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"放弃识别会被扣除积分", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:NSLocalizedString(@"取消", @"") otherButtonTitles:NSLocalizedString(@"删除", @""), NSLocalizedString(@"举报出错", @""),nil];
    }
    [deleteAction showInView:self.view];
}

-(void)back:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editTime:(UIButton *)sender{
    [self popSpringAnimationOut:bottomEditTimeView];
}

-(void)editHospital:(UIButton *)sender{
    [self popSpringAnimationOutHospital:bottomEditHospitalView];
}

-(void)setupBottomView{
    bottomEditTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, ViewHeight/2)];
    bottomEditTimeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomEditTimeView];
    bottomEditHospitalView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, ViewHeight/2)];
    bottomEditHospitalView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomEditHospitalView];
    
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 35)];
    [confirmButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmTime:) forControlEvents:UIControlEventTouchUpInside];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSystemVersion"] floatValue]>8.0) {
        titleLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    }else{
        titleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _timeLabel.text;
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-5-60, 5, 60, 35)];
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelTime:) forControlEvents:UIControlEventTouchUpInside];
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 45, ViewWidth, ViewHeight/2-45)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [datePicker addTarget:self action:@selector(datePick:) forControlEvents:UIControlEventValueChanged];
    [bottomEditTimeView addSubview:datePicker];
    [bottomEditTimeView addSubview:cancelButton];
    [bottomEditTimeView addSubview:titleLabel];
    [bottomEditTimeView addSubview:confirmButton];
    
    UIButton *confirmHButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 35)];
    [confirmHButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmHButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmHButton addTarget:self action:@selector(confirmHospital:) forControlEvents:UIControlEventTouchUpInside];
    titleHLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleHLabel.numberOfLines = 2;
    titleHLabel.center = CGPointMake(ViewWidth/2, 22);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSystemVersion"] floatValue]>8.0) {
        titleHLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    }else{
        titleHLabel.font = [UIFont systemFontOfSize:17.0];
    }
    titleHLabel.textAlignment = NSTextAlignmentCenter;
    titleHLabel.text = _hospitalLabel.text;
    UIButton *cancelHButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-5-60, 5, 60, 35)];
    [cancelHButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelHButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelHButton addTarget:self action:@selector(cancelHospital:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *hospitalField = [[UITextField alloc]initWithFrame:CGRectMake(10, titleHLabel.frame.origin.y+titleHLabel.bounds.size.height+5, ViewWidth-20, 30)];
    hospitalField.placeholder = _hospitalLabel.text;
    hospitalField.borderStyle = UITextBorderStyleRoundedRect;
    [hospitalField addTarget:self action:@selector(changeHospitalName:) forControlEvents:UIControlEventEditingChanged];
    pickHospital = [[UIPickerView alloc]initWithFrame:CGRectMake(0, hospitalField.frame.origin.y+hospitalField.bounds.size.height+5, ViewWidth, bottomEditHospitalView.bounds.size.height-titleHLabel.bounds.size.height-5-5-hospitalField.bounds.size.height-10)];
    pickHospital.dataSource = self;
    pickHospital.delegate = self;
    [bottomEditHospitalView addSubview:pickHospital];
    [bottomEditHospitalView addSubview:cancelHButton];
    [bottomEditHospitalView addSubview:titleHLabel];
    [bottomEditHospitalView addSubview:confirmHButton];
    [bottomEditHospitalView addSubview:hospitalField];
}

- (void)datePick:(id)sender {
    NSDate *select  = [sender date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    titleLabel.text = dateAndTime;
}

-(void)cancelTime:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomEditTimeView];
}

-(void)confirmTime:(UIButton *)sender{
    _timeLabel.text = titleLabel.text;
    NSLog(@"修改时间url====%@",[NSString stringWithFormat:@"%@ltr/edit?uid=%@&token=%@&ltrid=%@&testtime=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],[_detailDic objectForKey:@"id"],titleLabel.text]);
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:[NSString stringWithFormat:@"%@ltr/edit?uid=%@&token=%@&ltrid=%@&testtime=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],[_detailDic objectForKey:@"id"],titleLabel.text] Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[response objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"修改成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [self popSpringAnimationHidden:bottomEditTimeView];
}

-(void)cancelHospital:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomEditHospitalView];
}

-(void)confirmHospital:(UIButton *)sender{
    _hospitalLabel.text = titleHLabel.text;
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:[NSString stringWithFormat:@"%@ltr/edit?uid=%@&token=%@&ltrid=%@&hospitalname=%@",Baseurl,[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"],[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"],[_detailDic objectForKey:@"id"],titleHLabel.text] Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[response objectForKey:@"res"] intValue];
        if (res == 0) {
            NSLog(@"修改成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"修改失败");
    }];
    [self popSpringAnimationHidden:bottomEditHospitalView];
}

-(void)changeHospitalName:(UITextField *)sender{
    titleHLabel.text = sender.text;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *hosUrl = [NSString stringWithFormat:@"%@v2/doctor/hospital/keywords/%@?uid=%@&token=%@",Baseurl,sender.text,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    [[HttpManager ShareInstance]AFNetGETSupport:hosUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[response objectForKey:@"res"] intValue];
        if (res == 0) {
            hospitalArray = [response objectForKey:@"matchedHospitals"];
            if (hospitalArray.count>0) {
                [pickHospital reloadAllComponents];
            }
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView{
    visualEffectView = [[UIView alloc] init];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomEditTimeView];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight/2,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.view endEditing:YES];
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)popSpringAnimationOutHospital:(UIView *)targetView{
    if (visualEffectView == nil) {
        visualEffectView = [[UIView alloc] init];
    }
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapvisualEffectView:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [visualEffectView addGestureRecognizer:singleTapGestureRecognizer];
    visualEffectView.frame = self.view.bounds;
    visualEffectView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    
    [self.view insertSubview:visualEffectView belowSubview:bottomEditHospitalView];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,22+44,targetView.bounds.size.width,targetView.bounds.size.height)];
    anim.velocity = [NSValue valueWithCGRect:targetView.frame];
    anim.springBounciness = 5.0;
    anim.springSpeed = 10;
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            
        }
    };
    [self.view endEditing:YES];
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

-(void)tapvisualEffectView:(UIView *)sender{
    [self popSpringAnimationHidden:bottomEditTimeView];
    [self popSpringAnimationHidden:bottomEditHospitalView];
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
    [self.view endEditing:YES];
    [targetView pop_addAnimation:anim forKey:@"slider"];
}

#pragma scrollerview的delgate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView//scrollview的delegate事件。需要设置缩放才会执行。
{
    return _showImageView;
}

#pragma UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 123) {
        if (buttonIndex == 0) {
            if ([[alertView  textFieldAtIndex:0].text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPassword"]]) {
                UIAlertView *deleteConfirmAlert;
                if (_ResultOrING) {
                    deleteConfirmAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"删除化验单", @"") message:NSLocalizedString(@"删除这张化验单后，此化验单对应的信息将在客户端和医生端同时删除，是否确定删除？", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
                }else{
                    deleteConfirmAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"放弃识别会被扣除积分", @"") message:NSLocalizedString(@"积分可以～～～～～", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"放弃", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
                }
                [deleteConfirmAlert show];
            }else{
                UIAlertView *wrongPassword;
                wrongPassword = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"密码错误", @"") message:NSLocalizedString(@"您输入的密码错误", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
                wrongPassword.tag = 110;
                [wrongPassword show];
            }
        }else{
            NSLog(@"取消");
        }
    }else if(alertView.tag == 110){
        
    }else{
        if (buttonIndex == 0) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *urlDelete = [NSString stringWithFormat:@"%@ltr/delete?uid=%@&token=%@&ltrid=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"],[_detailDic objectForKey:@"id"]];
            [[HttpManager ShareInstance]AFNetPOSTNobodySupport:urlDelete Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                int res = [[response objectForKey:@"res"] intValue];
                if (res == 0) {
                    NSLog(@"删除成功");
                }
            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"取消");
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"删除");
        UIAlertView *deleteAlert;
        if (_ResultOrING) {
            deleteAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"为了保证是您自己操作", @"") message:NSLocalizedString(@"请输入您的登录密码", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"删除", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
            deleteAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [deleteAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeASCIICapable;
        }else{
            deleteAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"放弃识别会被扣除积分", @"") message:NSLocalizedString(@"积分可以～～～～～", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"放弃", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
        }
        deleteAlert.tag = 123;
        [deleteAlert show];
    }else if (buttonIndex == 1){
        NSLog(@"举报错误");
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@v2/user/ltr/reportWrong/%@?uid=%@&token=%@",Baseurl,[_detailDic objectForKey:@"id"],[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res = [[response objectForKey:@"res"] intValue];
            if (res == 0) {
                NSLog(@"举报成功");
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }else{
#warning 添加取消的网络交互
        NSLog(@"取消");
    }
}

#pragma pickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return hospitalArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row<0||hospitalArray.count == 0) {
        return nil;
    }else{
        return [hospitalArray[row] objectForKey:@"hosname"];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row<0||hospitalArray.count == 0) {
        
    }else{
        titleHLabel.text = [hospitalArray[row] objectForKey:@"hosname"];
    }
}

-(void)setupData{
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
