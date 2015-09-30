//
//  CaseViewController.m
//  ResultContained
//
//  Created by 李胜书 on 15/7/2.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import "CaseViewController.h"

#import "MyDoctorRootViewController.h"
#import "HttpManager.h"

#import "ConfirmDiseaseRootViewController.h"
#import "DrugHistroyViewController.h"
#import "UserDiseaseTraitViewController.h"
#import "YizhenClassroomViewController.h"

#import "PhotoTweaksViewController.h"
#import "ConfirmPictureResultViewController.h"

@interface CaseViewController ()<PhotoTweaksViewControllerDelegate>

{
    KRLCollectionViewGridLayout *lineLayout;
    NSMutableArray *titleDataArray;//官方提供的选项的名称数组
    NSMutableArray *imageNameArray;//cell图片名称数组
    NSString *messCount;//收到的医生信息数
    NSString *failedCount;//失败的数目
    NSInteger doneCount;//完成的数目
    NSString *doingCount;//进行中的数目
    NSArray *diseaseArray;//疾病数组
    NSArray *medicArray;//用药数组
}

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //my
    lineLayout=[[KRLCollectionViewGridLayout alloc] init];
    
    //改变layout属性：
    lineLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0,0);
    lineLayout.numberOfItemsPerLine = 1;
    lineLayout.interitemSpacing = 0.2;
    lineLayout.lineSpacing = 0.2;
    lineLayout.aspectRatio = 1.0/0.15;//长宽比例
    lineLayout.headerReferenceSize = CGSizeMake(ViewWidth, 39);
    
    _settingCollection.collectionViewLayout = lineLayout;
    _settingCollection.alwaysBounceVertical = YES;
    _settingCollection.delegate   = self;
    _settingCollection.dataSource = self;
    
    [_settingCollection setClipsToBounds:YES];
    
    _settingCollection.backgroundColor = grayBackgroundLightColor;
    _settingCollection.pagingEnabled = NO;
    
    _settingCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [_checkResultButton addTarget:self action:@selector(gotoOcrTextResult) forControlEvents:UIControlEventTouchUpInside];
    [_cameraNewButton addTarget:self action:@selector(cameRaNewResult:) forControlEvents:UIControlEventTouchUpInside];
    NSNumber *space =  [NSNumber numberWithFloat:(ViewWidth-60*2)/3.2];
    NSNumber *spaceOther =  [NSNumber numberWithFloat:-(ViewWidth-60*2)/3.2];
    [_cameraNewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(space);
    }];
    [_checkResultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(spaceOther);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupData];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.title = NSLocalizedString(@"病历", @"");
#warning 去掉navigationbar下划线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIBaselineAdjustmentNone;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
    UIImage* imageNormal = [UIImage imageNamed:@"case_history_off"];
    UIImage* imageSelected = [UIImage imageNamed:@"case_history_on"];
    self.tabBarItem.selectedImage = [imageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image = [imageNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma 上方两个大按钮的响应函数
-(void)cameRaNewResult:(UIButton *)sender{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"拍报告", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"拍照", @""),NSLocalizedString(@"相册", @""), nil];
    [sheet showInView:self.view];
}

-(void)gotoOcrTextResult{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OcrTextResultViewController *otrv = [story instantiateViewControllerWithIdentifier:@"ocrtextresult"];
    otrv.isMine = YES;
    [self.navigationController pushViewController:otrv animated:YES];
}

#pragma 因为加入了tabbarcontroller，改变系统的navigationbar出现问题，所以自己写一个navigationbar
-(void)initNavigationBar{
    UIView *navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 66)];
    navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav"]];
    //title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, 80, 30)];
    titleLabel.center = CGPointMake(ViewWidth/2, 22+22);
    titleLabel.text = NSLocalizedString(@"病历", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    [self.view addSubview:navigationBar];
}

