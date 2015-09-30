//
//  AddDrugHistoryViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/9/7.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "AddDrugHistoryViewController.h"

@interface AddDrugHistoryViewController ()

{
    NSMutableArray *drugNameArray;//关键字搜索返回的药品名称，后端返回
    UIScrollView *buttonScroller;//添加button的view
    UITextField *drugInputText;//输入药品名称的view
    UIButton *startTimeButton;//起始时间button
    UILabel *label;//中间的“~”符号的label
    UIButton *endTimeButton;//结束时间button
    UISwitch *resistSwitch;//是否抗药
    NSString *mid;//药品id
    UIView *bottomView;//底部输入的view
    
    UIButton *tillNowButton;//至今按钮，只有在结束时间的时候显示
    UILabel *titleLabel;//显示开始或者结束时间的label
    UIDatePicker *datePicker;
    
    NSString *startTime;//开始时间
    NSString *endTime;//结束时间
    BOOL IsStart;//判断是开始时间还是结束时间，1为开始时间，0则是结束时间
}

@end

@implementation AddDrugHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    UIButton *addDrugButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [addDrugButton setTitle:NSLocalizedString(@"保存", @"") forState:UIControlStateNormal];
    addDrugButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [addDrugButton addTarget:self action:@selector(saveDrugHistory:) forControlEvents:UIControlEventTouchUpInside];
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:addDrugButton];
    [drugInputText becomeFirstResponder];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 50;
    }else{
        return ViewHeight-44-22-100;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentify = @"diseasecell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentify];
    }
    if (indexPath.row == 0) {
        drugInputText = [[UITextField alloc]init];
        drugInputText.placeholder = NSLocalizedString(@"请输入药品名称", @"");
        drugInputText.delegate = self;
        drugInputText.borderStyle = UITextBorderStyleNone;
        drugInputText.returnKeyType = UIReturnKeyDone;
        [drugInputText addTarget:self action:@selector(inputDrugName:) forControlEvents:UIControlEventEditingChanged];
        [cell addSubview:drugInputText];
        [drugInputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.centerY.equalTo(cell);
        }];
    }else if(indexPath.row == 1){
        UIImageView *timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 20, 20)];
        timeImageView.image = [UIImage imageNamed:@"history_time"];
        [cell addSubview:timeImageView];
        startTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(32, 10, 60, 30)];
        startTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [startTimeButton setTitle:NSLocalizedString(@"开始时间", @"") forState:UIControlStateNormal];
        [startTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [startTimeButton addTarget:self action:@selector(startDrugTime:) forControlEvents:UIControlEventTouchUpInside];
        startTimeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        label = [[UILabel alloc]initWithFrame:CGRectMake(startTimeButton.frame.origin.x+startTimeButton.bounds.size.width, 10, 10, 30)];
        label.text = @"~";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.0];
        [cell addSubview:label];
        endTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width+3, 10, 70, 30)];
        endTimeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [endTimeButton setTitle:NSLocalizedString(@"停药时间", @"") forState:UIControlStateNormal];
        [endTimeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [endTimeButton addTarget:self action:@selector(endDrugTime:) forControlEvents:UIControlEventTouchUpInside];
        endTimeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        UILabel *resistantLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth-70-50, 10, 50, 30)];
        resistantLabel.text = NSLocalizedString(@"耐药", @"");
        resistantLabel.textColor = grayLabelColor;
        resistantLabel.textAlignment = NSTextAlignmentRight;
        resistantLabel.font = [UIFont systemFontOfSize:14.0];
        [cell addSubview:startTimeButton];
        [cell addSubview:endTimeButton];
        [cell addSubview:resistantLabel];
        resistSwitch = [[UISwitch alloc]init];
        [resistSwitch addTarget:self action:@selector(resistDrugOrNot:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = resistSwitch;
    }else{
        buttonScroller = [[UIScrollView alloc]init];
        [cell addSubview:buttonScroller];
        [buttonScroller mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.equalTo(@0);
        }];
        [self addBTNs:drugNameArray View:buttonScroller];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"添加用药", @"");
    _addDrugTable = [[UITableView alloc]init];
    _addDrugTable.delegate = self;
    _addDrugTable.dataSource = self;
    _addDrugTable.backgroundColor = grayBackgroundLightColor;
    _addDrugTable.layer.borderColor = lightGrayBackColor.CGColor;
    _addDrugTable.layer.borderWidth = 0.5;
    _addDrugTable.separatorColor = lightGrayBackColor;
    _addDrugTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_addDrugTable];
    [_addDrugTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(@0);
    }];
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 300)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = grayBackColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    [self.view addSubview:bottomView];
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelDate:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth-60-10, 5, 60, 30)];
    [confirmButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmDate:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    tillNowButton = [[UIButton alloc]initWithFrame:CGRectMake(ViewWidth/2-30, 5, 60, 30)];
    [tillNowButton setTitle:NSLocalizedString(@"至今", @"") forState:UIControlStateNormal];
    [tillNowButton setTitleColor:themeColor forState:UIControlStateNormal];
    [tillNowButton addTarget:self action:@selector(tillNowDate:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:tillNowButton];
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth/2-30, 40, 80, 30)];
    [bottomView addSubview:titleLabel];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 80, ViewWidth, 220)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.locale = locale;
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *nowDate = [NSDate date];
    datePicker.maximumDate = nowDate;
    [bottomView addSubview:datePicker];
    titleLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    titleLabel.text = NSLocalizedString(@"开始时间", @"");
}

