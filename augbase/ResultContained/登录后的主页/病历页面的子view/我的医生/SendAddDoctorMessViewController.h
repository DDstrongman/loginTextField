//
//  SendAddDoctorMessViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendAddDoctorMessViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *sendAddMessTable;

@property (nonatomic,strong) NSDictionary *doctorDic;//医生信息字典

@end