#pragma collectionview的delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titleDataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"casechoosecell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    ((UIImageView *)[cell.contentView viewWithTag:1]).image = [UIImage imageNamed:imageNameArray[indexPath.row]];
    [((UIImageView *)[cell.contentView viewWithTag:4]) setTintColor:grayBackColor];
    ((UILabel *)[cell.contentView viewWithTag:2]).text = titleDataArray[indexPath.row];
    ((UILabel *)[cell.contentView viewWithTag:3]).textColor = grayLabelColor;
    if (indexPath.row == 0) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = doingCount;
    }else if (indexPath.row == 1) {
        NSString *diseaseTemp;
        if (diseaseArray.count<3) {
            for (NSDictionary *disease in diseaseArray) {
                if (diseaseTemp == nil) {
                    diseaseTemp = [disease objectForKey:@"name"];
                }else{
                    diseaseTemp = [NSString stringWithFormat:@"%@,%@",diseaseTemp,[disease objectForKey:@"name"]];
                }
            }
        }else{
            diseaseTemp = [NSString stringWithFormat:@"%@,%@",[diseaseArray[0] objectForKey:@"name"],[diseaseArray[1] objectForKey:@"name"]];
        }
        ((UILabel *)[cell.contentView viewWithTag:3]).text = diseaseTemp;
    }else if (indexPath.row == 2) {
        NSString *medicTemp;
        if (medicArray.count<3) {
            for (NSDictionary *medic in medicArray) {
                if (medicTemp == nil) {
                    medicTemp = [medic objectForKey:@"medicineBrandname"];
                }else{
                    medicTemp = [NSString stringWithFormat:@"%@,%@",medicTemp,[medic objectForKey:@"medicineBrandname"]];
                }
            }
        }else{
            medicTemp = [NSString stringWithFormat:@"%@,%@",[medicArray[0] objectForKey:@"medicineBrandname"],[medicArray[1] objectForKey:@"medicineBrandname"]];
        }
        ((UILabel *)[cell.contentView viewWithTag:3]).text = medicTemp;
    }else if (indexPath.row == 3) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = messCount;
    }else if (indexPath.row == 4) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"";
    }else if (indexPath.row == 5) {
        ((UILabel *)[cell.contentView viewWithTag:3]).text = @"";
    }
    cell.layer.borderWidth = 0.25;
    cell.layer.borderColor = lightGrayBackColor.CGColor;

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了%ld",(long)indexPath.row);
    if (indexPath.row == 0) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OcrResultGroupViewController *orgv = [main instantiateViewControllerWithIdentifier:@"ocrgroupresult"];
        [self.navigationController pushViewController:orgv animated:YES];
    }else if (indexPath.row == 1){
        ConfirmDiseaseRootViewController *cdrv = [[ConfirmDiseaseRootViewController alloc]init];
        [self.navigationController pushViewController:cdrv animated:YES];
    }else if (indexPath.row == 2){
        DrugHistroyViewController *dhvc = [[DrugHistroyViewController alloc]init];
        [self.navigationController pushViewController:dhvc animated:YES];
    }else if (indexPath.row == 3){
        MyDoctorRootViewController *mdrv = [[MyDoctorRootViewController alloc]init];
        [self.navigationController pushViewController:mdrv animated:YES];
    }else if (indexPath.row == 4){
        UserDiseaseTraitViewController *udtv = [[UserDiseaseTraitViewController alloc]init];
        [self.navigationController pushViewController:udtv animated:YES];
    }else if (indexPath.row == 5){
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        YizhenClassroomViewController *ycv = [main instantiateViewControllerWithIdentifier:@"Yizhenclassroom"];
        [self.navigationController pushViewController:ycv animated:YES];
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(void)setupData{
    titleDataArray = [@[NSLocalizedString(@"原始报告", @""),NSLocalizedString(@"确诊病情", @""),NSLocalizedString(@"用药记录", @""),NSLocalizedString(@"我的医生", @""),NSLocalizedString(@"主诉", @""),NSLocalizedString(@"小易课堂", @"")]mutableCopy];
    imageNameArray = [@[@"reports2",@"diagnose2",@"medication2",@"my_doc",@"patients_c2",@"class"]mutableCopy];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@v2/user/overview?uid=%@&token=%@",Baseurl,[user objectForKey:@"userUID"],[user objectForKey:@"userToken"]];
    NSLog(@"");
    [[HttpManager ShareInstance]AFNetGETSupport:url Parameters:nil SucessBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *source = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        int res=[[source objectForKey:@"res"] intValue];
        if (res == 0) {
            doingCount = [[source objectForKey:@"unviewedDoingCount"] stringValue];
            doneCount = [[source objectForKey:@"unviewedDoneCount"] integerValue];
            messCount = [[source objectForKey:@"unviewedMsgCount"] stringValue];
            failedCount = [[source objectForKey:@"unviewedFailCount"] stringValue];
            medicArray = [source objectForKey:@"medicineInfoList"];
            diseaseArray = [source objectForKey:@"diseaseDetailList"];
            if (doneCount == 0) {
                
            }else{
                [_checkResultButton imageWithRedNumber:doneCount];
            }
            [_settingCollection reloadData];
        }
    } FailedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"点击了===%ld",buttonIndex);
    if (buttonIndex == 0||buttonIndex == 1) {
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        if (buttonIndex == 0) {
            type = UIImagePickerControllerSourceTypeCamera;
        }else{
            type = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // time-consuming task
            
            UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            [picker dismissViewControllerAnimated:YES completion:^{}];
            PhotoTweaksViewController *photoTweaksViewController = [[PhotoTweaksViewController alloc] initWithImage:image];
            photoTweaksViewController.delegate = self;
            photoTweaksViewController.autoSaveToLibray = YES;
            photoTweaksViewController.tag = 3;
//            [self.navigationController pushViewController:photoTweaksViewController animated:YES];
            [picker presentViewController:photoTweaksViewController animated:YES completion:nil];
        });
    });
}

#pragma 返回图片的delegate
-(void)photoTweaksViewControllerDone:(UIViewController *)controller ModifyPicture:(UIImage *)image{
    ConfirmPictureResultViewController *cprv = [[ConfirmPictureResultViewController alloc]init];
    cprv.resultImage = image;
//    [controller.navigationController pushViewController:cprv animated:YES];
    [controller presentViewController:cprv animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
