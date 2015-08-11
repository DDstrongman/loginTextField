//
//  RootPrivateInfoViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/10.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonSettingViewController.h"

@interface RootPrivateInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *showInfoTable;
//@property (nonatomic,strong) UIButton *deleteButton;

//网络获取的各个个人数据
@property (nonatomic,strong) UIImage *personImage;//头像
@property (nonatomic) NSString *personName;//昵称
@property (nonatomic) NSString *personDescribe;//个性签名
@property (nonatomic) NSString *personRelative;//患者相似度
@property (nonatomic) NSString *personLocation;//患者位置
@property (nonatomic,strong) NSArray *medicalArray;//用药数组
@property (nonatomic,strong) NSArray *diseaseArray;//患病数组

@property (nonatomic) NSString *personJID;//好友的jid


@end
