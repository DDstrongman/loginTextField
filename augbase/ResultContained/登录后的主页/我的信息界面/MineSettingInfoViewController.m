//
//  MineSettingInfoViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/28.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "MineSettingInfoViewController.h"

#import "NewNickNameViewController.h"
#import "NewTeleViewController.h"
#import "NewPasswordViewController.h"
#import "MyDocInfoViewController.h"
#import "MyAgeViewController.h"
#import "MyLocationViewController.h"
#import "MyLocationSectionViewController.h"
#import "MyNoteViewController.h"
#import "MyGenderViewController.h"

#import "ImageViewLabelTextFieldView.h"

#import "WriteFileSupport.h"

#import "WXApi.h"
#import "SetupView.h"

@interface MineSettingInfoViewController ()<EditNickNameDele,EditTeleDele,UpdateAgeDelegate,ChangeNoteDele,ChangeAddressDele,ChangeGenderDele,ChangeRealNameDele,ChangeOtherAddressDele>

{
    UIView *bottomView;//底部输入的view
    UILabel *bottomTitleLabel;
    UIView *visualEffectView;//弹出后模糊背景的view
    NSString *age;//年龄
    
    //微信第三方
    NSString *code;
    NSDictionary *dic;
    NSString *access_token;
    NSString *openID;
    NSString *unID;//唯一的识别码
    NSString *nickName;
    UIImage *headImage;
}

@end

@implementation MineSettingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }else if(section == 1){
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }else{
        return 45;
    }
}

#pragma 此处的cell的具体信息均需要从后端获取
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *settingCellIndentify = @"mineSettingCell";
    UITableViewCell *cell;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:settingCellIndentify];
    }
