//
//  MyDoctorDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDoctorDetailViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIImageView *titleImageView;//医生头像
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;//医生名字
@property (nonatomic,strong) IBOutlet UILabel *hospitalLabel;//医生医院
@property (nonatomic,strong) IBOutlet UILabel *doctorDetalLabel;//医生详细信息
@property (nonatomic,strong) IBOutlet UIButton *addDoctorButton;//添加医生

@property (nonatomic,strong) NSDictionary *doctorDic;//医生信息字典

@end
