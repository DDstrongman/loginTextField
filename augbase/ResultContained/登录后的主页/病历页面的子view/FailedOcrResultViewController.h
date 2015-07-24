//
//  FailedOcrResultViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/22.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedOcrResultViewController : UIViewController

@property (nonatomic,strong)IBOutlet UIImageView *failResultImageView;
@property (nonatomic,strong)IBOutlet UILabel *failCategoryText;
@property (nonatomic,strong)IBOutlet UILabel *failDetailText;
@property (nonatomic,strong)IBOutlet UIButton *cameraAgainButton;

@property (nonatomic,strong) UIImage *failedImage;


@end
