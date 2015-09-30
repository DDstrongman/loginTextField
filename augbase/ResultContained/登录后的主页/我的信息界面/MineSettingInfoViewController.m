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

#import "ImageViewLabelTextFieldView.h"

#import "WriteFileSupport.h"

@interface MineSettingInfoViewController ()<EditNickNameDele,EditTeleDele,UpdateAgeDelegate,ChangeNoteDele,ChangeAddressDele>

{
    UIView *bottomView;//底部输入的view
    UILabel *bottomTitleLabel;
    UIView *visualEffectView;//弹出后模糊背景的view
    NSString *age;//年龄
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }else{
        return 4;
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
    if ((indexPath.section == 0 && indexPath.row == 2)||(indexPath.section == 1 && indexPath.row == 0)) {
        
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
                cell.textLabel.text = NSLocalizedString(@"易诊号", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userJID"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
                break;
            case 3:
            {
                cell.textLabel.text = NSLocalizedString(@"手机号", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userTele"];
            }
                break;
            case 4:
            {
                cell.textLabel.text = NSLocalizedString(@"修改密码", @"");
            }
                break;
            case 5:
            {
                cell.textLabel.text = NSLocalizedString(@"我的医生端信息", @"");
            }
                break;
            default:
                break;
        }
    }else{
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
            case 3:
            {
                cell.textLabel.text = NSLocalizedString(@"个性签名", @"");
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNote"];
            }
                break;
            default:
                break;
        }
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
            NewPasswordViewController *npv = [[NewPasswordViewController alloc]init];
            [self.navigationController pushViewController:npv animated:YES];
        }else if (indexPath.row == 5){
            MyDocInfoViewController *mdv = [[MyDocInfoViewController alloc]init];
            [self.navigationController pushViewController:mdv animated:YES];
        }
    }else{
        if (indexPath.row == 1) {
            MyAgeViewController *mav = [[MyAgeViewController alloc]init];
            mav.updateAge = self;
            [self.navigationController pushViewController:mav animated:YES];
        }else if (indexPath.row == 2) {
            MyLocationViewController *mlv = [[MyLocationViewController alloc]init];
            mlv.popViewController = self;
            [self.navigationController pushViewController:mlv animated:YES];
        }else if(indexPath.row == 3){
            MyNoteViewController *mnv = [[MyNoteViewController alloc]init];
            mnv.changeDele = self;
            [self.navigationController pushViewController:mnv animated:YES];
        }
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    headerView.backgroundColor = grayBackgroundLightColor;
    headerView.layer.borderColor = lightGrayBackColor.CGColor;
    headerView.layer.borderWidth = 0.5;
    return headerView;
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

@end
