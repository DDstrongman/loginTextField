//
//  CameraViewController.m
//  FotoMark
//
//  Created by 李胜书 on 15/6/19.
//  Copyright (c) 2015年 lishengshu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

{
    BOOL filter;
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.cameraViewController setupCameraView];
    [self.cameraViewController setEnableBorderDetection:NO];
    [self updateTitleLabel];
    
    [_albumButton addTarget:self action:@selector(openAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    filter = NO;
    [self.cameraViewController setCameraViewType:IPDFCameraViewTypeNormal];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [_cameraViewController addGestureRecognizer:tapGesture];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.cameraViewController start];
    self.title = NSLocalizedString(@"", @"");
    self.navigationController.navigationBarHidden = YES;
    
//    _lightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [_lightButton setBackgroundImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
//    [_lightButton setTitleColor:themeColor forState:UIControlStateNormal];
//    _lightButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
//    [_lightButton addTarget:self action:@selector(torchToggle:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_lightButton]];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma 下方两个按钮的响应函数
-(void)openAlbum:(id)sender{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

#pragma 点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"获取图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma 点击cancel 调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消获取图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CameraVC Actions

- (void)focusGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        NSLog(@"聚焦");
        CGPoint location = [sender locationInView:self.cameraViewController];
        
        [self focusIndicatorAnimateToPoint:location];
        
        [self.cameraViewController focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint
{
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
     {
         self.focusIndicator.alpha = 1.0;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.4 animations:^
          {
              self.focusIndicator.alpha = 0.0;
          }];
     }];
}

//- (IBAction)borderDetectToggle:(id)sender
//{
//    BOOL enable = !self.cameraViewController.isBorderDetectionEnabled;
//    if (enable) {
//        [_recognizeButton setImage:[UIImage imageNamed:@"edge_on"] forState:UIControlStateNormal];
//    }
//    else{
//        [_recognizeButton setImage:[UIImage imageNamed:@"edge_off"] forState:UIControlStateNormal];
//    }
////    [self changeButton:sender targetTitle:(enable) ? @"CROP On" : @"CROP Off" toStateEnabled:enable];
//    self.cameraViewController.enableBorderDetection = enable;
//    [self updateTitleLabel];
//}
//
//- (IBAction)filterToggle:(id)sender
//{
//    if (filter == YES) {
//        [_filterButton setImage:[UIImage imageNamed:@"colors_off"] forState:UIControlStateNormal];
//        filter = NO;
//    }
//    else{
//        [_filterButton setImage:[UIImage imageNamed:@"colors_on"] forState:UIControlStateNormal];
//        filter = YES;
//    }
//    [self.cameraViewController setCameraViewType:(self.cameraViewController.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? IPDFCameraViewTypeNormal : IPDFCameraViewTypeBlackAndWhite];
//    [self updateTitleLabel];
//}

- (void)torchToggle:(id)sender
{
    BOOL enable = !self.cameraViewController.isTorchEnabled;
    if(enable){
        [_lightButton setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
    }
    else{
        [_lightButton setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
    }
//    [self changeButton:sender targetTitle:(enable) ? @"FLASH On" : @"FLASH Off" toStateEnabled:enable];
    self.cameraViewController.enableTorch = enable;
}

- (void)updateTitleLabel
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    animation.duration = 0.35;
//    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
//    
//    NSString *filterMode = (self.cameraViewController.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? @"TEXT FILTER" : @"COLOR FILTER";
//    self.titleLabel.text = [filterMode stringByAppendingFormat:@" | %@",(self.cameraViewController.isBorderDetectionEnabled)?@"AUTOCROP On":@"AUTOCROP Off"];
}

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark CameraVC Capture Image

- (IBAction)captureButton:(id)sender
{
    [self.cameraViewController captureImageWithCompletionHander:^(id data)
     {
         UIImage *image = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : data;
         NSLog(@"%@",image);
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 //直接跳转处理图片界面
                 ConfirmPictureResultViewController *cfpv = [[ConfirmPictureResultViewController alloc]init];
                 cfpv.resultImage = image;
                 [self.navigationController pushViewController:cfpv animated:YES];
                 NSLog(@"%@",image);
             });
         });

     }];
}

//#pragma 返回图片的delegate
//-(void)photoTweaksViewControllerDone:(UIViewController *)controller ModifyPicture:(UIImage *)image
//{
//    ConfirmPictureResultViewController *cfpv = [[ConfirmPictureResultViewController alloc]init];
//    cfpv.resultImage = image;
//    [self.navigationController pushViewController:cfpv animated:YES];
//    NSLog(@"%@",image);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
