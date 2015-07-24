//
//  DetailImageOcrViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailImageOcrViewController : UIViewController

@property (nonatomic) BOOL ResultOrING;//判断是显示识别结果还是正在识别的图片,YES是显示结果，NO是正在识别的图片

@property (nonatomic,strong)UIButton *rightButton;//复用的button，两个view唯一的区别
@property (nonatomic,strong)UIButton *leftButton;//返回按钮
@property (nonatomic,strong)IBOutlet UIImageView *showImageView;

@property (nonatomic,strong) UIImage *showImage;
@property (nonatomic) NSString *leftTitle;//返回的title

@end
