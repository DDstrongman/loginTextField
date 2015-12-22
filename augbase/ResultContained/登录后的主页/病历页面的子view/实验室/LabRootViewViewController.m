//
//  LabRootViewViewController.m
//  Yizhenapp
//
//  Created by 李胜书 on 15/11/30.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import "LabRootViewViewController.h"
#import "RemindCameraViewController.h"
#import "G8ViewController.h"
#import "PhotoTweaksViewController.h"

@interface LabRootViewViewController ()<RemindCameraDele>

@end

@implementation LabRootViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

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
    cell.accessoryView = tailImageView;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"自动识别机器人", @"");
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld消息,执行跳转",(long)indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍摄教程", @""),NSLocalizedString(@"拍照", @""),NSLocalizedString(@"相册", @""), nil];
            [sheet showInView:self.view];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 添加头和尾
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 22)];
    footerView.backgroundColor = grayBackgroundLightColor;
    footerView.layer.borderColor = lightGrayBackColor.CGColor;
    footerView.layer.borderWidth = 0.5;
    return footerView;
}

-(void)setupView{
    self.title = NSLocalizedString(@"实验室", @"");
    _LabTable = [[UITableView alloc]init];
    _LabTable.backgroundColor = grayBackgroundLightColor;
    _LabTable.delegate = self;
    _LabTable.dataSource = self;
    _LabTable.showsVerticalScrollIndicator = NO;
    _LabTable.sectionHeaderHeight = 22.0;
    _LabTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_LabTable];
    [_LabTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@0);
    }];
    [[SetupView ShareInstance]showAlertView:NSLocalizedString(@"该部分功能仍在完善中，但可以先让战友们先行体验，以便以后正式上线后更快上手", @"") Title:NSLocalizedString(@"实验室是战友APP正在测试中的功能", @"") ViewController:self];
}

-(void)setupData{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击了===%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        RemindCameraViewController *rcv = [[RemindCameraViewController alloc]init];
        rcv.remindCameraDele = self;
        [self.navigationController pushViewController:rcv animated:YES];
    }else if (buttonIndex == 1||buttonIndex == 2) {
        BOOL remind = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userRemindCamera"] boolValue];
        if (buttonIndex == 1 && !remind) {
            RemindCameraViewController *rcv = [[RemindCameraViewController alloc]init];
            rcv.remindCameraDele = self;
            [self.navigationController pushViewController:rcv animated:YES];
        }else{
            UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
            if (buttonIndex == 1) {
                type = UIImagePickerControllerSourceTypeCamera;
            }else{
                type = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.allowsEditing = NO;
            picker.delegate = self;
            picker.sourceType = type;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }else{
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
            [picker dismissViewControllerAnimated:YES completion:^{}];
            PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
            photoTweaksViewController.delegate = self;
            photoTweaksViewController.autoSaveToLibray = YES;
            photoTweaksViewController.tag = 3;
            [self.navigationController pushViewController:photoTweaksViewController animated:YES];
        });
    });
}

#pragma 返回图片的delegate
-(void)photoTweaksViewControllerDone:(UIViewController *)controller ModifyPicture:(UIImage *)image{
    G8ViewController *g8v = [[G8ViewController alloc]init];
    g8v.ocrModifyImage = image;
    [controller.navigationController pushViewController:g8v animated:YES];
}

#pragma 提醒完了之后打开摄像机
-(void)RemindCameraResult:(BOOL)result{
    if (result) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        type = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma 滑动scrollview取消输入
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma 取消输入操作
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
