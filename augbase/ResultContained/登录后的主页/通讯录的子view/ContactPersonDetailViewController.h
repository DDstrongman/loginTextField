//
//  ContactPersonDetailViewController.h
//  ResultContained
//
//  Created by 李胜书 on 15/7/15.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactPersonDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *contactPersonTable;//查看和设置的tableview

@property (nonatomic,strong) NSString *friendJID;//好友的jid


//网络获取的各个个人数据
@property (nonatomic,strong) NSString *friendImageUrl;//头像
@property (nonatomic) NSString *friendName;//昵称
@property (nonatomic) NSString *friendGender;//性别
@property (nonatomic) int friendAge;//年龄
@property (nonatomic) NSString *friendRelative;//患者相似度
@property (nonatomic) NSString *friendLocation;//患者位置
@property (nonatomic) NSString *friendNote;//患者签名
@property (nonatomic) BOOL isFriend;//是否是好友
@property (nonatomic) NSInteger similar;//患者相似度
@property (nonatomic,strong) NSArray *friendMedicalArray;//用药数组
@property (nonatomic,strong) NSArray *friendDiseaseArray;//患病数组

@property (nonatomic) BOOL isJIDOrYizhenID;//判断是否是jid，yes代表是，no不是，是YizhenID

@end