#warning 设置分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = lightGrayBackColor;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);//上左下右,顺序
    UIImageView *tailImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 8, 15)];
    tailImageView.image = [UIImage imageNamed:@"goin"];
    if (indexPath.section == 0 && indexPath.row == 2) {
        
    }else{
        cell.accessoryView = tailImageView;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = NSLocalizedString(@"头像", @"");
                UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth-50-30,70/2-50/2, 50, 50)];
                [headImgView imageWithRound:NO];
                headImgView.image = [UIImage imageWithContentsOfFile:[[NSUserDefaults standardUserDefaults] objectForKey:@"userImageUrl"]];
                [cell addSubview:headImgView];
            }
                break;
            case 1:
            {
                cell.textLabel.text = NSLocalizedString(@"昵称", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNickName"];
            }
                break;
            case 2:
            {
                cell.textLabel.text = NSLocalizedString(@"战友号", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userYizhenID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            case 3:
            {
                cell.textLabel.text = NSLocalizedString(@"更换手机号", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userTele"];
            }
                break;
            case 4:
            {
                cell.textLabel.text = NSLocalizedString(@"微信绑定", @"");
                BOOL isBind = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChat"] boolValue];
                if (isBind) {
                    cell.detailTextLabel.text = NSLocalizedString(@"微信已绑定", @"");
                }else{
                    cell.detailTextLabel.text = NSLocalizedString(@"微信未绑定", @"");
                }
            }
                break;
            case 5:
            {
                cell.textLabel.text = NSLocalizedString(@"修改密码", @"");
            }
                break;
            case 6:
            {
                cell.textLabel.text = NSLocalizedString(@"我的医生端信息", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userRealName"];
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = NSLocalizedString(@"性别", @"");
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userGender"] intValue] == 0) {
                    cell.detailTextLabel.text = NSLocalizedString(@"男", @"");
                }else{
                    cell.detailTextLabel.text = NSLocalizedString(@"女", @"");
                }
            }
                break;
            case 1:
            {
                cell.textLabel.text = NSLocalizedString(@"年龄", @"");
                cell.detailTextLabel.text = age;
            }
                break;
            case 2:
            {
                cell.textLabel.text = NSLocalizedString(@"地区", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAddress"];
            }
                break;
            default:
                break;
        }
    }else{
        cell.textLabel.text = NSLocalizedString(@"个性签名", @"");
        cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNote"];
        cell.layer.borderWidth = 0.5;
        cell.layer.borderColor = lightGrayBackColor.CGColor;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *pickImageSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"选择头像", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"相册", @""),NSLocalizedString(@"相机", @""), nil];
            pickImageSheet.tag = 888;
            [pickImageSheet showInView:self.view];
        }else if (indexPath.row == 1){
            NewNickNameViewController *nnv = [[NewNickNameViewController alloc]init];
            nnv.editResultDele = self;
            [self.navigationController pushViewController:nnv animated:YES];
        }else if (indexPath.row == 2) {
            
        }else if (indexPath.row == 3){
            NewTeleViewController *ntv = [[NewTeleViewController alloc]init];
            ntv.editTeleResultDele = self;
            [self.navigationController pushViewController:ntv animated:YES];
        }else if (indexPath.row == 4){
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userWeChat"] boolValue]) {
                UIAlertView *showAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"解除微信绑定", @"") message:NSLocalizedString(@"您将要解除微信绑定", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"") otherButtonTitles:NSLocalizedString(@"取消", @""), nil];
                showAlert.tag = 999;
                [showAlert show];
            }else{
                [self testWeixin];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatLoginCode:) name:@"WeChatLoginCode" object:nil];
            }
        }else if (indexPath.row == 5){
            NewPasswordViewController *npv = [[NewPasswordViewController alloc]init];
            [self.navigationController pushViewController:npv animated:YES];
        }else if (indexPath.row == 6){
            MyDocInfoViewController *mdv = [[MyDocInfoViewController alloc]init];
            mdv.changeRealNameDele = self;
            [self.navigationController pushViewController:mdv animated:YES];
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            MyGenderViewController *mgv = [[MyGenderViewController alloc]init];
            mgv.changeGenderDele = self;
            [self.navigationController pushViewController:mgv animated:YES];
        }else if (indexPath.row == 1) {
            MyAgeViewController *mav = [[MyAgeViewController alloc]init];
            mav.updateAge = self;
            [self.navigationController pushViewController:mav animated:YES];
        }else if (indexPath.row == 2) {
            MyLocationViewController *mlv = [[MyLocationViewController alloc]init];
            mlv.popViewController = self;
            mlv.changeOtherAddressDele = self;
            [self.navigationController pushViewController:mlv animated:YES];
        }
    }else{
        MyNoteViewController *mnv = [[MyNoteViewController alloc]init];
        mnv.changeDele = self;
        [self.navigationController pushViewController:mnv animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)UpdateAge:(BOOL)result{
    if (result) {
        [self setupData];
    }
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section != 2) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        footerView.backgroundColor = grayBackgroundLightColor;
        footerView.layer.borderColor = lightGrayBackColor.CGColor;
        footerView.layer.borderWidth = 0.5;
        return footerView;
    }else{
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
        footerView.backgroundColor = grayBackgroundLightColor;
        return footerView;
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
        [_settingTable reloadData];
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)setupView{
    self.title = NSLocalizedString(@"我的信息", @"");
    _settingTable = [[UITableView alloc]init];
    _settingTable.backgroundColor = grayBackgroundLightColor;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = [UIColor clearColor];
    _settingTable.tableHeaderView = headerView;
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    _settingTable.showsVerticalScrollIndicator = NO;
    _settingTable.sectionFooterHeight = 22.0;
    [self.view addSubview:_settingTable];
    [_settingTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
}

-(void)setupData{
    age = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAge"];
    [_settingTable reloadData];
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma delegate在最下方
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 999) {
        if (buttonIndex == 0) {
            NSString *cancelWeChat = [NSString stringWithFormat:@"%@v2/user/third_party/bind",Baseurl];
            NSMutableDictionary *dicWechat = [NSMutableDictionary dictionary];
            [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"] forKey:@"uid"];
            [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] forKey:@"token"];
            [dicWechat setObject:@0 forKey:@"third_party_type"];
            [dicWechat setObject:@"" forKey:@"uuid"];
            [[HttpManager ShareInstance]AFNetPOSTNobodySupport:cancelWeChat Parameters:dicWechat SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                int res=[[source objectForKey:@"res"] intValue];
                if (res == 0) {
                    NSLog(@"解除绑定微信");
                    [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"userWeChat"];
                    [_settingTable reloadData];
                }
            } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
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
    [self updateimg:image];
}

-(void)editNickNameResult:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)editTeleResult:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)changeOtherAddress:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)changeAddress:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)changeNote:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)changeGender:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

