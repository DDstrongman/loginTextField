//
//  UserDiseaseTraitViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/9/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDiseaseTraitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) UITableView *diseaseTrait;//主诉表

@end
