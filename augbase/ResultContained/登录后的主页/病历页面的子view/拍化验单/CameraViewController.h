//
//  CameraViewController.h
//  FotoMark
//
//  Created by 李胜书 on 15/6/19.
//  Copyright (c) 2015年 lishengshu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IPDFCameraViewController.h"

#import "ConfirmPictureResultViewController.h"

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraViewController;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;


@property (strong, nonatomic) UIButton *lightButton;
//@property (weak, nonatomic) IBOutlet UIButton *filterButton;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
//@property (weak, nonatomic) IBOutlet UIButton *recognizeButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;


- (IBAction)focusGesture:(id)sender;

- (IBAction)captureButton:(id)sender;


@end
