//
//  StartShareViewController.h
//  Yizhenapp
//
//  Created by 李胜书 on 15/10/8.
//  Copyright © 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartShareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *yizhenDoctorTablel;//易诊医生的表格

@property (nonatomic,strong) NSString *doctorJID;//医生jid

@property (nonatomic,strong) UIViewController *rootDoctorViewController;//

@property (nonatomic,strong) NSDictionary *doctorDic;//

@end
