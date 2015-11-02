//
//  ConfirmPictureResultViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/27.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

@protocol OpenCameraDele <NSObject>

@required
-(void)openCamera:(BOOL)openBool;//打开照相机

@end

#import <UIKit/UIKit.h>

@interface ConfirmPictureResultViewController : UIViewController<UITabBarDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UIImageView *resultImageView;
@property (nonatomic,strong) IBOutlet UITabBar *bottomTabBar;

@property (nonatomic,strong)  UIImage *resultImage;

@property (nonatomic,weak) id<OpenCameraDele> openCameraDele;

@end