-(void)setupData{
    
}

-(void)saveDrugHistory:(UIButton *)sender{
    if ((![drugInputText.text isEqualToString:@""])&&startTime != nil&&endTime != nil&&mid != nil) {
        NSString *url = [NSString stringWithFormat:@"%@emr/medicinemanagement/create",Baseurl];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *yzuid = [defaults objectForKey:@"userUID"];
        NSString *yztoken = [defaults objectForKey:@"userToken"];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yzuid,yztoken,drugInputText.text,startTime,endTime,[NSNumber numberWithBool:resistSwitch.on],@"1",mid,nil] forKeys:[NSArray arrayWithObjects:@"uid",@"token",@"medicinename",@"begindate",@"stopdate",@"resistant",@"isuse",@"mid",nil]];
        [[HttpManager ShareInstance] AFNetPOSTNobodySupport:url Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            int res=[[source objectForKey:@"res"] intValue];
            NSLog(@"res===%d",res);
            if (res==0) {
                [_addDrugDelegate AddDrugSucess:YES];
            }else{
                [_addDrugDelegate AddDrugSucess:NO];
            }
        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [_addDrugDelegate AddDrugSucess:NO];
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *showNotice = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"设置错误", @"") message:NSLocalizedString(@"请检查您的设置", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:nil, nil];
        [showNotice show];
    }
}

-(void)resistDrugOrNot:(UISwitch *)sender{
    NSLog(@"抗药与否");
    [sender isOn];//开关与否
}

-(void)startDrugTime:(UIButton *)sender{
    IsStart = YES;
    tillNowButton.hidden = YES;
    titleLabel.text = NSLocalizedString(@"开始时间", @"");
    [self.view endEditing:YES];
    [self popSpringAnimationOut:bottomView];
}

-(void)endDrugTime:(UIButton *)sender{
    IsStart = NO;
    tillNowButton.hidden = NO;
    titleLabel.text = NSLocalizedString(@"结束时间", @"");
    [self.view endEditing:YES];
    [self popSpringAnimationOut:bottomView];
}

