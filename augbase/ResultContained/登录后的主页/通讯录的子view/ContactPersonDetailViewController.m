//
//  ContactPersonDetailViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "ContactPersonDetailViewController.h"

#import "RootViewController.h"
#import "SendAddMessViewController.h"
#import "OcrTextResultViewController.h"
#import "SetupView.h"

@interface ContactPersonDetailViewController ()

{
    BOOL topChat;//置顶聊天与否
    NSInteger showDisease;//显示用药与病例否
    NSInteger showMedic;//显示用药与病例否
    NSInteger showOcrText;//显示大表与否
    BOOL darkMenu;//加入黑名单否
    int cellMedicHeightNumber;//cell加入的button的行数
    int cellDiseaseHeightNumber;//cell加入的button的行数
}

@end

@implementation ContactPersonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.title = NSLocalizedString(@"联系人详情", @"");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 3;
    }else{
        if (_isFriend) {
            return 2;
        }else{
            return 1;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else{
            return 60;
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            return 45;
        }else if(indexPath.row == 0){
            return cellMedicHeightNumber*45+40+10;
        }else{
            return cellDiseaseHeightNumber*45+40+10;
        }
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"showinfocell" forIndexPath:indexPath];
            [((UIImageView *)[cell.contentView viewWithTag:1]) imageWithRound];
            [((UIImageView *)[cell.contentView viewWithTag:1]) sd_setImageWithURL:[NSURL URLWithString:_friendImageUrl] placeholderImage:[UIImage imageNamed:@"test"]];
            ((UILabel *)[cell.contentView viewWithTag:2]).text = _friendName;
            ((UILabel *)[cell.contentView viewWithTag:4]).text = [NSString stringWithFormat:@"%@/%d",_friendGender,_friendAge];
            [((UIButton *)[cell.contentView viewWithTag:5]) setTitle:_friendLocation forState:UIControlStateNormal];
            
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"privatenotecell" forIndexPath:indexPath];
            ((UILabel *)[cell.contentView viewWithTag:1]).text = _friendNote;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"contactreportcell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row != 2) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, cell.contentView.bounds.size.width-20, 20)];
            [cell addSubview:titleLabel];
            UIView *buttonView = [[UIView alloc]init];
            [cell addSubview:buttonView];
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@10);
                make.right.equalTo(@-10);
                make.bottom.equalTo(@-10);
                make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(10);
            }];
            if (indexPath.row == 0) {
                titleLabel.text = NSLocalizedString(@"当前用药", @"");
                if (showMedic == 0||(showMedic == 1&&_isFriend)) {
                    [self addMedicBTNs:_friendMedicalArray View:buttonView];
                }
            }else if (indexPath.row == 1){
                titleLabel.text = NSLocalizedString(@"当前疾病", @"");
                if (showDisease == 0||(showDisease == 1&&_isFriend)) {
                    [self addDiseaseBTNs:_friendDiseaseArray View:buttonView];
                }
            }
        }else{
            cell.textLabel.text = NSLocalizedString(@"识别结果", @"");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else{
        if (_isFriend) {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"sendmesscell" forIndexPath:indexPath];
                [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
                [[cell.contentView viewWithTag:1] viewWithRadis:10.0];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"deletecell" forIndexPath:indexPath];
                [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
                [[cell.contentView viewWithTag:1] viewWithRadis:10.0];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"addcell" forIndexPath:indexPath];
            [((UIButton *)[cell.contentView viewWithTag:1]) addTarget:self action:@selector(addStrangerFriend:) forControlEvents:UIControlEventTouchUpInside];
            [[cell.contentView viewWithTag:1] viewWithRadis:10.0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    return cell;
}

#pragma 用药和病例可见否的响应函数
-(void)medicalAndDiseaseBool:(id)sender{
    NSLog(@"加入切换判断和响应");
}

#pragma 发送消息和删除好友的响应函数
-(void)sendMess{
    NSLog(@"发送消息");
    RootViewController *rvc = [[RootViewController alloc]init];
    rvc.personJID = _friendJID;
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)deleteFriend{
    NSLog(@"删除好友");
    [[XMPPSupportClass ShareInstance] removeFriend:_friendJID];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)addStrangerFriend:(UIButton *)sender{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SendAddMessViewController *smc = [main instantiateViewControllerWithIdentifier:@"sendaddmessage"];
    smc.addFriendJID = _friendJID;
    [self.navigationController pushViewController:smc animated:YES];
}

#pragma 需要加入传必要的值过去
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //需要加入搜索结果的判断，最好在cell中加入tag
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 1&&indexPath.row == 2) {
        if (showOcrText == 0||(showOcrText == 1&&_isFriend)) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OcrTextResultViewController *otrv = [story instantiateViewControllerWithIdentifier:@"ocrtextresult"];
            otrv.isMine = NO;
            otrv.personJID = _friendJID;
            [self.navigationController pushViewController:otrv animated:YES];
        }else{
            [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"对方未向您开放权限", @"") Title:NSLocalizedString(@"权限不足", @"") ViewController:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)setupView{
    _contactPersonTable.delegate = self;
    _contactPersonTable.dataSource = self;
}

-(void)setupData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //jid获取用户信息
    cellMedicHeightNumber = 0;
    cellDiseaseHeightNumber = 0;
    NSString *jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,_friendJID,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
    NSLog(@"jidurl===%@",jidurl);
    jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[userInfo objectForKey:@"res"] intValue] == 0) {
            _friendName = [userInfo objectForKey:@"nickname"];
            int genderNumber = [[userInfo objectForKey:@"gender"] intValue];
            if (genderNumber == 0) {
                _friendGender = NSLocalizedString(@"男", @"");
            }else{
                _friendGender = NSLocalizedString(@"女", @"");
            }
            _friendAge = [[userInfo objectForKey:@"age"] intValue];
            NSString *imageurl = [NSString stringWithFormat:@"%@%@",PersonImageUrl,[userInfo objectForKey:@"picture"]];
            imageurl = [imageurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            _friendImageUrl = imageurl;
            _friendLocation = [userInfo objectForKey:@"address"];
            if ([[userInfo objectForKey:@"isFriend"] boolValue]) {
                _isFriend = YES;
            }else{
                _isFriend = NO;
            }
            _friendNote = [userInfo objectForKey:@"introduction"];
            _friendMedicalArray = [userInfo objectForKey:@"medicineInfo"];
            _friendDiseaseArray = [userInfo objectForKey:@"disHistoryInfo"];
            showDisease = [[userInfo objectForKey:@"diseasePrivacySetting"] integerValue];
            showMedic = [[userInfo objectForKey:@"medicinePrivacySetting"] integerValue];
            showOcrText = [[userInfo objectForKey:@"ltrPrivacySetting"] integerValue];
            [_contactPersonTable reloadData];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取jid信息失败");
    }];
}