-(void)changeRealName:(BOOL)result{
    if (result) {
        [_settingTable reloadData];
    }
}

- (void)getWeChatLoginCode:(NSNotification *)notification {
    NSString *weChatCode = [[notification userInfo] objectForKey:@"code"];
    /*
     使用获取的code换取access_token，并执行登录的操作
     */
    code = weChatCode;
    [self getAccess_token];
}

-(void)testWeixin{
    [self sendAuthRequest];
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
    [WXApi sendReq:req];
}

-(void)getAccess_token
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",weixinID,weixinSecret,code];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                access_token = [dicTemp objectForKey:@"access_token"];
                openID = [dicTemp objectForKey:@"openid"];
                unID = [dicTemp objectForKey:@"unionid"];
                [self getUserInfo];
            }
        });
    });
}

-(void)getUserInfo
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openID];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dicTemp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                nickName = [dicTemp objectForKey:@"nickname"];
                NSLog(@"acces_token===%@,openID====%@,unID====%@",access_token,openID,unID);
                headImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dicTemp objectForKey:@"headimgurl"]]]];
//                [[NSUserDefaults standardUserDefaults]setObject:nickName forKey:@"userNickName"];
                NSString *thirdPartyUrl = [NSString stringWithFormat:@"%@v2/user/login/thirdPartyAccount?token=%@&uuid=%@&third_party_type=%d",Baseurl,access_token,unID,0];
                [[HttpManager ShareInstance]AFNetPOSTNobodySupport:thirdPartyUrl Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    int res=[[source objectForKey:@"res"] intValue];
                    NSLog(@"device activitation source=%@,res=====%d",source,res);
                    if (res == 0) {
                        NSString *cancelWeChat = [NSString stringWithFormat:@"%@v2/user/third_party/bind",Baseurl];
                        NSMutableDictionary *dicWechat = [NSMutableDictionary dictionary];
                        [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"] forKey:@"uid"];
                        [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] forKey:@"token"];
                        [dicWechat setObject:@0 forKey:@"third_party_type"];
                        [dicWechat setObject:@"" forKey:@"uuid"];
                        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:cancelWeChat Parameters:dicWechat SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            int res=[[source objectForKey:@"res"] intValue];
                            if (res == 0) {
                                NSLog(@"解除绑定微信");
                                [[NSUserDefaults standardUserDefaults]setObject:@NO forKey:@"userWeChat"];
                                [_settingTable reloadData];
                            }
                        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }else if(res == 2){
                        [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"请重新授权", @"") Title:NSLocalizedString(@"授权出错", @"") ViewController:self];
                    }else if (res == 45){
                        NSString *blindWeChat = [NSString stringWithFormat:@"%@v2/user/third_party/bind",Baseurl];
                        NSMutableDictionary *dicWechat = [NSMutableDictionary dictionary];
                        [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userUID"] forKey:@"uid"];
                        [dicWechat setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"] forKey:@"token"];
                        [dicWechat setObject:@0 forKey:@"third_party_type"];
                        [dicWechat setObject:unID forKey:@"uuid"];
                        [[HttpManager ShareInstance]AFNetPOSTNobodySupport:blindWeChat Parameters:dicWechat SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                            int res=[[source objectForKey:@"res"] intValue];
                            if (res == 0) {
                                NSLog(@"绑定微信成功");
                                [[NSUserDefaults standardUserDefaults]setObject:@YES forKey:@"userWeChat"];
                                [_settingTable reloadData];
                            }
                        } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }
                } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        });
        
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
