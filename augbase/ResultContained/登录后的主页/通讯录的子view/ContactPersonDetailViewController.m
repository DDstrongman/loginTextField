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

#import "FriendDBManager.h"

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
        return 1;
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
        return 160;
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
            ((UILabel *)[cell.contentView viewWithTag:3]).text = [NSString stringWithFormat:@"%ld%@",_similar,@"%"];
            ((UILabel *)[cell.contentView viewWithTag:4]).text = [NSString stringWithFormat:@"%@/%d",_friendGender,_friendAge];
            [((UIButton *)[cell.contentView viewWithTag:5]) setTitle:_friendLocation forState:UIControlStateNormal];
            
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"privatenotecell" forIndexPath:indexPath];
            if ([_friendNote isEqualToString:@""]||_friendNote == nil) {
                ((UILabel *)[cell.contentView viewWithTag:1]).text = NSLocalizedString(@"TA还在休息呢，暂无签名", @"");
            }else{
                ((UILabel *)[cell.contentView viewWithTag:1]).text = _friendNote;
            }
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"contactreportcell";
        cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.row != 2) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, cell.contentView.bounds.size.width-30, 20)];
            [cell addSubview:titleLabel];
            UIView *buttonView = [[UIView alloc]init];
            [cell addSubview:buttonView];
            [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.right.equalTo(@-15);
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
                [((UIButton *)[cell.contentView viewWithTag:2]) addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView viewWithTag:2].layer.borderWidth = 0.5;
                [cell.contentView viewWithTag:2].layer.borderColor = [UIColor orangeColor].CGColor;
                [[cell.contentView viewWithTag:2] viewWithRadis:10.0];
                cell.backgroundColor = grayBackgroundLightColor;
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
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    footerView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    return footerView;
}

-(void)setupView{
    _contactPersonTable.delegate = self;
    _contactPersonTable.dataSource = self;
    _contactPersonTable.backgroundColor = grayBackgroundLightColor;
}

-(void)setupData{
    [[SetupView ShareInstance]showHUD:self Title:NSLocalizedString(@"加载中", @"")];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //jid获取用户信息
    cellMedicHeightNumber = 0;
    cellDiseaseHeightNumber = 0;
    NSString *jidurl;
    if (_isJIDOrYizhenID) {
        jidurl = [NSString stringWithFormat:@"%@v2/user/jid/%@?uid=%@&token=%@",Baseurl,_friendJID,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
    }else{
        jidurl = [NSString stringWithFormat:@"%@v2/user/yizhen_id/%@?uid=%@&token=%@",Baseurl,_friendJID,[defaults objectForKey:@"userUID"],[defaults objectForKey:@"userToken"]];
    }
    NSLog(@"jidurl===%@",jidurl);
    jidurl = [jidurl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    [manager GET:jidurl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([[userInfo objectForKey:@"res"] intValue] == 0) {
            _friendName = [userInfo objectForKey:@"username"];
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
            FMResultSet *isFriendArray = [[FriendDBManager ShareInstance] SearchOneFriend:YizhenFriendName FriendJID:_friendJID];
            int isfriendInt = 0;
            while ([isFriendArray next]){
                isfriendInt++;
            }
            if (isfriendInt == 0) {
                _isFriend = NO;
            }else{
                _isFriend = YES;
            }
            if ([[userInfo objectForKey:@"introduction"] isEqualToString:@""]) {
                
            }else{
                _friendNote = [userInfo objectForKey:@"introduction"];
            }
            _friendMedicalArray = [userInfo objectForKey:@"medicineInfo"];
            _friendDiseaseArray = [userInfo objectForKey:@"disCurrentInfo"];
            showDisease = [[userInfo objectForKey:@"diseasePrivacySetting"] integerValue];
            showMedic = [[userInfo objectForKey:@"medicinePrivacySetting"] integerValue];
            showOcrText = [[userInfo objectForKey:@"ltrPrivacySetting"] integerValue];
            _similar = [[userInfo objectForKey:@"similarity"] integerValue];
            _friendJID = [userInfo objectForKey:@"jid"];
            [_contactPersonTable reloadData];
            [[SetupView ShareInstance]hideHUD];
        }else{
            [[SetupView ShareInstance]hideHUD];
            [[SetupView ShareInstance]showAlertView:[[userInfo objectForKey:@"res"] intValue] Hud:nil ViewController:self];
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
        NSString *title;
        if (array.count>0) {
            title = [array[i] objectForKey:@"medicineBrandname"];
        }else{
            title = NSLocalizedString(@"没有用药", @"");
        }
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
        
        NSString *title;
        if (array.count>0) {
            title = [array[i] objectForKey:@"name"];
        }else{
            title = NSLocalizedString(@"没有病史", @"");
        }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
