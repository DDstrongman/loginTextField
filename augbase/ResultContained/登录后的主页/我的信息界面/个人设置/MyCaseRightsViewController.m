//
//  MyCaseRightsViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MyCaseRightsViewController.h"

@interface MyCaseRightsViewController ()

{
    NSMutableArray *titleArray;//标题数组
    NSMutableArray *rightNowArray;//当前的各个标题的权限数组
    NSMutableArray *rightArray;//权限选项数组
    UIView *bottomView;
    UILabel *bottomTitleLabel;//底部标题label
    NSIndexPath *selectIndex;
    NSString *selectString;//
    UIPickerView *pickRight;//
}

@end

@implementation MyCaseRightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}


-(void)saveNote:(UIButton *)sender{
    
}

-(void)sendAdvice:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelBottomView:(UIButton *)sender{
    [self popSpringAnimationHidden:bottomView];
}

-(void)confirmBottomView:(UIButton *)sender{
    UITableViewCell *cell = [_myCaseRightTable cellForRowAtIndexPath:selectIndex];
    if (selectString == nil) {
        selectString = NSLocalizedString(@"所有人可见", @"");
    }
    cell.detailTextLabel.text = selectString;
    [self popSpringAnimationHidden:bottomView];
}

#pragma 底部view出现和隐藏
-(void)popSpringAnimationOut:(UIView *)targetView{
    [pickRight selectRow:0 inComponent:0 animated:YES];
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    anim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0,ViewHeight-targetView.bounds.size.height-22,targetView.bounds.size.width,targetView.bounds.size.height)];
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


-(void)setupView{
    self.title = NSLocalizedString(@"病历权限", @"");
    _myCaseRightTable = [[UITableView alloc]init];
    _myCaseRightTable.backgroundColor = grayBackgroundLightColor;
    _myCaseRightTable.delegate = self;
    _myCaseRightTable.dataSource = self;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _myCaseRightTable.tableFooterView = [[UIView alloc]init];
    _myCaseRightTable.tableHeaderView = headerView;
    [self.view addSubview:_myCaseRightTable];
    [_myCaseRightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(@0);
    }];
    [self initBottomView];
}

-(void)initBottomView{
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewHeight, ViewWidth, 300)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderColor = lightGrayBackColor.CGColor;
    bottomView.layer.borderWidth = 0.5;
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    cancelButton.center = CGPointMake(30+10, 23);
    [cancelButton setTitle:NSLocalizedString(@"取消", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:themeColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelButton];
    bottomTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    bottomTitleLabel.center = CGPointMake(bottomView.center.x,23);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userSystemVersion"] floatValue]>8.0) {
        bottomTitleLabel.font = [UIFont systemFontOfSize:17.0 weight:2.0];
    }else{
        bottomTitleLabel.font = [UIFont systemFontOfSize:17.0];
    }
    bottomTitleLabel.textAlignment = NSTextAlignmentCenter;
    bottomTitleLabel.text = @"";
    [bottomView addSubview:bottomTitleLabel];
    UIButton *confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    confirmButton.center = CGPointMake(ViewWidth-30-10, 23);
    [confirmButton setTitle:NSLocalizedString(@"确定", @"") forState:UIControlStateNormal];
    [confirmButton setTitleColor:themeColor forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBottomView:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmButton];
    
    pickRight = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, ViewWidth, 300-44)];
    pickRight.delegate = self;
    pickRight.dataSource = self;
    pickRight.layer.borderColor = lightGrayBackColor.CGColor;
    pickRight.layer.borderWidth = 0.5;
    [bottomView addSubview:pickRight];
    [self.view addSubview:bottomView];
}

-(void)setupData{
    titleArray = [@[NSLocalizedString(@"当前疾病", @""),NSLocalizedString(@"用药记录", @""),NSLocalizedString(@"识别结果", @"")]mutableCopy];
    rightArray = [@[NSLocalizedString(@"所有人可见", @""),NSLocalizedString(@"仅好友可见", @""),NSLocalizedString(@"仅自己可见", @"")]mutableCopy];
    rightNowArray = [NSMutableArray array];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,[user objectForKey:@"userJID"],[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res==0) {
            [rightNowArray addObject:[source objectForKey:@"diseasePrivacySetting"]];
            [rightNowArray addObject:[source objectForKey:@"medicinePrivacySetting"]];
            [rightNowArray addObject:[source objectForKey:@"ltrPrivacySetting"]];
            [_myCaseRightTable reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma delegate在最下方
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"mineSettingCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
    cell.textLabel.text = titleArray[indexPath.row];
    if (rightNowArray.count != 0) {
        cell.detailTextLabel.text = rightArray[[rightNowArray[indexPath.row] intValue]];
    }
    UIImageView *tailImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"goin"]];
    cell.accessoryView = tailImageView;
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectIndex = indexPath;
    bottomTitleLabel.text = titleArray[indexPath.row];
    [self popSpringAnimationOut:bottomView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return rightArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [rightArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectString = rightArray[row];
    [rightNowArray replaceObjectAtIndex:selectIndex.row withObject:[NSNumber numberWithInteger:row]];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *editUrl = [NSString stringWithFormat:@"%@v2/user/generalInfo?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:rightNowArray[0] forKey:@"diseasePrivacySetting"];
    [dic setValue:rightNowArray[1] forKey:@"medicinePrivacySetting"];
    [dic setValue:rightNowArray[2] forKey:@"ltrPrivacySetting"];
    
    [[HttpManager ShareInstance]AFNetPOSTNobodySupport:editUrl Parameters:dic SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res==0) {
            NSLog(@"修改成功");
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