-(void)inputDrugName:(UITextField *)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@med/keywords?uid=%@&token=%@&keywords=%@",Baseurl,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"],sender.text];
    [[HttpManager ShareInstance] AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res = [[source objectForKey:@"res"] intValue];
        if (res == 0) {
            drugNameArray = [source objectForKey:@"list"];
            [self addBTNs:drugNameArray View:buttonScroller];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)addBTNs:(NSArray *)array View:(UIScrollView *)view{
    //按钮进行排版
    for (UIView *a in view.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
        }
    }
    int xxxx = 10;
    int newrows = 0;
    
    for (int i = 0; i<array.count; i++) {
        NSString *title = [array[i] objectForKey:@"brandname"];
        CGSize size = [self get:title];
        CGSize size2;
        if (i!=array.count-1) {
            NSString *title2 = [array[i+1] objectForKey:@"brandname"];
            size2 = [self get:title2];
        }
        int nextw = size2.width+20;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = lightGrayBackColor;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.tag = i;
        btn.frame = CGRectMake(xxxx, 10+45*newrows, size.width+20, 35);
        [btn addTarget:self action:@selector(setDrugName:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [view addSubview:btn];
        int  ppppp = size.width+20 +10+xxxx+nextw  ;
        if (ppppp>ViewWidth-10) {
            xxxx = 10;
            newrows++;
        }
        else{
            xxxx = size.width+20 +10+xxxx;
        }
        
    }
    view.contentSize=CGSizeMake(ViewWidth, 10+(newrows+1)*45+10);
}

-(CGSize)animationSize:(NSString *)title{
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize;
}

-(CGSize)get:(NSString *)title{
    NSDictionary* attrs =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSAttributedString *newatt=[[NSAttributedString alloc] initWithString:title attributes:attrs];
    CGRect rect=[newatt boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingTruncatesLastVisibleLine context:nil];
    CGSize titleSize=rect.size;
    return titleSize;
}

-(void)setDrugName:(UIButton *)sender{
    drugInputText.text = [sender titleForState:UIControlStateNormal];
    mid = [drugNameArray[sender.tag] objectForKey:@"id"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[SetupView ShareInstance]setupNavigationRightButton:self RightButton:nil];
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView{
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

-(void)popSpringAnimationHidden:(UIView *)targetView{
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

-(void)cancelDate:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomView];
}

-(void)confirmDate:(UIButton *)sender{
    NSDate *date = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tempDateString = [dateFormatter stringFromDate:date];
    if (IsStart) {
        startTime = tempDateString;
        [startTimeButton setTitle:startTime forState:UIControlStateNormal];
        startTimeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [UIView animateWithDuration:1.0 animations:^{
            startTimeButton.frame = CGRectMake(32, 10, 80, 30) ;
            label.frame = CGRectMake(startTimeButton.frame.origin.x+startTimeButton.bounds.size.width, 10, label.frame.size.width, 30);
            endTimeButton.frame = CGRectMake(label.frame.origin.x+label.frame.size.width+3, 10, endTimeButton.frame.size.width, 30);
        }];
        tillNowButton.hidden = NO;
        IsStart = NO;
    }else{
        endTime = tempDateString;
        [endTimeButton setTitle:endTime forState:UIControlStateNormal];
        endTimeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [UIView animateWithDuration:1.0 animations:^{
            endTimeButton.frame = CGRectMake(label.frame.origin.x+label.frame.size.width+3, 10, 80, 30);
        }];
        [self popSpringAnimationHidden:bottomView];
    }
}

-(void)tillNowDate:(UIButton *)sender{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *tempDateString = [dateFormatter stringFromDate:date];
    endTime = tempDateString;
    [endTimeButton setTitle:endTime forState:UIControlStateNormal];
    endTimeButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [UIView animateWithDuration:1.0 animations:^{
        endTimeButton.frame = CGRectMake(label.frame.origin.x+label.frame.size.width+3, 10, 80, 30);
    }];
    [self popSpringAnimationHidden:bottomView];
}

#pragma mark-键盘*************************************
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    BOOL isDrug = NO;
    for (NSDictionary *dic in drugNameArray) {
        NSString *drugName = [dic objectForKey:@"brandname"];
        if ([textField.text isEqualToString:drugName]) {
            isDrug = YES;
            mid = [dic objectForKey:@"id"];
            IsStart = YES;
            tillNowButton.hidden = YES;
            titleLabel.text = NSLocalizedString(@"开始时间", @"");
            [self popSpringAnimationOut:bottomView];
        }
    }
    if (!isDrug) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温情提示" message:@"您所填的写的药物名称没有被收录，请选择提示标签中的药物名称。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


#pragma mark-时时更新数据
- (void)textFieldDidChange:(UITextField *)note
{
    
}

#pragma 取消键盘输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