-(void)addMedicBTNs:(NSArray *)array View:(UIView *)view{
    //按钮进行排版
    for (UIView *a in view.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
        }
    }
    int xxxx = 10;
    int newrows = 0;
    
    for (int i = 0; i<array.count; i++) {
        NSString *title = [array[i] objectForKey:@"medicineBrandname"];
        CGSize size = [self get:title];
        CGSize size2;
        if (i!=array.count-1) {
            NSString *title2 = [array[i+1] objectForKey:@"medicineBrandname"];
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
    cellMedicHeightNumber = newrows+1;
}

-(void)addDiseaseBTNs:(NSArray *)array View:(UIView *)view{
    //按钮进行排版
    for (UIView *a in view.subviews) {
        if ([a isKindOfClass:[UIButton class]]) {
            [a removeFromSuperview];
        }
    }
    int xxxx = 10;
    int newrows = 0;
    
    for (int i = 0; i<array.count; i++) {
        NSString *title = [array[i] objectForKey:@"name"];
        CGSize size = [self get:title];
        CGSize size2;
        if (i!=array.count-1) {
            NSString *title2 = [array[i+1] objectForKey:@"name"];
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
    cellDiseaseHeightNumber = newrows+1;
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
//    drugInputText.text = [sender titleForState:UIControlStateNormal];
//    mid = [drugNameArray[sender.tag] objectForKey:@"id"];
}

@end
