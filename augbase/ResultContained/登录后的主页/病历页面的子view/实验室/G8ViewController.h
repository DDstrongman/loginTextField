//
//  G8ViewController.h
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com.
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>

@interface G8ViewController : UIViewController <G8TesseractDelegate,
                                                UIImagePickerControllerDelegate,
                                                UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageToRecognize;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong,nonatomic) UIImage *ocrModifyImage; // 二值化和锐化等处理过后的化验单，ocr处理对象

- (IBAction)openCamera:(id)sender;
- (IBAction)recognizeSampleImage:(id)sender;
- (IBAction)backNavigationAct:(id)sender;//自定义navigationbar返回响应事件

@end
